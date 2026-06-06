import SwiftUI

/// The hero card at the top of the Schedule screen showing the next departure
/// with a live minute countdown and m:ss ticker.
struct UpNextCard: View {
    let trip: Trip
    let now: Date
    var onTap: (() -> Void)? = nil

    private var seconds: Int { max(0, trip.secondsUntilDeparture(now: now)) }
    private var minutesUntil: Int { Int(ceil(Double(seconds) / 60.0)) }
    private var mmss: String { String(format: "%d:%02d", seconds / 60, seconds % 60) }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                PulsingDot()
                Text("UP NEXT")
                    .ptStyle(PTFont.overline)
                    .foregroundStyle(PTColor.ink2)
            }

            HStack(alignment: .center, spacing: 0) {
                // Live countdown
                HStack(alignment: .bottom, spacing: 7) {
                    Text("\(minutesUntil)")
                        .ptStyle(PTFont.countdown)
                        .foregroundStyle(PTColor.ink)
                        .monospacedDigit()
                    VStack(alignment: .leading, spacing: 2) {
                        Text("min")
                            .font(PTFont.bold(16))
                            .foregroundStyle(PTColor.ink)
                        Text(mmss)
                            .font(PTFont.book(12.5))
                            .foregroundStyle(PTColor.ink2)
                            .monospacedDigit()
                    }
                    .padding(.bottom, 5)
                }

                Spacer(minLength: 12)

                // Depart / arrive
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(PTColor.hairBold)
                        .frame(width: 0.5, height: 48)
                    VStack(alignment: .leading, spacing: 5) {
                        timeRow(label: "Depart", date: trip.depart)
                        timeRow(label: "Arrive",  date: trip.arrive)
                    }
                    .padding(.leading, 14)
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(PTColor.ink3)
                    .padding(.leading, 8)
            }
        }
        .padding(16)
        .background(PTColor.card)
        .clipShape(RoundedRectangle(cornerRadius: PTRadius.cardLarge, style: .continuous))
        .ptShadow(.elevated)
        .contentShape(RoundedRectangle(cornerRadius: PTRadius.cardLarge, style: .continuous))
        .onTapGesture { onTap?() }
    }

    private func timeRow(label: String, date: Date) -> some View {
        HStack(spacing: 12) {
            Text(label)
                .font(PTFont.book(12.5))
                .foregroundStyle(PTColor.ink2)
                .lineLimit(1)
                .frame(width: 52, alignment: .leading)
            Text(date.formatted(date: .omitted, time: .shortened))
                .font(PTFont.bold(16))
                .foregroundStyle(PTColor.ink)
                .monospacedDigit()
        }
    }
}

#Preview {
    let origin = Station.station(id: "woodcrest")!
    let dest   = Station.station(id: "15-16th-locust")!
    let depart = Date().addingTimeInterval(7 * 60 + 33)
    let arrive = Date().addingTimeInterval(29 * 60)
    let trip   = Trip(id: "preview", origin: origin, dest: dest, depart: depart, arrive: arrive)

    return UpNextCard(trip: trip, now: .now)
        .padding()
        .background(PTColor.bg)
}
