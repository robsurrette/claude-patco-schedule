import SwiftUI
import MapKit

struct TripDetailsSheet: View {
    let trip: Trip
    @Environment(\.services) private var services

    var body: some View {
        VStack(spacing: 0) {
            grabHandle

            TripDetailsHeader(trip: trip)
                .padding(.horizontal, PTSpacing.screenH)
                .padding(.bottom, PTSpacing.cardGap)

            TripRouteMap(trip: trip)
                .frame(height: 210)
                .clipShape(RoundedRectangle(cornerRadius: PTRadius.card, style: .continuous))
                .ptShadow(.card)
                .padding(.horizontal, PTSpacing.screenH)

            ScrollView(showsIndicators: false) {
                PTCard {
                    VStack(spacing: 0) {
                        detailRow(label: "Departs",  value: trip.depart.formatted(date: .omitted, time: .shortened))
                        Hairline(inset: 16)
                        detailRow(label: "Arrives",  value: trip.arrive.formatted(date: .omitted, time: .shortened))
                        Hairline(inset: 16)
                        detailRow(label: "Duration", value: "\(trip.rideMinutes) min")
                        Hairline(inset: 16)
                        detailRow(label: "Stops",    value: "\(trip.stopCount)")
                        Hairline(inset: 16)
                        detailRow(
                            label: "Fare",
                            value: services.fares.oneWayFare(from: trip.origin, to: trip.dest).asUSD
                        )
                    }
                }
                .padding(.horizontal, PTSpacing.screenH)
                .padding(.top, PTSpacing.cardGap)
                .padding(.bottom, 40)
            }
        }
        .background(PTColor.bg)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(PTRadius.sheet)
    }

    private var grabHandle: some View {
        Capsule()
            .fill(PTColor.fill2)
            .frame(width: 36, height: 4)
            .padding(.top, 12)
            .padding(.bottom, 20)
    }

    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(PTFont.book(14))
                .foregroundStyle(PTColor.ink2)
            Spacer()
            Text(value)
                .font(PTFont.bold(14))
                .foregroundStyle(PTColor.ink)
                .monospacedDigit()
        }
        .padding(.horizontal, 16)
        .frame(minHeight: 46)
    }
}

// MARK: - Header

private struct TripDetailsHeader: View {
    let trip: Trip

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text(trip.origin.name)
                        .ptStyle(PTFont.sheetTitle)
                        .foregroundStyle(PTColor.ink)
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(PTColor.ink3)
                    Text(trip.dest.name)
                        .ptStyle(PTFont.sheetTitle)
                        .foregroundStyle(PTColor.ink)
                }
                Text(
                    "\(trip.depart.formatted(date: .omitted, time: .shortened))  ·  \(trip.rideMinutes) min"
                )
                .font(PTFont.book(14))
                .foregroundStyle(PTColor.ink2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            TripStatusBadge(status: trip.status)
        }
    }
}

// MARK: - Status Badge

struct TripStatusBadge: View {
    let status: TripStatus

    var body: some View {
        switch status {
        case .onTime:
            pill(text: "On time", color: PTColor.green, bg: PTColor.greenSoft)
        case .delayed(let m):
            pill(text: "+\(m) min", color: PTColor.amber, bg: PTColor.amberSoft)
        }
    }

    private func pill(text: String, color: Color, bg: Color) -> some View {
        HStack(spacing: 5) {
            Circle().fill(color).frame(width: 7, height: 7)
            Text(text)
                .font(PTFont.medium(12.5))
                .foregroundStyle(color)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(bg)
        .clipShape(Capsule())
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
    let depart = Date().addingTimeInterval(7 * 60 + 33)
    let arrive = depart.addingTimeInterval(28 * 60)
    let trip   = Trip(id: "preview", origin: origin, dest: dest, depart: depart, arrive: arrive)

    return TripDetailsSheet(trip: trip)
        .environment(\.services, .live)
}
