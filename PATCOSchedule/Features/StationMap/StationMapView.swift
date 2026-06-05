import SwiftUI

/// Station Map tab — the 14-stop Speedline rendered as a tappable route list.
/// Tapping a station opens its Station Info sheet.
struct StationMapView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var appState = appState
        ScreenScaffold(title: "Station Map") {
            PTCard(radius: 18, padding: 0) {
                VStack(spacing: 0) {
                    ForEach(Station.all) { station in
                        StationMapRow(station: station) {
                            appState.activeSheet = .stationInfo(station)
                        }
                    }
                }
            }
        }
        .sheet(item: $appState.activeSheet) { sheet in
            switch sheet {
            case .stationInfo(let station):
                StationInfoSheet(station: station)
            default:
                EmptyView()
            }
        }
    }
}

// MARK: - Row

private struct StationMapRow: View {
    let station: Station
    let onTap: () -> Void

    private var isFirst: Bool { station.index == 0 }
    private var isLast: Bool { station.index == Station.all.count - 1 }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 0) {
                StationRailDot(style: .ring, showTop: !isFirst, showBottom: !isLast)
                    .frame(width: 54)
                Text(station.name)
                    .ptStyle(PTFont.rowLabel)
                    .foregroundStyle(PTColor.ink)
                Spacer(minLength: 8)
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(PTColor.ink3)
                    .padding(.trailing, 16)
            }
            .frame(minHeight: 58)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .overlay(alignment: .bottom) {
            if !isLast { Hairline(inset: 54) }
        }
    }
}

#Preview {
    StationMapView()
        .environment(AppState())
}
