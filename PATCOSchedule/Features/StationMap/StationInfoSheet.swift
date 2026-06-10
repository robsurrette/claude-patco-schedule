import SwiftUI
import UIKit
import CoreLocation

/// Station Info — the detail sheet shown when a station is tapped on the Station
/// Map. A hero photo sits above the title, a Directions card (Apple Maps,
/// Google Maps, station website), and a wrapping set of amenity chips.
///
/// Hero photos are loaded by asset name (`station-<id>`); until they're added to
/// the catalog the view falls back to a striped placeholder, matching the
/// handoff.
struct StationInfoSheet: View {
    let station: Station

    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(spacing: 0) {
            hero
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(station.name)
                        .ptStyle(PTFont.largeTitle)
                        .foregroundStyle(PTColor.ink)
                        .padding(.bottom, 18)

                    SectionHeader(title: "Directions")
                        .padding(.horizontal, 4)
                        .padding(.bottom, 8)
                    directionsCard
                        .padding(.bottom, 22)

                    SectionHeader(title: "Amenities")
                        .padding(.horizontal, 4)
                        .padding(.bottom, 8)
                    FlowLayout(spacing: 10) {
                        ForEach(station.amenities) { AmenityChip(amenity: $0) }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 18)
                .padding(.bottom, 28)
            }
        }
        .background(PTColor.bg)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(PTRadius.sheet)
        .presentationBackground(PTColor.bg)
    }

    // MARK: - Hero

    private var hero: some View {
        ZStack(alignment: .topTrailing) {
            // `Color.clear` is the size-defining base (container width × 200).
            // The photo is a clipped overlay: an overlay is laid out at the
            // base's size and never expands it, so the hero can't be widened by
            // a `scaledToFill` image whose aspect ratio is wider than the frame.
            Color.clear
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .overlay { heroImage }
                .clipped()

            closeButton
                .padding(14)
        }
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: PTRadius.sheet,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: PTRadius.sheet,
                style: .continuous
            )
        )
    }

    @ViewBuilder private var heroImage: some View {
        if let image = UIImage(named: station.heroImageName) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            heroPlaceholder
        }
    }

    private var heroPlaceholder: some View {
        ZStack {
            DiagonalStripes()
            Text("\(station.name.lowercased()) · station photo")
                .font(.system(size: 12, weight: .regular, design: .monospaced))
                .foregroundStyle(PTColor.ink3)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
    }

    private var closeButton: some View {
        Group {
            #if compiler(>=6.2)
            if #available(iOS 26.0, *) {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(PTColor.ink2)
                        .frame(width: 28, height: 28)
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.circle)
            } else {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(PTColor.ink2)
                        .frame(width: 28, height: 28)
                }
                .buttonBorderShape(.circle)
            }
            #else
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(PTColor.ink2)
                    .frame(width: 28, height: 28)
            }
            .buttonBorderShape(.circle)
            #endif
        }
    }

    // MARK: - Directions

    private var directionsCard: some View {
        PTCard(radius: 16, padding: 0) {
            VStack(spacing: 0) {
                directionRow(
                    systemImage: "location.fill",
                    iconColor: PTColor.ink,
                    label: "Open in Apple Maps",
                    showHairline: true,
                    action: openInAppleMaps
                )
                directionRow(
                    systemImage: "mappin.circle.fill",
                    iconColor: PTColor.red,
                    label: "Open in Google Maps",
                    showHairline: true,
                    action: openInGoogleMaps
                )
                directionRow(
                    systemImage: "globe",
                    iconColor: PTColor.ink,
                    label: "Station website",
                    trailingSymbol: "arrow.up.right",
                    showHairline: false,
                    action: openWebsite
                )
            }
        }
    }

    private func directionRow(
        systemImage: String,
        iconColor: Color,
        label: String,
        trailingSymbol: String = "chevron.right",
        showHairline: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 13) {
                Image(systemName: systemImage)
                    .font(.system(size: 15))
                    .foregroundStyle(iconColor)
                    .frame(width: 30, height: 30)
                    .background(PTColor.fill, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                Text(label)
                    .ptStyle(PTFont.rowLabel)
                    .foregroundStyle(PTColor.ink)
                Spacer(minLength: 8)
                Image(systemName: trailingSymbol)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(PTColor.ink3)
            }
            .padding(.horizontal, 16)
            .frame(minHeight: 54)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .overlay(alignment: .bottom) {
            if showHairline { Hairline(inset: 59) }
        }
    }

    // MARK: - Actions

    private func openInAppleMaps() {
        guard let coordinate = station.coordinate else { return }
        let name = station.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "http://maps.apple.com/?q=\(name)&ll=\(coordinate.latitude),\(coordinate.longitude)") {
            openURL(url)
        }
    }

    private func openInGoogleMaps() {
        guard let coordinate = station.coordinate else { return }
        if let url = URL(string: "https://www.google.com/maps/search/?api=1&query=\(coordinate.latitude),\(coordinate.longitude)") {
            openURL(url)
        }
    }

    private func openWebsite() {
        openURL(station.websiteURL)
    }
}

// MARK: - Station info helpers

private extension Station {
    /// Asset-catalog name for the hero photo. Photos are added later; until then
    /// the sheet shows a striped placeholder.
    var heroImageName: String { "station-\(id)" }

    /// Official PATCO station information page. Each station deep-links to its
    /// own page; the slug differs from `id` for a few stations (e.g. Ferry
    /// Avenue → `ferryave`, the Center-City stops → `8th`/`9th`/`12th`/`15th`).
    var websiteURL: URL {
        let base = "http://www.ridepatco.org/stations/"
        return URL(string: base + Station.websiteSlug(forID: id) + ".asp")!
    }

    /// Maps a station `id` to the slug used in its ridepatco.org page URL.
    static func websiteSlug(forID id: String) -> String {
        switch id {
        case "ferry-avenue":    return "ferryave"
        case "city-hall":       return "cityhall"
        case "franklin-square": return "franklinsquare"
        case "8th-market":      return "8th"
        case "9-10th-locust":   return "9th"
        case "12-13th-locust":  return "12th"
        case "15-16th-locust":  return "15th"
        default:                return id
        }
    }
}

// MARK: - Amenity chip

private struct AmenityChip: View {
    let amenity: StationAmenity

    var body: some View {
        HStack(spacing: 8) {
            AmenityGlyph(amenity: amenity)
            Text(amenity.label)
                .font(PTFont.medium(15))
                .foregroundStyle(PTColor.ink)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 11)
        .background(PTColor.card, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .ptShadow(.card)
    }
}

/// The amenity glyphs, recreated from the handoff's inline SVG paths (SF Symbols
/// lacks dedicated elevator/escalator icons). Drawn in a 24×24 unit space and
/// scaled to fit.
private struct AmenityGlyph: View {
    let amenity: StationAmenity
    var color: Color = PTColor.ink

    var body: some View {
        Canvas { context, size in
            let unit = min(size.width, size.height) / 24
            func point(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * unit, y: y * unit) }
            let shading = GraphicsContext.Shading.color(color)
            let stroke = StrokeStyle(lineWidth: 1.8 * unit, lineCap: .round, lineJoin: .round)

            switch amenity {
            case .parking:
                context.stroke(
                    Path(roundedRect: CGRect(x: 3 * unit, y: 3 * unit, width: 18 * unit, height: 18 * unit),
                         cornerRadius: 5 * unit),
                    with: shading, style: stroke
                )
                // The letter "P": stem + a right-bulging bowl (two quarter arcs).
                let top = point(12.2, 8)
                let right = point(14.8, 10.6)
                let bottom = point(12.2, 13.2)
                let k = 0.5523 * 2.6 * unit
                var letter = Path()
                letter.move(to: point(9, 17))
                letter.addLine(to: point(9, 8))
                letter.addLine(to: top)
                letter.addCurve(to: right,
                                control1: CGPoint(x: top.x + k, y: top.y),
                                control2: CGPoint(x: right.x, y: right.y - k))
                letter.addCurve(to: bottom,
                                control1: CGPoint(x: right.x, y: right.y + k),
                                control2: CGPoint(x: bottom.x + k, y: bottom.y))
                letter.addLine(to: point(9, 13.2))
                context.stroke(letter, with: shading, style: stroke)

            case .bikeRacks:
                let radius = 3.6 * unit
                for centerX in [5.5, 18.5] as [CGFloat] {
                    context.stroke(
                        Path(ellipseIn: CGRect(x: centerX * unit - radius, y: 16.5 * unit - radius,
                                               width: radius * 2, height: radius * 2)),
                        with: shading, style: stroke
                    )
                }
                var frame = Path()
                frame.move(to: point(5.5, 16.5)); frame.addLine(to: point(9.7, 9)); frame.addLine(to: point(15.2, 9))
                frame.move(to: point(12, 9)); frame.addLine(to: point(15.5, 16.5))
                frame.move(to: point(9, 9)); frame.addLine(to: point(13.5, 9))
                context.stroke(frame, with: shading, style: stroke)
                let seat = 1.1 * unit
                context.fill(
                    Path(ellipseIn: CGRect(x: 14.5 * unit - seat, y: 5.5 * unit - seat, width: seat * 2, height: seat * 2)),
                    with: shading
                )

            case .elevator:
                context.stroke(
                    Path(roundedRect: CGRect(x: 5 * unit, y: 3 * unit, width: 14 * unit, height: 18 * unit),
                         cornerRadius: 2.5 * unit),
                    with: shading, style: stroke
                )
                var up = Path()
                up.move(to: point(12, 6.5)); up.addLine(to: point(9.8, 9.5)); up.addLine(to: point(14.2, 9.5)); up.closeSubpath()
                var down = Path()
                down.move(to: point(12, 17.5)); down.addLine(to: point(9.8, 14.5)); down.addLine(to: point(14.2, 14.5)); down.closeSubpath()
                context.fill(up, with: shading)
                context.fill(down, with: shading)

            case .escalator:
                var rail = Path()
                rail.move(to: point(4, 18)); rail.addLine(to: point(7.5, 18))
                rail.addLine(to: point(16.5, 6)); rail.addLine(to: point(20, 6))
                var corner = Path()
                corner.move(to: point(16.5, 6)); corner.addLine(to: point(20, 6)); corner.addLine(to: point(20, 9.5))
                context.stroke(rail, with: shading, style: stroke)
                context.stroke(corner, with: shading, style: stroke)
            }
        }
        .frame(width: 18, height: 18)
    }
}

// MARK: - Diagonal stripe placeholder

/// The hero-photo placeholder fill — diagonal stripes alternating between the
/// two inset-fill tokens (adapts to light/dark).
private struct DiagonalStripes: View {
    var body: some View {
        Canvas { context, size in
            context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(PTColor.fill))
            let band: CGFloat = 11
            let height = size.height
            var x = -height
            while x < size.width {
                var stripe = Path()
                stripe.move(to: CGPoint(x: x, y: 0))
                stripe.addLine(to: CGPoint(x: x + band, y: 0))
                stripe.addLine(to: CGPoint(x: x + band + height, y: height))
                stripe.addLine(to: CGPoint(x: x + height, y: height))
                stripe.closeSubpath()
                context.fill(stripe, with: .color(PTColor.fill2))
                x += band * 2
            }
        }
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            StationInfoSheet(station: Station.station(id: "haddonfield")!)
        }
}
