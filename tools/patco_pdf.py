"""Shared parser for official PATCO timetable PDFs.

Used by `parse_timetable.py` (bundled baseline Schedule.json) and
`update_specials.py` (the special-schedules feed pipeline). See
`parse_timetable.py` for a description of the PDF layout and the direction
naming caveat (the app's `eastbound` = PATCO's signed WESTBOUND to Philly).

Everything raises ParseError rather than guessing: a malformed or redesigned
PDF must fail validation, never produce a silently wrong timetable.
"""

from __future__ import annotations

import re
from collections import defaultdict

import pdfplumber

# Station ids in west->east app order (must mirror Station.all in Swift).
STATIONS = [
    "lindenwold", "ashland", "woodcrest", "haddonfield", "westmont",
    "collingswood", "ferry-avenue", "broadway", "city-hall",
    "franklin-square", "8th-market", "9-10th-locust", "12-13th-locust",
    "15-16th-locust",
]

TIME_RE = re.compile(r"^(\d{1,2}):(\d{2})([AP])$")
ARROW = "à"  # the "station closed / will not stop" glyph as extracted

ROW_Y_TOLERANCE = 2.5     # cells whose tops differ by <= this are one row
COLUMN_X_TOLERANCE = 9.0  # max |x0 - column center| to claim a cell
MIN_RUN_MINUTES = 20      # full Lindenwold<->15/16th runs take ~28 min
MAX_RUN_MINUTES = 45


class ParseError(Exception):
    pass


def to_minutes(text: str) -> int:
    h, m, ap = TIME_RE.match(text).groups()
    h, m = int(h), int(m)
    if h == 12:
        h = 0
    if ap == "P":
        h += 12
    return h * 60 + m


def cluster(values, gap):
    """Group sorted scalars into clusters split where adjacent gap > `gap`."""
    groups = []
    for v in sorted(values):
        if groups and v - groups[-1][-1] <= gap:
            groups[-1].append(v)
        else:
            groups.append([v])
    return groups


def section_words(page, y_min, y_max):
    return [
        w for w in page.extract_words()
        if y_min <= w["top"] < y_max
        and (TIME_RE.match(w["text"]) or w["text"] == ARROW)
    ]


def find_columns(words):
    """Locate the 28 column x-centers from the section's time tokens."""
    xs = [w["x0"] for w in words if TIME_RE.match(w["text"])]
    groups = [g for g in cluster(xs, 5.0) if len(g) >= 3]  # drop stray notes
    if len(groups) != 28:
        raise ParseError(f"expected 28 time columns, found {len(groups)}")
    return [sum(g) / len(g) for g in groups]


def parse_section(page, y_min, y_max):
    """Return (eastbound_runs, westbound_runs); each run is [(station_id, minutes)]."""
    words = section_words(page, y_min, y_max)
    centers = find_columns(words)

    # Assign every cell to (row, column).
    rows = defaultdict(dict)  # row_y -> {col_index: text}
    row_ys = [g[0] for g in cluster([w["top"] for w in words], ROW_Y_TOLERANCE)]
    for w in words:
        row = min(row_ys, key=lambda y: abs(w["top"] - y))
        if abs(w["top"] - row) > ROW_Y_TOLERANCE:
            raise ParseError(f"cell {w['text']!r} fits no row (top={w['top']:.1f})")
        col = min(range(28), key=lambda c: abs(w["x0"] - centers[c]))
        if abs(w["x0"] - centers[col]) > COLUMN_X_TOLERANCE:
            raise ParseError(f"cell {w['text']!r} fits no column (x0={w['x0']:.1f})")
        if col in rows[row]:
            raise ParseError(f"two cells in row y={row:.0f} col {col}")
        rows[row][col] = w["text"]

    # Left table (cols 0-13) runs Lindenwold->Philly = app "eastbound";
    # right table (cols 14-27) is the reverse.
    east, west = [], []
    for y in sorted(rows):
        cells = rows[y]
        for side, dest, order in ((0, east, STATIONS), (14, west, STATIONS[::-1])):
            run, prev = [], None
            for i, station in enumerate(order):
                text = cells.get(side + i)
                if text is None or text == ARROW:
                    continue
                minutes = to_minutes(text)
                if prev is not None and minutes < prev:
                    minutes += 24 * 60  # run crosses midnight
                if prev is not None and minutes <= prev:
                    raise ParseError(f"non-increasing time {text} in row y={y:.0f}")
                prev = minutes
                run.append((station, minutes))
            if run:
                if len(run) < 2:
                    raise ParseError(f"single-stop run in row y={y:.0f}")
                duration = run[-1][1] - run[0][1]
                if not MIN_RUN_MINUTES <= duration <= MAX_RUN_MINUTES:
                    raise ParseError(
                        f"implausible duration {duration}min in row y={y:.0f}")
                dest.append(run)
    return east, west


def find_header_y(page, text):
    for w in page.extract_words():
        if w["text"] == text and w.get("upright"):
            return w["top"]
    raise ParseError(f"header {text!r} not found on page")


def parse_pdf(path):
    """Parse a full PATCO timetable PDF into the ServiceSchedule JSON shape."""
    with pdfplumber.open(path) as pdf:
        if len(pdf.pages) != 2:
            raise ParseError(f"expected 2 pages, got {len(pdf.pages)}")
        weekday_page, weekend_page = pdf.pages

        # Page 1 is entirely MONDAY-FRIDAY (no owl service; stations close
        # 12:00-4:30 AM weeknights). Column matching already excludes stray
        # note tokens, but we still skip the header band defensively.
        note_y = find_header_y(weekday_page, "MONDAY")
        sections = {"weekday": (weekday_page, note_y, weekday_page.height)}

        sunday_y = find_header_y(weekend_page, "SUNDAY")
        sections["saturday"] = (weekend_page, 0, sunday_y)
        sections["sundayHoliday"] = (weekend_page, sunday_y, weekend_page.height)

        services = []
        for day_type, (page, y0, y1) in sections.items():
            east, west = parse_section(page, y0, y1)
            for direction, runs in (("eastbound", east), ("westbound", west)):
                services.append({
                    "dayType": day_type,
                    "direction": direction,
                    "trains": [
                        {
                            "id": f"{day_type}-{direction}-{i:03d}",
                            "stops": [
                                {"stationId": s, "minutes": m} for s, m in run
                            ],
                        }
                        for i, run in enumerate(runs)
                    ],
                })
        return services


def validate(services, spot_checks=()):
    """Cross-cutting sanity checks beyond per-run validation.

    `spot_checks` optionally maps train ids to expected (first_stop, last_stop)
    pairs pinned to a known timetable edition; pass () for special schedules
    where exact cells aren't known in advance.
    """
    problems = []
    by_key = {(s["dayType"], s["direction"]): s["trains"] for s in services}
    if len(by_key) != 6:
        problems.append(f"expected 6 (dayType, direction) services, got {len(by_key)}")

    for (day, direction), trains in by_key.items():
        if not 30 <= len(trains) <= 120:
            problems.append(f"{day}/{direction}: suspicious train count {len(trains)}")
        for t in trains:
            ids = [s["stationId"] for s in t["stops"]]
            expected = STATIONS if direction == "eastbound" else STATIONS[::-1]
            order = [s for s in expected if s in ids]
            if ids != order:
                problems.append(f"{t['id']}: stops out of line order")
            if len(set(ids)) != len(ids):
                problems.append(f"{t['id']}: duplicate station")
        departures = [t["stops"][0]["minutes"] for t in trains]
        if departures != sorted(departures):
            problems.append(f"{day}/{direction}: trains not sorted by departure")

    spot = {t["id"]: t for s in services for t in s["trains"]}
    for train_id, (first, last) in dict(spot_checks).items():
        t = spot.get(train_id)
        if not t or t["stops"][0] != first or t["stops"][-1] != last:
            problems.append(f"{train_id} spot check failed (expected {first}..{last})")
    return problems
