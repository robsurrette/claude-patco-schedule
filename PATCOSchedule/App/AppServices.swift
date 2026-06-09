import SwiftUI

/// Value-type services (data sources) injected through the environment so views
/// depend on protocols, not concrete implementations. Reference-type stores
/// (`AppState`, `PremiumStore`, `FavoritesStore`, `ClockTicker`) are injected
/// separately via `.environment(_:)`.
struct AppServices {
    var schedule: ScheduleProvider
    var fares: FareProvider
    var ads: AdProvider
    var feedback: FeedbackService

    static let live = AppServices(
        schedule: BundledScheduleSource(),
        fares: PATCOFareProvider(),
        ads: NoOpAdProvider(),
        feedback: .live
    )
}

private struct AppServicesKey: EnvironmentKey {
    static let defaultValue = AppServices.live
}

extension EnvironmentValues {
    var services: AppServices {
        get { self[AppServicesKey.self] }
        set { self[AppServicesKey.self] = newValue }
    }
}
