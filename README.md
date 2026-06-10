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
- Four placeholder screens wired to the design system + data layer.

## Requirements
- Xcode 16+ (uses file-system synchronized groups, `objectVersion = 77`)
- iOS 17.0+ deployment target

Open `PATCOSchedule.xcodeproj` and run on an iPhone simulator.

## Things to wire before shipping (TODOs)
- **Schedule refresh** — bundled `Schedule.json` is the real 12/1/2025
  timetable. When PATCO publishes a new effective timetable, regenerate with
  `python3 tools/parse_timetable.py --pdf <new.pdf> --version <YYYYMMDD>`.
  The remote refresh + daily special-schedule overlay (`RemoteScheduleSource`)
  is a post-MVP seam already accounted for.
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
├─ Models/         Station, Trip, schedule schema, enums, saved routes, appearance
├─ Stores/         AppState, FavoritesStore, PremiumStore (@Observable)
├─ Services/       ScheduleProvider, FareProvider, ClockTicker, AdProvider
├─ Features/       Schedule / StationMap / Info / Settings (placeholders)
└─ Resources/      Fonts, Assets.xcassets, Schedule.json
tools/
├─ parse_timetable.py   official PDF → Schedule.json converter (validating)
└─ data/                source timetable PDFs
```
