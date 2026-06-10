import SwiftUI

struct ScheduleView: View {
    @Environment(AppState.self) private var appState
    @Environment(ClockTicker.self) private var clock
    @Environment(SpecialScheduleStore.self) private var specials
    @Environment(\.services) private var services

    private var isToday: Bool {
        Calendar.current.isDateInToday(appState.selectedDate)
    }

    private var activeSpecial: SpecialSchedule? {
        specials.special(on: appState.selectedDate)
    }

    private var displayTrips: [Trip] {
        if isToday {
            return services.schedule.upcomingTrips(
                origin: appState.origin,
                dest: appState.destination,
                date: appState.selectedDate,
                now: clock.now
            )
        } else {
            return services.schedule.trips(
                origin: appState.origin,
                dest: appState.destination,
                date: appState.selectedDate,
                calendar: .current
            )
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: PTSpacing.cardGap) {
                if let special = activeSpecial {
                    SpecialScheduleBanner(special: special)
                }
                if isToday {
                    if let next = displayTrips.first {
                        UpNextCard(trip: next, now: clock.now) {
                            appState.activeSheet = .tripDetails(next)
                        }
                    } else {
                        NoTripsCard()
                    }
                    if displayTrips.count > 1 {
                        LaterTodayList(
                            trips: Array(displayTrips.dropFirst().prefix(5)),
                            now: clock.now
                        )
                    }
                } else {
                    if displayTrips.isEmpty {
                        NoTripsCard()
                    } else {
                        LaterTodayList(
                            trips: displayTrips,
                            now: clock.now,
                            title: "Departures",
                            showCountdown: false
                        )
                    }
                }
            }
            .padding(.horizontal, PTSpacing.screenH)
            .padding(.top, PTSpacing.cardGap)
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            ScheduleHeader()
        }
        .background(PTColor.bg)
        .ignoresSafeArea(edges: .top)
    }
}

// MARK: - Header

private struct ScheduleHeader: View {
    var body: some View {
        VStack(spacing: 10) {
            ScheduleTitleRow()
            RouteSelectorCard()
            DayStepper()
        }
        .padding(.horizontal, PTSpacing.screenH)
        .padding(.top, PTSpacing.headerTop)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity)
        .background(
            PTColor.bg.opacity(0.86)
                .background(.ultraThinMaterial)
        )
        .overlay(alignment: .bottom) {
            Hairline(inset: 0)
        }
    }
}

private struct ScheduleTitleRow: View {
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Schedule")
                .ptStyle(PTFont.screenTitle)
                .foregroundStyle(PTColor.ink)
            Spacer(minLength: 8)
            // Saved button — temporarily hidden, out of scope for now.
            // HStack(spacing: 6) {
            //     Image(systemName: "star.fill")
            //         .font(.system(size: 12, weight: .semibold))
            //         .foregroundStyle(PTColor.red)
            //     Text("Saved")
            //         .ptStyle(PTFont.rowLabel)
            //         .foregroundStyle(PTColor.ink)
            // }
            // .padding(.horizontal, 13)
            // .padding(.vertical, 8)
            // .background(Capsule().fill(PTColor.card))
            // .ptShadow(.card)
        }
    }
}

// MARK: - Special Schedule Banner

/// Amber banner shown on dates covered by a posted special schedule. When the
/// feed carries parsed times, the listed trips below already reflect them;
/// when it's alert-only, the banner directs riders to RidePATCO.org.
private struct SpecialScheduleBanner: View {
    let special: SpecialSchedule

    private var detail: String {
        if let message = special.message, !message.isEmpty { return message }
        return special.alertOnly
            ? "Times may differ from the regular schedule. Check RidePATCO.org for details."
            : "Adjusted times are shown below."
    }

    var body: some View {
        HStack(alignment: .top, spacing: 11) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(PTColor.amber)
                .padding(.top, 1)
            VStack(alignment: .leading, spacing: 2) {
                Text(special.title)
                    .font(PTFont.bold(14))
                    .foregroundStyle(PTColor.alertTitle)
                Text(detail)
                    .font(PTFont.book(13))
                    .foregroundStyle(PTColor.alertBody)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(PTColor.amberSoft)
        .clipShape(RoundedRectangle(cornerRadius: PTRadius.card, style: .continuous))
    }
}

// MARK: - No Trips

private struct NoTripsCard: View {
    var body: some View {
        PTCard(padding: 24) {
            VStack(spacing: 10) {
                Image(systemName: "moon.stars")
                    .font(.system(size: 28))
                    .foregroundStyle(PTColor.ink3)
                Text("No more trains today")
                    .font(PTFont.bold(16))
                    .foregroundStyle(PTColor.ink)
                Text("Service has ended for this route.\nTry another day or swap direction.")
                    .font(PTFont.book(14))
                    .foregroundStyle(PTColor.ink2)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ScheduleView()
        .environment(AppState())
        .environment(ClockTicker(virtualNow: .now))
        .environment(SpecialScheduleStore())
        .environment(\.services, .live)
}
