import SwiftUI

/// Schedule (home) tab — placeholder scaffold.
///
/// Renders the sticky header + a read-only route summary and a live count of
/// upcoming trips, proving the AppState → ScheduleProvider → ClockTicker path
/// is wired end-to-end. The full "Up Next" experience lands next phase.
struct ScheduleView: View {
    @Environment(AppState.self) private var appState
    @Environment(ClockTicker.self) private var clock
    @Environment(\.services) private var services

    private var upcoming: [Trip] {
        services.schedule.upcomingTrips(
            origin: appState.origin,
            dest: appState.destination,
            date: appState.selectedDate,
            now: clock.now
        )
    }

    var body: some View {
        ScreenScaffold(title: "Schedule") {
            Label("Saved", systemImage: "star")
                .ptStyle(PTFont.rowLabel)
                .foregroundStyle(PTColor.ink)
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(Capsule().fill(PTColor.card))
                .ptShadow(.card)
        } content: {
            routeSummary
            ComingSoonNote(screen: "Up Next countdown, day stepper, and Later-today list")
        }
    }

    private var routeSummary: some View {
        PTCard(padding: 16) {
            HStack(spacing: 14) {
                RouteEndpointIndicator()
                VStack(alignment: .leading, spacing: 10) {
                    Text(appState.origin.name).ptStyle(PTFont.rowLabel)
                    Hairline(inset: 0)
                    Text(appState.destination.name).ptStyle(PTFont.rowLabel)
                }
                Spacer()
                VStack {
                    Text("\(upcoming.count)").ptStyle(PTFont.countdown)
                        .foregroundStyle(PTColor.red)
                    Text("upcoming").ptStyle(PTFont.overline)
                        .foregroundStyle(PTColor.ink2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ScheduleView()
        .environment(AppState())
        .environment(ClockTicker(virtualNow: .now))
        .environment(\.services, .live)
}
