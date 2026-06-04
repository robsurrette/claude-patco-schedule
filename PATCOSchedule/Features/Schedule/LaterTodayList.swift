import SwiftUI

/// Upcoming or scheduled trips list, used for "Later today" (today) and
/// "Departures" (other dates). Pass `showCountdown: false` for non-today dates
/// to suppress the time-until-departure sub-label.
struct LaterTodayList: View {
    let trips: [Trip]
    let now: Date
    var title: String = "Later today"
    var showCountdown: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: title)
                .padding(.leading, 2)

            PTCard {
                VStack(spacing: 0) {
                    ForEach(Array(trips.enumerated()), id: \.element.id) { index, trip in
                        if index > 0 { Hairline(inset: PTSpacing.screenH) }
                        LaterTodayRow(trip: trip, now: now, showCountdown: showCountdown)
                    }
                }
            }
        }
    }
}

private struct LaterTodayRow: View {
    let trip: Trip
    let now: Date
    var showCountdown: Bool = true

    private var seconds: Int { max(0, trip.secondsUntilDeparture(now: now)) }

    private var untilLabel: String {
        let mins = seconds / 60
        guard mins < 60 else {
            let h = mins / 60, m = mins % 60
            return m > 0 ? "\(h) hr \(m) min" : "\(h) hr"
        }
        return "\(mins) min"
    }

    private var countdownText: String {
        switch trip.status {
        case .onTime:           return "departs in \(untilLabel)"
        case .delayed(let m):   return "+\(m) min delay · \(untilLabel)"
        }
    }

    private var countdownColor: Color {
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
                if showCountdown {
                    Text(countdownText)
                        .font(PTFont.book(13))
                        .foregroundStyle(countdownColor)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(PTColor.ink3)
        }
        .padding(.horizontal, 16)
        .frame(minHeight: showCountdown ? 62 : 50)
        .contentShape(Rectangle())
    }
}
