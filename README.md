# PATCO Schedule (rebuild)

A from-scratch SwiftUI rebuild of the **PATCO Schedule** iOS app, based on the
"Up Next" redesign in [`design_handoff_patco_schedule/`](design_handoff_patco_schedule).

Ships as an update to the existing App Store listing — bundle id
`com.robsurrette.PatcoTrainSchedule`.

## Status: skeleton + design system

This first phase establishes the foundation. Screen implementations follow,
tab by tab.

**In place**
- Hand-written Xcode project (`PATCOSchedule.xcodeproj`) using Xcode 16
  file-system synchronized groups — new files under `PATCOSchedule/` are picked
  up automatically, no project edits needed.
- Design tokens from the handoff: `PTColor`, `PTFont`, `PTRadius`, `PTSpacing`,
  `PTShadow` (`PATCOSchedule/DesignSystem/`).
- Circular Std fonts bundled + registered via `UIAppFonts`.
- Shared components: `PTCard`, `PTPill`, `SectionHeader`, `Hairline`,
  `PulsingDot`, `StationRailDot`, `RouteEndpointIndicator`, `StickyHeader`.
- Root scaffold (`RootTabView`, a native `TabView` with iOS 26 Liquid Glass) +
  observable state (`AppState`,
  `FavoritesStore`, `PremiumStore`, `ClockTicker`).
- Model layer + the bundled-/remote-shared schedule schema, with
  `Schedule.json` — the real PATCO timetable (effective 12/1/2025), generated
  from the official PDF by `tools/parse_timetable.py` (all day types, both
  directions, including skip-stop "station closed" runs).
- Service seams: `ScheduleProvider` (bundled now, remote-refresh later),
  `FareProvider` (zone-based), `AdProvider` (no-op now, AdMob later),
  StoreKit 2 in `PremiumStore`.
- Special-schedule pipeline (see below): adjusted times appear in the app
  automatically and stay available offline once cached.
- Four placeholder screens wired to the design system + data layer.

## Special schedules

PATCO posts a special-schedule PDF (same layout as the printed timetable)
for individual dates. The pieces that make those show up in the app:

1. **Pipeline** — `.github/workflows/special-schedules.yml` runs
   `tools/update_specials.py` every 6 hours: it scans RidePATCO.org for
   special-schedule PDF links, parses each new PDF with the shared parser
   (`tools/patco_pdf.py`), extracts the affected dates, and publishes
   `specials.json` to the orphan `feed` branch.
   *Trust model:* a PDF that parses and validates is published as the
   complete timetable for its dates; anything doubtful (parse failure,
   ambiguous dates) is published `alertOnly` — a banner over the regular
   schedule, never wrong times.
2. **Feed** — GitHub Pages serves the `feed` branch:
   `https://robsurrette.github.io/claude-patco-schedule/specials.json`
   (plus `schedule.json`, the future remote-refresh source for new base
   timetables).
3. **App** — `SpecialScheduleStore` fetches the feed on launch/foreground
   (ETag-conditional) and via Background App Refresh, persisting the last
   good copy so it works offline. `OverlayScheduleSource` swaps in the
   special timetable on covered dates; trips that differ from the bundled
   baseline get an "Adjusted" tag, and `ScheduleView` shows an amber banner.

**One-time setup:** enable GitHub Pages (Settings → Pages → Deploy from a
branch → `feed`, `/ (root)`) after the workflow's first run creates the
branch. If PATCO's site blocks the scraper or moves the special-schedules
page, adjust `DEFAULT_PAGES` in `tools/update_specials.py` — the first
scheduled run's warnings will tell you.

## Requirements
- Xcode 16+ (uses file-system synchronized groups, `objectVersion = 77`)
- iOS 17.0+ deployment target

Open `PATCOSchedule.xcodeproj` and run on an iPhone simulator.

## Things to wire before shipping (TODOs)
- **Schedule refresh** — bundled `Schedule.json` is the real 12/1/2025
  timetable. When PATCO publishes a new effective timetable, regenerate with
  `python3 tools/parse_timetable.py --pdf <new.pdf> --version <YYYYMMDD>`.
- **GitHub Pages** — enable Pages from the `feed` branch (see "Special
  schedules" above) so `SpecialScheduleStore.feedURL` resolves.
- **Scraper source pages** — verify `DEFAULT_PAGES` in
  `tools/update_specials.py` against the live RidePATCO.org layout after the
  first scheduled run (the site 403s some hosts; the workflow's warnings will
  show whether the runner gets through).
- **Fares** — `ZoneFareProvider` uses placeholder zoning/prices. Drop in PATCO's
  official fare matrix.
- **StoreKit** — set `PremiumStore.removeAdsProductID` to the live App Store
  Connect IAP id so the product loads and existing customers can Restore.
- **Ads** — implement an `AdMobProvider: AdProvider` and the production AdMob
  app/unit ids; swap it in at the root.
- **App icons** — import the 15 alternate icons (`design_handoff.../patco/icons/`)
  into the asset catalog and add `CFBundleAlternateIcons` to Info.plist.
- **App icon (primary)** — `AppIcon` is an empty placeholder set.
- **Circular Std license** — bundled for development; confirm the commercial
  license before shipping.

## Project layout
```
PATCOSchedule/
├─ App/            entry point, root scaffold, service injection
├─ DesignSystem/   tokens + reusable components
├─ Models/         Station, Trip, schedule schema, special-schedule feed schema
├─ Stores/         AppState, FavoritesStore, PremiumStore, SpecialScheduleStore
├─ Services/       ScheduleProvider (bundled + overlay), FareProvider, ClockTicker
├─ Features/       Schedule / StationMap / Info / Settings (placeholders)
└─ Resources/      Fonts, Assets.xcassets, Schedule.json
tools/
├─ patco_pdf.py         shared timetable-PDF parser + validation gate
├─ parse_timetable.py   official PDF → bundled Schedule.json (baseline)
├─ update_specials.py   RidePATCO.org → specials.json feed (pipeline)
└─ data/                source timetable PDFs
```
