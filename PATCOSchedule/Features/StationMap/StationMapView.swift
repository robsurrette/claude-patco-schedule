import SwiftUI

/// Station Map tab — placeholder scaffold rendering the 14-stop rail list so the
/// `StationRailDot` component and station data are verifiable. Tapping a row
/// (to open Station Info) is wired next phase.
struct StationMapView: View {
    var body: some View {
        ScreenScaffold(title: "Station Map") {
            PTCard(padding: 0) {
                VStack(spacing: 0) {
                    ForEach(Station.all) { station in
                        stationRow(station)
                        if station.index != Station.all.count - 1 {
                            Hairline(inset: 44)
                        }
                    }
                }
            }
        }
    }

    private func stationRow(_ station: Station) -> some View {
        HStack(spacing: 12) {
            StationRailDot(
                style: .ring,
                showTop: station.index != 0,
                showBottom: station.index != Station.all.count - 1
            )
            .frame(width: 18, height: 48)

            Text(station.name).ptStyle(PTFont.rowLabel)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(PTColor.ink3)
        }
        .padding(.horizontal, 14)
    }
}

#Preview {
    StationMapView()
}
