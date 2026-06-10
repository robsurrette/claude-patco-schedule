#!/usr/bin/env python3
"""Convert an official PATCO timetable PDF into the app's ScheduleDocument JSON.

Usage:
    python3 parse_timetable.py [--pdf PATH] [--out PATH] [--version N]

The PDF layout this parser expects (stable across PATCO's printed timetables):

  * Page 1: MONDAY-FRIDAY section. Page 2: SATURDAY (top) and SUNDAY (bottom)
    sections, split by the "SUNDAY" header's y position.
  * Each section is two side-by-side 14-column tables. The LEFT table is
    "WESTBOUND TO PHILADELPHIA, PA" (Lindenwold -> 15/16th & Locust) and the
    RIGHT table is "EASTBOUND TO LINDENWOLD, NJ" (the reverse).

    NOTE the app's Direction enum is the OPPOSITE of PATCO's signage: in the
    app, `eastbound` means toward Philadelphia (increasing station index).
    This script emits the app's convention: left table -> "eastbound",
    right table -> "westbound".

  * Each table row is one train run. A cell is either a time ("4:30A",
    "12:16P") or an arrow glyph (extracted as "à") meaning the train skips
    that station. Cells are matched to columns by x position.
  * Times within a run that cross midnight (e.g. 11:50P -> 12:18A) are
    normalized by adding 24h, matching the schema's minutes-after-midnight
    contract (values may exceed 1439).

The output is validated (column count, strict monotonicity, plausible run
durations, spot-checked known cells) and the script exits non-zero on any
violation, so a malformed or redesigned PDF can never produce a silently
wrong schedule. The parsing/validation internals live in `patco_pdf.py`,
shared with the special-schedule pipeline (`update_specials.py`), where a
validation failure downgrades that date to an alert-only banner instead of
published times.
"""

import argparse
import datetime as dt
import json
import sys
from pathlib import Path

from patco_pdf import STATIONS, parse_pdf, validate

# Cells pinned to the 12/1/2025 edition: the first weekday train and the
# 12:00A Saturday owl train (whose skipped closed stations exercise arrows).
SPOT_CHECKS = {
    "weekday-eastbound-000": (
        {"stationId": "lindenwold", "minutes": 270},
        {"stationId": "15-16th-locust", "minutes": 298},
    ),
    "saturday-eastbound-000": (
        {"stationId": "lindenwold", "minutes": 0},
        {"stationId": "15-16th-locust", "minutes": 28},
    ),
}


def main():
    here = Path(__file__).resolve().parent
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--pdf", default=here / "data/PATCO_Timetable_20251201.pdf")
    ap.add_argument("--out", default=here.parent / "PATCOSchedule/Resources/Schedule.json")
    ap.add_argument("--version", type=int, default=20251201,
                    help="monotonic content version (YYYYMMDD of effective date)")
    args = ap.parse_args()

    services = parse_pdf(args.pdf)
    problems = validate(services, spot_checks=SPOT_CHECKS)
    if problems:
        for p in problems:
            print(f"VALIDATION FAILED: {p}", file=sys.stderr)
        return 1

    document = {
        "version": args.version,
        "generatedAt": dt.datetime.now(dt.timezone.utc)
            .isoformat(timespec="seconds").replace("+00:00", "Z"),
        "stationOrder": STATIONS,
        "services": services,
    }
    out = Path(args.out)
    out.write_text(json.dumps(document, indent=1) + "\n")

    for s in services:
        skips = sum(
            len(STATIONS) - len(t["stops"]) for t in s["trains"])
        print(f"{s['dayType']:>14} {s['direction']:>9}: "
              f"{len(s['trains']):3d} trains, {skips} skipped stops")
    print(f"wrote {out} ({out.stat().st_size // 1024} KB)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
