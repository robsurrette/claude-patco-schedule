import SwiftUI

/// Root scaffold: the four screens stacked over the app background with the
/// floating tab bar on top. Uses a custom bar (not `TabView`) to match the
/// handoff's floating, blurred, rounded design.
struct RootTabView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var appState = appState

        ZStack(alignment: .bottom) {
            PTColor.bg.ignoresSafeArea()

            Group {
                switch appState.tab {
                case .schedule:   ScheduleView()
                case .stationMap: StationMapView()
                case .info:       InfoView()
                case .settings:   SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            FloatingTabBar(selection: $appState.tab)
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
