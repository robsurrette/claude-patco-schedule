# Handoff: PATCO Schedule — App Redesign ("Direction A / Up Next")

## Overview
This is a redesign of the **PATCO Schedule** iOS app — a rider-facing app for the PATCO Speedline (the 14-station rapid-transit line between Lindenwold, NJ and Center City Philadelphia). The redesign covers the full primary app: a four-tab structure (Schedule, Station Map, Patco Info, Settings) plus a set of modal bottom sheets (station picker, trip details, station info, remove-ads purchase, app-icon picker) and two popovers (saved routes, date picker).

The design language is **"Up Next"** — the Schedule home leads with a large live countdown to the next train rather than a static timetable. The visual style is clean, light, iOS-native, with PATCO red used sparingly as an accent over cool-neutral greys.

## About the Design Files
The files in this bundle are **design references created in HTML/CSS/React-via-Babel** — high-fidelity prototypes showing the intended look, layout, and behavior. **They are not production code to copy directly.** The single HTML file runs React through an in-browser Babel transform with all styles written inline; that is a prototyping convenience, not an architecture to ship.

Your task is to **recreate these designs in the target app's environment**. The original app is a native iOS app, so the natural target is **SwiftUI** (or UIKit). If you are instead building cross-platform, **React Native** is a reasonable choice. Either way: rebuild the screens using the platform's idioms (native navigation, list/table views, sheets, system date pickers), using this prototype as a precise visual + interaction spec — do not embed the HTML in a webview.

## Fidelity
**High-fidelity (hifi).** Colors, typography, spacing, corner radii, shadows, and interactions are all final and intended to be matched closely. Exact values are listed in the **Design Tokens** section and called out per-component below. Where something is intentionally a stand-in (route map, station photos), it is called out as a placeholder.

## Screenshots
Reference renders of every screen and state are in `screenshots/` (iPhone 390×844 frame):
`01-home` (Schedule), `02-station-picker`, `03-station-map`, `04-station-info`, `05-patco-info`, `06-settings`, `07-remove-ads`, `08-app-icon`, `09-trip-details`, `10-date-picker`, `11-saved-routes`.

## How to run the prototype
Open `PATCO - Home Flow.html` in a browser (it must be served alongside its `patco/` folder so the fonts, alternate app icons, and component `.jsx` files resolve). It is fully interactive: switch tabs at the bottom, tap stations / the date / trips on the Schedule tab, tap any station on the Station Map, and open the sheets from Settings.

---

## Design Tokens

### Color palette (from `patco/shared.jsx`, object `PT`)
| Token | Hex | Usage |
|---|---|---|
| `bg` | `#F1F1F4` | App background (cool neutral grey) |
| `card` | `#FFFFFF` | Card / list surfaces |
| `ink` | `#17171B` | Primary text (near-black) |
| `ink2` | `#6C6C75` | Secondary text |
| `ink3` | `#A0A0A8` | Tertiary text / icons |
| `hair` | `rgba(60,60,67,0.10)` | Hairline dividers |
| `hairBold` | `rgba(60,60,67,0.16)` | Stronger hairline |
| `red` | `#D11141` | PATCO brand red — primary accent (sparing) |
| `redSoft` | `#FBE7EC` | Red tint surface (selected rows, badges) |
| `green` | `#1B8A4B` | On-time status, success, toggles-on |
| `greenSoft` | `#E4F3EA` | Green tint surface |
| `amber` | `#B8791C` | Delay / heads-up status |
| `amberSoft` | `#FBEFD8` | Amber tint surface (alert banner) |
| `fill` | `#F1F1F4` | Inset fill chips / icon tiles |
| `fill2` | `#E8E8EC` | Slightly darker fill (close buttons) |

Note a couple of one-off colors used inline: alert-banner text uses `#7A5210` (title) and `#8A6420` (body); Info-tab connecting-transit monograms use brand colors `#1A6DB4` (SEPTA), `#3AA5C4` (River Line), `#E07B1A` (NJ Transit), `#1C2C57` (Amtrak); accessibility tiles use `#E7EEF9` bg / `#3A6FD8` icon.

### Typography
Font family is **Circular Std** (bundled in `patco/fonts/` as `.otf`), in four weights mapped to named families used throughout:
| Family name in code | File | Weight | Typical use |
|---|---|---|---|
| `CircularStd-Book` | CircularStd-Book.otf | Regular (400) | Body, inactive labels |
| `CircularStd-Medium` | CircularStd-Medium.otf | Medium (500) | List labels, station names |
| `CircularStd-Bold` | CircularStd-Bold.otf | Bold (700) | Emphasis, values, active labels |
| `CircularStd-Black` | CircularStd-Black.otf | Heavy (800/900) | Screen titles, big countdown number |

System fallback stack: `-apple-system, system-ui, sans-serif`.

**Circular Std is a licensed/commercial typeface.** It is bundled here only so the prototype renders correctly. Confirm the app already has a valid license before shipping it; otherwise substitute the licensed brand font or a system font (e.g. SF Pro for iOS).

Representative type scale (font-size / weight / letter-spacing):
- Screen title (tab headers): **28px**, Black, `-0.4`
- Sheet titles: **19–23px**, Bold, `-0.3`
- Big "Up Next" countdown number: **48px**, Black, `-1.3`, line-height `0.88`
- Station / list row label: **16.5–17.5px**, Medium
- Trip times: **18px**, Bold, tabular-nums
- Body / secondary: **13–15px**, Book/Medium
- Section headers (overlines): **12.5px**, Bold, UPPERCASE, letter-spacing `0.6`, color `ink2`
- Tab bar labels: **11px**

Numbers that update or align in columns use `font-variant-numeric: tabular-nums`.

### Spacing, radii, shadows
- **Screen padding:** 16px horizontal on content; sticky headers pad `56px` top (status-bar clearance) `16px` sides.
- **Corner radii:** cards/sheets `16–22px`; the big "Up Next" card and summary cards `20px`; sheets top corners `22px`; pills/chips `999px` (full); icon tiles `8–16px`; tab bar `26px`.
- **Shadows:**
  - Resting card: `0 1px 2px rgba(0,0,0,0.04)`
  - Elevated "Up Next" card: `0 5px 18px rgba(17,17,27,0.07)`
  - Popover: `0 16px 40px rgba(17,17,27,0.22)`
  - Date popover: `0 18px 44px rgba(17,17,27,0.24)`
  - Bottom sheet: `0 -10px 40px rgba(0,0,0,0.18)`
  - Tab bar: `0 6px 24px rgba(0,0,0,0.10), 0 0 0 0.5px rgba(0,0,0,0.04)`
- **Hairline dividers:** `0.5px` solid using `hair`, typically inset from the left to align under the row's text (not under the leading icon).
- **Blur:** sticky headers, tab bar, and popovers use `backdrop-filter: blur(18–20px)` over a translucent surface (e.g. `rgba(241,241,244,0.86)`).

### Animations (keyframes in the HTML `<style>`)
- `ptpulse` — live "now" dot: scales 1→2.6 while fading out, `1.8s ease-out infinite`.
- `ptSheetUp` — bottom sheet slides up `22px→0`, `0.32s cubic-bezier(0.32,0.72,0,1)`.
- `ptPop` — popover pops in `translateY(-6px) scale(0.98)→none`, `0.22s cubic-bezier(0.32,0.72,0,1)`.
- Toggle switches transition `background` and knob `left` over `0.2s`.

---

## App Structure & Navigation

**Device frame** (`flow-frame.jsx`): designed for iPhone at **390×844pt**, 46px outer corner radius, with a Dynamic-Island pill (120×34 at top), a custom status bar (`FlowStatusBar`, shows 12:52, signal/wifi/battery glyphs), and a home indicator at the bottom.

**Bottom tab bar** (`FlowTabBar`): a floating, blurred, rounded (26px) bar 14px from the bottom with 4 tabs. Active tab = PATCO red icon + bold label + subtle `rgba(0,0,0,0.05)` rounded background; inactive = `#17171B` icon + book label. Tabs:
1. **Schedule** (clock icon) — default
2. **Station Map** (layers/diamond icon)
3. **Patco Info** (info-circle icon)
4. **Settings** (gear icon)

**Modal sheets** (`Sheet` component): bottom sheets over a `rgba(15,15,20,0.4)` scrim, rounded top corners, with a grabber handle (38×5 pill) at top. Tapping the scrim closes. Heights vary per sheet (88–94%).

App-level state lives in `App()` in the HTML file (see **State Management**).

---

## Screens / Views

### 1. Schedule (Home) — `flow-home.jsx`
**Purpose:** The rider's default screen. Pick origin/destination, pick a date, see the next train as a live countdown, and browse later trips. This is the centerpiece of the redesign.

**Layout (top → bottom):**
- **Sticky header** (blurred): row with title **"Schedule"** (28px Black) on the left and a **"Saved"** pill button on the right (star icon + label; toggles to a dark filled state when its popover is open).
- **Route selector card:** a white rounded (16px) card. On the left, a vertical indicator: hollow ring (origin) → 2px connector → red map-pin (destination). Two stacked tappable rows show **origin** and **destination** station names (17px Medium) separated by a hairline. On the right, a square (42px, radius 11) **swap** button with a vertical two-arrow icon that reverses the route.
- **Day stepper:** a row of three controls — a left chevron button (prev day), a center pill showing a calendar icon + day label ("Today"/"Tomorrow"/weekday) + short date ("Jun 2"), and a right chevron (next day). Tapping the center pill opens the **date popover**. When open, the pill turns `redSoft` with red content.
- **Body:**
  - **"Up Next" card** (elevated, 20px radius): overline `● UP NEXT` (red pulsing dot). A huge countdown **number** (48px Black) of minutes until departure, with "min" and a live `m:ss` ticker beside it. A right-hand block (separated by a hairline) lists **Depart** and **Arrive** clock times. A chevron indicates it's tappable → opens **Trip details**.
  - **Alert banner** (dismissible, amber): warning triangle + bold title ("Minor delays · Westmont") + body ("The 1:33 is running about 3 min behind.") + × to dismiss. Background `amberSoft`.
  - **"Later today"** section: overline header + a white card listing the next ~5 departures. Each row: "depart → arrive" times (18px Bold, tabular) with a small arrow glyph between, a subline ("departs in 18 min", or "+3 min delay · …" in amber when delayed), and a trailing chevron. Each row → **Trip details**.

**Popovers anchored to this screen:**
- **Saved routes popover** (opens from "Saved" pill): 286px-wide card anchored top-right under the header, over a dim scrim. Lists saved routes (Home, Work, a weekend route), each a star + label + sub-route, with a red check on the currently-applied route. Footer row "Save current route" with a red + chip. Selecting a route applies its origin/dest and closes.
- **Date popover** (opens from date pill): an iOS-26-style graphical calendar (`flow-date.jsx`) in a blurred, rounded (20px) popover with a little pointer triangle. Month + year header with a red disclosure chevron and prev/next month chevrons; weekday row (S M T W T F S); day grid where the selected day is a filled red circle and today is red text. Selecting a day sets the date and closes.

**Live behavior:** A 1-second virtual clock (`useTick`) drives the countdown and `m:ss` ticker; trips whose departure has passed drop off the list automatically. Virtual "now" is 12:59; departures are seeded at 1:03, 1:18, 1:33 (+3 min delay), 1:48, 2:03, 2:15, 2:27, 2:42; ride time is a flat 25 min.

### 2. Station Map — `flow-stationmap.jsx`
**Purpose:** See the whole 14-stop line and tap any station for details.
**Layout:** Sticky "Station Map" header, then one white card containing the 14 stations as a vertical route list. Each row has a **rail rendering** on the left (a 3px red vertical line connecting white-filled, red-ringed station dots — no top segment on the first stop, no bottom segment on the last) and the station name (17.5px Medium) + trailing chevron. Tapping a row opens the **Station Info** sheet.
Stations in order (west→east): Lindenwold, Ashland, Woodcrest, Haddonfield, Westmont, Collingswood, Ferry Avenue, Broadway, City Hall, Franklin Square, 8th & Market, 9/10th & Locust, 12/13th & Locust, 15/16th & Locust.

### 3. Patco Info — `flow-info.jsx`
**Purpose:** Contact PATCO + reference links.
**Layout:** Sticky "Patco Info" header, then:
- **Contact PATCO card:** a header label "Contact PATCO", a row of 4 quick-action tiles (54px rounded-16 colored squares): **Call** (green), **Email** (blue `#3A6FD8`), **Website** (ink), **X** (near-black `#111`). Below a hairline, a "Customer service" row with the phone number `(856) 772-6900` in bold tabular.
- **Fares & cards** section: list card with "Fares" and "Reload FREEDOM Card" rows (red-tinted icon tiles, external-link glyph).
- **Station accessibility** section: "Current availability" and "Parking, elevators & bikes" rows (blue-tinted tiles).
- **Connecting transit** section: SEPTA / River Line / NJ Transit / Amtrak rows, each with a colored 2-letter monogram tile and an external-link glyph. *(These rows were recently simplified to single-line labels with no subtitle.)*
> Note: rows on this tab are visually complete but **non-interactive** in the prototype (they're a redesign of the original link list). Wire them to the real destinations (tel:, mailto:, external URLs) when implementing.

### 4. Settings — `flow-settings.jsx`
**Purpose:** Premium upsell, appearance, app icon, feedback.
**Layout:** Sticky "Settings" header, then:
- **Remove Ads card** (or **Ad-free unlocked** confirmation when premium): red-tinted star tile, "Remove ads / Go ad-free · one-time $1.99", and a red "Upgrade" pill. Tapping opens the **Remove Ads** purchase sheet. When premium, it becomes a green-check confirmation card instead.
- **Appearance** section: three theme swatch cards — **Automatic** (split light/dark), **Light**, **Dark** — each a mini phone preview; the selected one gets a red ring + red check + bold label. (Local state in the prototype; not yet persisted.)
- **App icon** card: shows the current icon thumbnail + "Change app icon" + current icon name; opens the **App icon** sheet.
- **Feedback** section: "Submit PATCO feedback" and "Submit app developer feedback" rows.
- **Footer:** "PATCO Schedule" / "Version 4.2.0".

---

## Modal Sheets

### Station picker — `flow-station.jsx`
Opened by tapping origin or destination on Schedule. Title is "Origin station" or "Destination station" + a round × close button. A search field ("Search stations") filters the list live.
- **Favorites** section (shown when not searching, and only if there are favorites): a card listing the user's favorited stations, each with a filled red star on the right to remove it. Tapping the row selects that station.
- **All stations** section: every station as a row with a hollow radio on the left, the name, and a **star toggle** on the right — outline star when not favorited, filled red star when favorited. Tapping the star toggles favorite; tapping the rest of the row selects the station. The currently-selected station shows a `redSoft` background + red check.
- When searching, the heading switches to "Results" and the favorites section hides; an empty state reads `No stations match "…"`.
- **Favorites persistence:** stored in `localStorage` under key `patco.favStations` as a JSON array of station names; defaults to `['Woodcrest', '15/16th & Locust', 'Haddonfield']`. In the real app, persist favorites in the app's own storage (e.g. UserDefaults / a local store) instead.
- **Selection rule** (in `App.onSelectStation`): if you pick a station that equals the *other* end of the route, the two ends swap rather than creating an invalid same-station route.

### Trip details — `flow-trip.jsx`
Opened by tapping the Up Next card or any "Later today" row. Title "Trip details" + ×.
- **Live status** line: pulsing dot (green on-time / amber delayed), optional "+N min delay ·", and "departs in …".
- **Summary card:** Depart (origin + time) / Arrive (dest + time) separated by a hairline, then two fill chips: **One way $3.00** and **Round trip $6.00**.
- **Route map placeholder:** a 150px striped box labeled `route map · Apple Maps` (monospace) — **stand-in for an embedded map**; replace with a real MapKit/route view.
- **Stops list:** "Ride for N stops · 25 min" with a **"Card"** toggle (green when on) that switches whether the stop list sits on a white card. The stop rail shows origin/dest as filled red target dots and intermediate stops as red-ringed dots connected by a 3px red line, each with an interpolated time.

### Station Info — `flow-stationinfo.jsx`
Opened from Station Map. Top is a 200px **station photo placeholder** (striped, labeled `<station> · station photo`, **replace with a real photo**) with an overlaid round × button. Then the station name (30px Black), a **Directions** card (Open in Apple Maps / Open in Google Maps / Station website), and an **Amenities** wrap of chips with geometric glyphs. Amenity set depends on the station: Center-City stations show Elevator/Escalator; others show Parking/Bike racks/Elevator.

### Remove Ads (purchase) — `flow-paywall.jsx`
Opened from Settings. Centered hero: a red gradient rounded-square with a star, "Remove Ads" title, and a one-line pitch. A benefits card (3 rows with green-tinted check/lightning/heart tiles). A **sticky footer** with a red "Buy now · $1.99" button, "Restore purchase" / "Terms" links, and "One-time purchase · no subscription". Purchasing flips app state to premium and closes; this is where you'd wire **StoreKit** in the real app.

### App icon picker — `flow-appicon.jsx`
Opened from Settings. Title "App icon" + ×. A 3-column grid of the real alternate icons (PNGs in `patco/icons/`), grouped into **Colors** (classic, black, white, blue, green, mint, peach, purple, yellow), **Styles** (geometric, neon, monochrome), and **Seasonal** (halloween, snow, holidayLights). Selected icon gets a red ring + red check badge. In the real app this maps to `setAlternateIconName(_:)`.

---

## Interactions & Behavior (summary)
- **Tab switching:** bottom tab bar swaps the active screen; selection state is app-level.
- **Route selection:** tap origin/dest → station picker → select (with auto-swap on collision) → closes and updates the route.
- **Swap:** the swap button reverses origin/dest in place.
- **Date:** prev/next chevrons step the date by ±1 day; the center pill opens a graphical calendar popover; selecting a day updates labels ("Today"/"Tomorrow"/"Yesterday"/weekday + "Mon D").
- **Saved routes:** the Saved pill opens a popover; selecting applies a saved origin/dest pair.
- **Live countdown:** ticks every second; passed trips drop off automatically.
- **Trip details / station info:** open as sheets; close via × or scrim tap.
- **Favoriting:** star toggle on All-stations rows; favorites surface in the Favorites section and persist locally.
- **Premium:** Remove-Ads purchase flips Settings to an "Ad-free unlocked" state.
- **Dismissible alert:** the delay banner on Schedule can be closed with ×.
- **Reduced motion / static contexts:** the pulsing dot and entrance animations are decorative; ensure content is visible without them.

## State Management
App-level state (see `App()` in `PATCO - Home Flow.html`):
- `origin`, `dest` — selected stations (default Woodcrest → 15/16th & Locust)
- `selectedDate` — currently viewed date (virtual "today" = Tue Jun 2 2026)
- `which` — which end ('origin' | 'dest') the station picker is editing
- `sheet` — which sheet is open ('station' | 'trip' | null)
- `tripData` — the trip object shown in Trip details
- `tab` — active tab ('schedule' | 'stationmap' | 'info' | 'settings')
- `infoStation` — station shown in the Station Info sheet (or null)
- `paywall` — Remove-Ads sheet open?
- `isPremium` — ad-free purchased?
- `appIconOpen`, `appIcon` — app-icon sheet open / current icon key
- `favOpen` — saved-routes popover open?
- `alertOpen` — delay banner visible?
- Component-local: search query, calendar month-in-view, theme selection, trip "Card" toggle.
- **Persisted:** favorited stations in `localStorage` (`patco.favStations`).

In a real build, this maps cleanly to a navigation stack + presented sheets, with route/date/favorites/premium as app state (e.g. an observable store) and schedule data coming from PATCO's real timetable/GTFS feed instead of the seeded mock.

## Data notes (mock vs. real)
The prototype uses **mock schedule data** in `shared.jsx`: a fixed virtual clock (12:59), eight seeded departures, a flat 25-min ride, and a single hard-coded delay. Fares are flat $3.00 / $6.00. The real app must replace all of this with actual PATCO schedule/real-time data and fare logic. Station list and order are real.

## Assets
- **Fonts** (`patco/fonts/`): CircularStd Book / Medium / Bold / Black `.otf`. **Commercial font — verify licensing before shipping.**
- **App icons** (`patco/icons/`): 15 PNGs — classic, black, white, blue, green, mint, peach, purple, yellow, geometric, neon, monochrome, halloween, snow, holidayLights. Used in the app-icon picker and the Settings row.
- **Icons (UI):** all other glyphs (tab bar, chevrons, stars, status, amenities, etc.) are inline SVG defined in the components — re-draw with the platform's icon system (e.g. SF Symbols) where equivalents exist.
- **Placeholders to replace with real content:** the trip-details route map and the station-info hero photo are striped placeholders.

## Files in this bundle
- `PATCO - Home Flow.html` — entry point; sets up fonts, React/Babel, and the `App()` that wires everything together.
- `patco/shared.jsx` — design tokens (`PT`), station list, mock schedule data + helpers, shared `Dot`/`Chev`/`SwapIcon`.
- `patco/flow-frame.jsx` — device frame, status bar, tab bar, bottom-sheet component.
- `patco/flow-home.jsx` — Schedule (home) screen + saved-routes popover.
- `patco/flow-date.jsx` — graphical date picker used in the date popover.
- `patco/flow-station.jsx` — station picker sheet (search + favorites + favoriting).
- `patco/flow-trip.jsx` — trip details sheet.
- `patco/flow-stationmap.jsx` — Station Map tab.
- `patco/flow-stationinfo.jsx` — station info sheet.
- `patco/flow-info.jsx` — Patco Info tab.
- `patco/flow-settings.jsx` — Settings tab.
- `patco/flow-paywall.jsx` — Remove Ads purchase sheet.
- `patco/flow-appicon.jsx` — app icon picker sheet.
- `patco/fonts/`, `patco/icons/` — bundled assets described above.
