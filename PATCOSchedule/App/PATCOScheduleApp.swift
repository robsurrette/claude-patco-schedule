import SwiftUI

@main
struct PATCOScheduleApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @State private var appState = AppState()
    @State private var premium = PremiumStore()
    @State private var favorites = FavoritesStore()
    @State private var clock = ClockTicker()
    @State private var specials = SpecialScheduleStore()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(appState)
                .environment(premium)
                .environment(favorites)
                .environment(clock)
                .environment(specials)
                .environment(\.services, .live(specials: specials))
                .preferredColorScheme(appState.theme.colorScheme)
                .task {
                    #if DEBUG
                    PTFontDebug.verifyRegistration()
                    #endif
                    clock.start()
                    premium.start()
                    specials.start()
                }
                .onChange(of: scenePhase) { _, phase in
                    // Returning to the app after midnight should keep showing
                    // "Today" rather than the day that was current at launch.
                    if phase == .active {
                        appState.refreshSelectedDateForForeground()
                        Task { await specials.refresh() }
                    }
                    if phase == .background {
                        specials.scheduleBackgroundRefresh()
                    }
                }
        }
        // Keep the cached special-schedule feed warm while the app is in the
        // background so adjusted times are available offline later.
        .backgroundTask(.appRefresh(SpecialScheduleStore.backgroundTaskID)) {
            await specials.refresh()
            specials.scheduleBackgroundRefresh()
        }
    }
}
