import SwiftUI

/// Root scaffold: the four screens hosted in a native `TabView` so the bottom
/// bar picks up the system's iOS 26 Liquid Glass styling automatically.
struct RootTabView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var appState = appState

        TabView(selection: $appState.tab) {
            Tab(AppTab.schedule.title, systemImage: AppTab.schedule.symbol, value: AppTab.schedule) {
                ScheduleView()
            }
            Tab(AppTab.stationMap.title, systemImage: AppTab.stationMap.symbol, value: AppTab.stationMap) {
                StationMapView()
            }
            Tab(AppTab.info.title, systemImage: AppTab.info.symbol, value: AppTab.info) {
                InfoView()
            }
            Tab(AppTab.settings.title, systemImage: AppTab.settings.symbol, value: AppTab.settings) {
                SettingsView()
            }
        }
    }
}

#Preview {
    RootTabView()
        .environment(AppState())
        .environment(PremiumStore())
        .environment(FavoritesStore())
        .environment(ClockTicker(virtualNow: .now))
}
