import SwiftUI

@main
struct PATCOScheduleApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @State private var appState = AppState()
    @State private var premium = PremiumStore()
    @State private var favorites = FavoritesStore()
    @State private var clock = ClockTicker()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(appState)
                .environment(premium)
                .environment(favorites)
                .environment(clock)
                .environment(\.services, .live)
                .preferredColorScheme(appState.theme.colorScheme)
                .task {
                    #if DEBUG
                    PTFontDebug.verifyRegistration()
                    #endif
                    clock.start()
                    premium.start()
                }
                .onChange(of: scenePhase) { _, phase in
                    // Returning to the app after midnight should keep showing
                    // "Today" rather than the day that was current at launch.
                    if phase == .active {
                        appState.refreshSelectedDateForForeground()
                    }
                }
        }
    }
}
