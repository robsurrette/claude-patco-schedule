import SwiftUI

@main
struct PATCOScheduleApp: App {
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
        }
    }
}
