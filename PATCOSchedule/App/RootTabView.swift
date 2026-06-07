import SwiftUI

/// Root scaffold: the four screens hosted in a native `TabView` so the bottom
/// bar picks up the system's iOS 26 Liquid Glass styling automatically.
struct RootTabView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var appState = appState

        // Every tab always uses its outlined symbol.
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

    /// Tab bar label using a pre-rendered template image, which keeps the icon
    /// outlined (the tab bar otherwise forces the filled variant).
    private func tabLabel(_ tab: AppTab) -> some View {
        let image = UIImage(systemName: tab.symbol)?.withRenderingMode(.alwaysTemplate) ?? UIImage()
        return Label {
            Text(tab.title)
        } icon: {
            Image(uiImage: image)
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
