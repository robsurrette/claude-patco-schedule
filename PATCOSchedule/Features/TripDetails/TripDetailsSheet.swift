import SwiftUI
import MapKit

struct TripDetailsSheet: View {
    let trip: Trip
    @Environment(\.services) private var services
    @Environment(ClockTicker.self) private var clock
    @Environment(\.dismiss) private var dismiss
    private var stops: [Station] {
        let lo = min(trip.origin.index, trip.dest.index)
        let hi = max(trip.origin.index, trip.dest.index)
        let ordered = Station.all
            .filter { $0.index >= lo && $0.index <= hi }
            .sorted { $0.index < $1.index }
        return trip.origin.index <= trip.dest.index ? ordered : ordered.reversed()
    }

    private var minsUntil: Int {
        Int(ceil(Double(max(0, trip.secondsUntilDeparture(now: clock.now))) / 60.0))
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    liveStatus.padding(.bottom, 12)
                    summaryCard
                    routeMap.padding(.top, 14)
                    stopsHeader.padding(.top, 22).padding(.bottom, 12)
                    stopsList
                }
                .padding(.horizontal, 16)
                .padding(.top, 4)
                .padding(.bottom, 28)
            }
            .background(PTColor.bg)
            .navigationTitle("Trip details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    closeButton
                }
            }
        }
        .presentationDetents([.large])
        .presentationCornerRadius(PTRadius.sheet)
    }

    // MARK: - Close button

    /// iOS 26's native nav-bar close button (`role: .close`) when available;
    /// a plain circular ✕ on the iOS 17–25 deployment range.
    @ViewBuilder private var closeButton: some View {
        if #available(iOS 26.0, *) {
            Button(role: .close) { dismiss() }
        } else {
            legacyCloseButton
        }
    }

    private var legacyCloseButton: some View {
        Button { dismiss() } label: {
            Image(systemName: "xmark")
                .font(.system(size: 16, weight: .semibold))
        }
    }

    // MARK: - Live status

    private var liveStatus: some View {
        HStack(spacing: 8) {
            PulsingDot(color: trip.status == .onTime ? PTColor.green : PTColor.amber)
            if case .delayed(let m) = trip.status {
                Text("+\(m) min delay ·")
                    .font(PTFont.bold(14.5))
                    .foregroundStyle(PTColor.amber)
            }
            Text("departs in \(untilLabel(minsUntil))")
                .font(PTFont.book(14.5))
                .foregroundStyle(PTColor.ink2)
        }
    }

    // MARK: - Summary card

    private var summaryCard: some View {
        PTCard(radius: PTRadius.cardLarge, shadow: .card, padding: 18) {
            VStack(spacing: 0) {
                stationRow(label: "Depart", station: trip.origin, time: trip.depart, topAmPm: true)
                Hairline(inset: 0).padding(.vertical, 14)
                stationRow(label: "Arrive", station: trip.dest,   time: trip.arrive, topAmPm: false)
                fareChips.padding(.top, 16)
            }
        }
    }

    private func stationRow(label: String, station: Station, time: Date, topAmPm: Bool) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 3) {
                Text(label)
                    .font(PTFont.book(12.5))
                    .foregroundStyle(PTColor.ink2)
                Text(station.name)
                    .font(PTFont.bold(18))
                    .foregroundStyle(PTColor.ink)
            }
            Spacer(minLength: 16)
            VStack(alignment: .trailing, spacing: 3) {
                Text(topAmPm ? ampmLabel(for: time) : " ")
                    .font(PTFont.book(12.5))
                    .foregroundStyle(PTColor.ink2)
                Text(time.formatted(date: .omitted, time: .shortened))
                    .font(PTFont.bold(18))
                    .foregroundStyle(PTColor.ink)
                    .monospacedDigit()
            }
        }
    }

    private var fareChips: some View {
        HStack(spacing: 10) {
            fareChip(
                label: "One way",
                value: services.fares.oneWayFare(from: trip.origin, to: trip.dest).asUSD
            )
            fareChip(
                label: "Round trip",
                value: services.fares.roundTripFare(from: trip.origin, to: trip.dest).asUSD
            )
        }
    }

    private func fareChip(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label)
                .font(PTFont.book(12.5))
                .foregroundStyle(PTColor.ink2)
            Text(value)
                .font(PTFont.bold(18))
                .foregroundStyle(PTColor.ink)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(PTColor.fill)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    // MARK: - Route map

    private var routeMap: some View {
        TripRouteMap(trip: trip)
            .frame(height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    // MARK: - Stops section

    private var stopsHeader: some View {
        let n = max(stops.count - 1, 0)
        return HStack(spacing: 6) {
            Text("Ride for \(n) \(n == 1 ? "stop" : "stops")")
                .font(PTFont.bold(16))
                .foregroundStyle(PTColor.ink)
            Text("· \(trip.rideMinutes) min")
                .font(PTFont.book(14))
                .foregroundStyle(PTColor.ink2)
        }
    }

    private var stopsList: some View {
        VStack(spacing: 0) {
            ForEach(Array(stops.enumerated()), id: \.offset) { index, station in
                StopRow(
                    station: station,
                    time: stopTime(at: index),
                    isFirst: index == 0,
                    isLast: index == stops.count - 1
                )
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(PTColor.card)
        )
        .shadow(color: .black.opacity(0.04), radius: 1, x: 0, y: 1)
    }

    // MARK: - Helpers

    private func stopTime(at index: Int) -> Date {
        guard stops.count > 1 else { return trip.depart }
        let fraction = Double(index) / Double(stops.count - 1)
        return trip.depart.addingTimeInterval(trip.arrive.timeIntervalSince(trip.depart) * fraction)
    }

    private func ampmLabel(for date: Date) -> String {
        Calendar.current.component(.hour, from: date) < 12 ? "AM" : ""
    }

    private func untilLabel(_ mins: Int) -> String {
        guard mins > 0 else { return "Departing" }
        guard mins < 60 else {
            let h = mins / 60, m = mins % 60
            return m > 0 ? "\(h) hr \(m) min" : "\(h) hr"
        }
        return "\(mins) min"
    }
}

// MARK: - Stop Row

private struct StopRow: View {
    let station: Station
    let time: Date
    let isFirst: Bool
    let isLast: Bool

    var body: some View {
        HStack(spacing: 14) {
            StationRailDot(
                style: (isFirst || isLast) ? .target : .ring,
                showTop: !isFirst,
                showBottom: !isLast
            )
            .overlay {
                if isFirst || isLast {
                    Circle()
                        .fill(PTColor.card)
                        .frame(width: 5, height: 5)
                }
            }

            Text(station.name)
                .font((isFirst || isLast) ? PTFont.bold(16.5) : PTFont.book(16.5))
                .foregroundStyle((isFirst || isLast) ? PTColor.ink : PTColor.ink2)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(time.formatted(date: .omitted, time: .shortened))
                .font((isFirst || isLast) ? PTFont.bold(14.5) : PTFont.book(14.5))
                .foregroundStyle((isFirst || isLast) ? PTColor.ink : PTColor.ink2)
                .monospacedDigit()
        }
        .frame(minHeight: 46)
        .overlay(alignment: .bottom) {
            if !isLast { Hairline(inset: 30) }
        }
    }
}

// MARK: - Route Map

private struct TripRouteMap: View {
    let trip: Trip

    private var segment: [CLLocationCoordinate2D] {
        PATCORoute.segment(from: trip.origin, to: trip.dest)
    }

    private var cameraRegion: MKCoordinateRegion {
        let coords = segment.isEmpty ? PATCORoute.coordinates : segment
        let lats = coords.map(\.latitude)
        let lons = coords.map(\.longitude)
        let center = CLLocationCoordinate2D(
            latitude:  (lats.min()! + lats.max()!) / 2,
            longitude: (lons.min()! + lons.max()!) / 2
        )
        let latDelta = max(0.01, (lats.max()! - lats.min()!) * 1.7)
        let lonDelta = max(0.01, (lons.max()! - lons.min()!) * 1.7)
        return MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        )
    }

    private var originCoord: CLLocationCoordinate2D {
        PATCORoute.coordinates[PATCORoute.stationCoordIndex[trip.origin.id] ?? 0]
    }

    private var destCoord: CLLocationCoordinate2D {
        PATCORoute.coordinates[PATCORoute.stationCoordIndex[trip.dest.id] ?? 0]
    }

    var body: some View {
        Map(initialPosition: .region(cameraRegion)) {
            MapPolyline(coordinates: PATCORoute.coordinates)
                .stroke(PTColor.ink3.opacity(0.3), lineWidth: 3)
            MapPolyline(coordinates: segment)
                .stroke(PTColor.red, lineWidth: 4)
            Marker(trip.origin.name, coordinate: originCoord)
                .tint(PTColor.green)
            Marker(trip.dest.name, coordinate: destCoord)
                .tint(PTColor.red)
        }
        .mapStyle(.standard(elevation: .flat))
        .mapControls { }
    }
}

// MARK: - Preview

#Preview {
    let origin = Station.station(id: "woodcrest")!
    let dest   = Station.station(id: "15-16th-locust")!
    let depart = Date().addingTimeInterval(4 * 60)
    let arrive = depart.addingTimeInterval(25 * 60)
    let trip   = Trip(id: "preview", origin: origin, dest: dest, depart: depart, arrive: arrive)

    return TripDetailsSheet(trip: trip)
        .environment(ClockTicker(virtualNow: .now))
        .environment(\.services, .live)
}
