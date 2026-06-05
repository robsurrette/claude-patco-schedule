import Foundation
import Observation

/// App-level UI state, mirroring the prototype's `App()` state object.
///
/// Route/date/tab/sheet selection lives here; favorites and premium are split
/// into their own persisted stores. Injected into the environment at the root.
@Observable
final class AppState {
    private static let themeKey = "patco.theme"
    @ObservationIgnored private let defaults: UserDefaults

    // Route
    var origin: Station
    var destination: Station

    // Date being viewed
    var selectedDate: Date

    // Navigation / presentation
    var tab: AppTab = .schedule
    var activeSheet: AppSheet?
    var savedRoutesOpen = false
    var datePopoverOpen = false

    // Schedule-screen affordances
    var alertVisible = true

    // Appearance — persisted across launches.
    var theme: AppTheme = .automatic {
        didSet { defaults.set(theme.rawValue, forKey: Self.themeKey) }
    }
    var currentAppIcon: AppIconOption = .default

    // Saved routes (in-memory for the skeleton; persistence comes later)
    var savedRoutes: [SavedRoute] = SavedRoute.samples

    init(
        origin: Station = Station.station(id: "woodcrest") ?? Station.all[2],
        destination: Station = Station.station(id: "15-16th-locust") ?? Station.all[13],
        selectedDate: Date = .now,
        defaults: UserDefaults = .standard
    ) {
        self.defaults = defaults
        self.origin = origin
        self.destination = destination
        self.selectedDate = selectedDate

        // Restore the saved appearance preference (defaults to .automatic).
        if let raw = defaults.string(forKey: Self.themeKey),
           let stored = AppTheme(rawValue: raw) {
            theme = stored
        }
    }

    // MARK: Route actions

    /// Reverse origin and destination in place (swap button).
    func swapRoute() {
        let previousOrigin = origin
        origin = destination
        destination = previousOrigin
    }

    /// Select a station for one end of the route.
    ///
    /// Selection rule (from the prototype's `onSelectStation`): if the chosen
    /// station equals the *other* end, swap the two ends rather than creating
    /// an invalid same-station route.
    func select(_ station: Station, for end: RouteEnd) {
        switch end {
        case .origin:
            if station == destination { swapRoute() } else { origin = station }
        case .destination:
            if station == origin { swapRoute() } else { destination = station }
        }
    }

    /// Apply a saved route's origin/destination.
    func apply(_ route: SavedRoute) {
        if let o = route.origin { origin = o }
        if let d = route.dest { destination = d }
        savedRoutesOpen = false
    }

    // MARK: Date actions

    func stepDate(by days: Int, calendar: Calendar = .current) {
        if let next = calendar.date(byAdding: .day, value: days, to: selectedDate) {
            selectedDate = next
        }
    }
}
