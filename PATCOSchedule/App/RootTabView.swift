import SwiftUI

/// Root scaffold: the four screens hosted in a native `TabView` so the bottom
/// bar picks up the system's iOS 26 Liquid Glass styling automatically.
struct RootTabView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var appState = appState

        // Each tab supplies its outlined symbol; SwiftUI automatically renders
        // the filled variant for the selected tab.
        TabView(selection: $appState.tab) {
            ScheduleView()
                .tabItem { Label(AppTab.schedule.title, systemImage: AppTab.schedule.symbol) }
                .tag(AppTab.schedule)
            StationMapView()
                .tabItem { Label(AppTab.stationMap.title, systemImage: AppTab.stationMap.symbol) }
                .tag(AppTab.stationMap)
            InfoView()
                .tabItem { Label(AppTab.info.title, systemImage: AppTab.info.symbol) }
                .tag(AppTab.info)
            SettingsView()
                .tabItem { Label(AppTab.settings.title, systemImage: AppTab.settings.symbol) }
                .tag(AppTab.settings)
        }
        // Single presenter for `activeSheet`. With a native TabView all tab
        // screens are alive at once, so per-screen `.sheet` modifiers bound to
        // the same state would fight over presentation.
        .sheet(item: $appState.activeSheet) { sheet in
            switch sheet {
            case .stationPicker(let end):
                StationPickerSheet(end: end)
            case .tripDetails(let trip):
                TripDetailsSheet(trip: trip)
            case .stationInfo(let station):
                StationInfoSheet(station: station)
            default:
                EmptyView()
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
