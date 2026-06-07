import SwiftUI

/// Root scaffold: the four screens hosted in a native `TabView` so the bottom
/// bar picks up the system's iOS 26 Liquid Glass styling automatically.
struct RootTabView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var appState = appState

        TabView(selection: $appState.tab) {
            ScheduleView()
                .tabItem { tabLabel(.schedule) }
                .tag(AppTab.schedule)
            StationMapView()
                .tabItem { tabLabel(.stationMap) }
                .tag(AppTab.stationMap)
            InfoView()
                .tabItem { tabLabel(.info) }
                .tag(AppTab.info)
            SettingsView()
                .tabItem { tabLabel(.settings) }
                .tag(AppTab.settings)
        }
    }

    /// Outlined icon when inactive, filled when this tab is selected.
    private func tabLabel(_ tab: AppTab) -> some View {
        let symbol = appState.tab == tab ? tab.symbolFilled : tab.symbol
        return Label(tab.title, systemImage: symbol)
    }
}

#Preview {
    RootTabView()
        .environment(AppState())
        .environment(PremiumStore())
        .environment(FavoritesStore())
        .environment(ClockTicker(virtualNow: .now))
}
