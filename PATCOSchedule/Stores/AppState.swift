import Foundation
import Observation
#if canImport(UIKit)
import UIKit
#endif

/// App-level UI state, mirroring the prototype's `App()` state object.
///
/// Route/date/tab/sheet selection lives here; favorites and premium are split
/// into their own persisted stores. Injected into the environment at the root.
@Observable
final class AppState {
    private static let themeKey = "patco.theme"
    private static let appIconKey = "patco.appIcon"
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
    /// The selected app icon. Persisted (by id); the actual home-screen icon is
    /// changed via `applyAppIcon(_:)`.
    var currentAppIcon: AppIconOption = .default {
        didSet { defaults.set(currentAppIcon.id, forKey: Self.appIconKey) }
    }

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
        // Restore the saved app-icon selection (the system already remembers the
        // active icon across launches; this keeps our UI selection in sync).
        if let iconID = defaults.string(forKey: Self.appIconKey) {
            currentAppIcon = .option(id: iconID)
        }
    }

    // MARK: Appearance actions

    /// Change the home-screen app icon and update the stored selection. Shows the
    /// system "you've changed your icon" alert. No-op if already selected or if
    /// the device doesn't support alternate icons.
    @MainActor
    func applyAppIcon(_ option: AppIconOption) async {
        #if canImport(UIKit)
        let app = UIApplication.shared
        guard app.supportsAlternateIcons else {
            currentAppIcon = option
            return
        }
        if app.alternateIconName != option.iconName {
            do {
                try await app.setAlternateIconName(option.iconName)
            } catch {
                // Keep the previous selection if the change failed.
                return
            }
        }
        #endif
        currentAppIcon = option
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
