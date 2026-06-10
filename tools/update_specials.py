#!/usr/bin/env python3
"""Build the special-schedules feed (specials.json) from RidePATCO.org.

Run by the `special-schedules` GitHub Actions workflow on a cron; output is
published to the `feed` branch and served by GitHub Pages, where the app's
SpecialScheduleStore fetches it.

Usage:
    python3 update_specials.py --out-dir OUT [--state state.json] [--page URL ...]

Behavior (the trust model the app relies on):

  * Scrapes the configured pages for links to special-schedule PDFs
    (links whose URL or anchor text mentions "special").
  * For each new/changed PDF (tracked by content hash in state.json):
      - extracts the affected date(s) from the link text and the PDF text;
      - parses the full timetable with the shared parser (patco_pdf.py)
        and runs the validation gate.
    Both succeed -> the entry carries the COMPLETE timetable for those dates
    and the app substitutes it automatically. Anything fails -> the entry is
    published `alertOnly`, which the app shows as a banner over the regular
    timetable. Wrong times are never published; at worst, un-adjusted ones.
  * Entries whose dates have all passed are pruned. Undated alert-only
    entries are kept only while their PDF is still linked.
  * Also copies the repo's bundled Schedule.json into the feed as
    schedule.json, the future remote-refresh source for new base timetables.

Exits non-zero only on infrastructure errors (all pages unreachable);
per-PDF parse problems degrade to alertOnly by design.
"""

from __future__ import annotations

import argparse
import datetime as dt
import hashlib
import html
import json
import os
import re
import sys
import urllib.parse
import urllib.request
from pathlib import Path
from zoneinfo import ZoneInfo

import pdfplumber

import patco_pdf

SCHEMA_VERSION = 1
EASTERN = ZoneInfo("America/New_York")

DEFAULT_PAGES = [
    "https://www.ridepatco.org/schedules/schedules.asp",
    "https://www.ridepatco.org/",
]

USER_AGENT = (
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 "
    "(KHTML, like Gecko) Chrome/126.0 Safari/537.36 PATCOScheduleApp-feed/1.0"
)

ANCHOR_RE = re.compile(
    r"""<a[^>]+href\s*=\s*["']([^"']+\.pdf[^"']*)["'][^>]*>(.*?)</a>""",
    re.IGNORECASE | re.DOTALL,
)
TAG_RE = re.compile(r"<[^>]+>")

MONTHS = {
    m.lower(): i + 1
    for i, names in enumerate(
        [("january", "jan"), ("february", "feb"), ("march", "mar"),
         ("april", "apr"), ("may",), ("june", "jun"), ("july", "jul"),
         ("august", "aug"), ("september", "sep", "sept"),
         ("october", "oct"), ("november", "nov"), ("december", "dec")])
    for m in names
}
MONTH_PATTERN = "|".join(sorted(MONTHS, key=len, reverse=True))
# "December 25", "Dec. 24 & 25, 2025", "June 14-15". The year must stay on
# the same line — PDF text contains mirrored strings (rotated glyphs) like
# "5202/1/21" on adjacent lines that must not be picked up as years.
WORDY_DATE_RE = re.compile(
    rf"\b({MONTH_PATTERN})\.?[ \t]+"
    rf"(\d{{1,2}}(?!\d)(?:[ \t]*[-–&,][ \t]*\d{{1,2}}(?!\d))*)"
    rf"(?:,?[ \t]*(\d{{4}}))?",
    re.IGNORECASE,
)
NUMERIC_DATE_RE = re.compile(r"\b(\d{1,2})/(\d{1,2})/(\d{2,4})\b")


def fetch(url, binary=False):
    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    with urllib.request.urlopen(req, timeout=30) as resp:
        data = resp.read()
    return data if binary else data.decode("utf-8", errors="replace")


def find_candidate_links(page_url):
    """(absolute_pdf_url, anchor_text) pairs that look like special schedules."""
    html_text = fetch(page_url)
    links = []
    for href, inner in ANCHOR_RE.findall(html_text):
        href = html.unescape(href)
        text = " ".join(html.unescape(TAG_RE.sub(" ", inner)).split())
        if "special" in href.lower() or "special" in text.lower():
            links.append((urllib.parse.urljoin(page_url, href), text))
    return links


def infer_year(month, day, today):
    """Pick the year that puts the date in [today-30d, today+330d]."""
    for year in (today.year - 1, today.year, today.year + 1):
        try:
            candidate = dt.date(year, month, day)
        except ValueError:
            continue
        if -30 <= (candidate - today).days <= 330:
            return candidate
    return None


def extract_dates(text, today):
    """All plausible service dates mentioned in `text`, as date objects."""
    def plausible(year):
        return today.year - 1 <= year <= today.year + 1

    found = set()
    for month_name, days, year in WORDY_DATE_RE.findall(text):
        month = MONTHS[month_name.lower().rstrip(".")]
        for day in re.findall(r"\d{1,2}", days):
            day = int(day)
            if not 1 <= day <= 31:
                continue
            if year and plausible(int(year)):
                try:
                    found.add(dt.date(int(year), month, day))
                except ValueError:
                    pass
            elif (inferred := infer_year(month, day, today)):
                found.add(inferred)
    for m, d, y in NUMERIC_DATE_RE.findall(text):
        m, d, y = int(m), int(d), int(y)
        if y < 100:
            y += 2000
        if not plausible(y):
            continue
        try:
            found.add(dt.date(y, m, d))
        except ValueError:
            pass
    return sorted(found)


def pdf_header_text(path, max_chars=3000):
    """Text from the PDF's first page — where the event dates are announced."""
    with pdfplumber.open(path) as pdf:
        return (pdf.pages[0].extract_text() or "")[:max_chars]


def build_entry(url, anchor_text, pdf_bytes, today, warn):
    """One feed entry for a special-schedule PDF; alertOnly on any doubt."""
    sha = hashlib.sha256(pdf_bytes).hexdigest()
    tmp = Path(f"/tmp/special-{sha[:12]}.pdf")
    tmp.write_bytes(pdf_bytes)

    services = None
    try:
        parsed = patco_pdf.parse_pdf(tmp)
        problems = patco_pdf.validate(parsed)
        if problems:
            warn(f"{url}: validation failed: {problems[:3]}")
        else:
            services = parsed
    except Exception as e:  # ParseError or pdf library failure
        warn(f"{url}: parse failed: {e}")

    # The link text is curated ("Special Schedule – December 25") and is the
    # most reliable date source; only fall back to the PDF's own text.
    dates = extract_dates(anchor_text, today)
    if not dates:
        try:
            dates = extract_dates(pdf_header_text(tmp), today)
        except Exception as e:
            warn(f"{url}: could not read PDF text for dates: {e}")
    if len(dates) > 10:
        warn(f"{url}: {len(dates)} dates extracted, treating as ambiguous")
        dates = []

    if dates:
        span = dates[0].strftime("%b %-d") if len(dates) == 1 else \
            f"{dates[0].strftime('%b %-d')} – {dates[-1].strftime('%b %-d')}"
        title = f"Special Schedule — {span}"
    else:
        title = anchor_text.strip() or "Special Schedule"

    alert_only = services is None or not dates
    entry = {
        "id": sha[:12],
        "dates": [d.isoformat() for d in dates],
        "title": title,
        "message": None,
        "sourceURL": url,
        "alertOnly": alert_only,
        "services": None if alert_only else services,
    }
    if alert_only:
        warn(f"{url}: published ALERT-ONLY "
             f"(parsed={services is not None}, dates={len(dates)})")
    return entry


def main():
    here = Path(__file__).resolve().parent
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--out-dir", required=True)
    ap.add_argument("--state", default=None,
                    help="previous state.json (carried PDF hashes + entries)")
    ap.add_argument("--page", action="append", dest="pages",
                    help="page URL(s) to scan (repeatable)")
    ap.add_argument("--baseline", default=here.parent / "PATCOSchedule/Resources/Schedule.json")
    args = ap.parse_args()

    warnings = []
    def warn(msg):
        warnings.append(msg)
        print(f"::warning::{msg}" if "GITHUB_ACTIONS" in os.environ
              else f"WARNING: {msg}", file=sys.stderr)

    today = dt.datetime.now(EASTERN).date()
    state = {}
    if args.state and Path(args.state).exists():
        try:
            state = json.loads(Path(args.state).read_text())
        except json.JSONDecodeError:
            warn("state.json unreadable; rebuilding from scratch")

    # 1. Collect candidate links across all configured pages.
    candidates, reachable = {}, 0
    for page in (args.pages or DEFAULT_PAGES):
        try:
            for url, text in find_candidate_links(page):
                candidates.setdefault(url, text)
            reachable += 1
        except Exception as e:
            warn(f"could not scan {page}: {e}")
    if not reachable:
        print("ERROR: no source page reachable", file=sys.stderr)
        return 1

    # 2. Build/carry an entry per candidate PDF.
    new_state, entries = {}, []
    for url, text in sorted(candidates.items()):
        try:
            pdf_bytes = fetch(url, binary=True)
        except Exception as e:
            warn(f"could not download {url}: {e}")
            if url in state:  # keep what riders already have
                new_state[url] = state[url]
                entries.append(state[url]["entry"])
            continue
        sha = hashlib.sha256(pdf_bytes).hexdigest()
        prior = state.get(url)
        if prior and prior.get("sha") == sha:
            entry = prior["entry"]
        else:
            entry = build_entry(url, text, pdf_bytes, today, warn)
        new_state[url] = {"sha": sha, "entry": entry}
        entries.append(entry)

    # 3. Prune entries whose dates have all passed (undated entries stay
    #    while linked — step 2 already drops unlinked PDFs).
    cutoff = today.isoformat()
    entries = [
        e for e in entries
        if not e["dates"] or any(d >= cutoff for d in e["dates"])
    ]
    live_ids = {e["id"] for e in entries}
    new_state = {
        u: s for u, s in new_state.items() if s["entry"]["id"] in live_ids
    }

    # 4. Write the feed.
    out = Path(args.out_dir)
    out.mkdir(parents=True, exist_ok=True)
    feed = {
        "schemaVersion": SCHEMA_VERSION,
        "generatedAt": dt.datetime.now(dt.timezone.utc)
            .isoformat(timespec="seconds").replace("+00:00", "Z"),
        "specials": entries,
    }
    (out / "specials.json").write_text(json.dumps(feed, indent=1) + "\n")
    (out / "state.json").write_text(json.dumps(new_state, indent=1) + "\n")
    baseline = Path(args.baseline)
    if baseline.exists():
        (out / "schedule.json").write_text(baseline.read_text())

    print(f"feed: {len(entries)} special(s), {len(warnings)} warning(s)")
    for e in entries:
        kind = "alert-only" if e["alertOnly"] else "full timetable"
        print(f"  {e['id']} [{kind}] dates={e['dates'] or 'none'} {e['title']!r}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
