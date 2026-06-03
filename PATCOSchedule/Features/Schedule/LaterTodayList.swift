import SwiftUI

/// "Later today" section: up to five upcoming trips after the Up Next card.
struct LaterTodayList: View {
    let trips: [Trip]
    let now: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "Later today")
                .padding(.leading, 2)

            PTCard {
                VStack(spacing: 0) {
                    ForEach(Array(trips.enumerated()), id: \.element.id) { index, trip in
                        if index > 0 { Hairline(inset: PTSpacing.screenH) }
                        LaterTodayRow(trip: trip, now: now)
                    }
                }
            }
        }
    }
}

private struct LaterTodayRow: View {
    let trip: Trip
    let now: Date

    private var seconds: Int { max(0, trip.secondsUntilDeparture(now: now)) }

    private var untilLabel: String {
        let mins = seconds / 60
        guard mins < 60 else {
            let h = mins / 60, m = mins % 60
            return m > 0 ? "\(h) hr \(m) min" : "\(h) hr"
        }
        return "\(mins) min"
    }

    private var secondaryText: String {
        switch trip.status {
        case .onTime:           return "departs in \(untilLabel)"
        case .delayed(let m):   return "+\(m) min delay · \(untilLabel)"
        }
    }

    private var secondaryColor: Color {
        trip.status == .onTime ? PTColor.ink2 : PTColor.amber
    }

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 10) {
                    Text(trip.depart.formatted(date: .omitted, time: .shortened))
                        .ptStyle(PTFont.tripTime)
                        .foregroundStyle(PTColor.ink)
                    Image(systemName: "arrow.right")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(PTColor.ink3)
                    Text(trip.arrive.formatted(date: .omitted, time: .shortened))
                        .ptStyle(PTFont.tripTime)
                        .foregroundStyle(PTColor.ink)
                }
                Text(secondaryText)
                    .font(PTFont.book(13))
                    .foregroundStyle(secondaryColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(PTColor.ink3)
        }
        .padding(.horizontal, 16)
        .frame(minHeight: 62)
        .contentShape(Rectangle())
    }
}
