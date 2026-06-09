import SwiftUI

/// The rail rendering used on the Station Map and trip stop lists: a 3px red
/// vertical line connecting station dots. A single row draws its dot plus the
/// connector segments above/below (suppressed at the ends of the line).
struct StationRailDot: View {
    enum Style {
        /// Hollow white fill with a red ring (intermediate / list stop).
        case ring
        /// Solid red target dot (route endpoints).
        case target
    }

    var style: Style = .ring
    var showTop = true
    var showBottom = true

    private let lineWidth: CGFloat = 3
    private let dotSize: CGFloat = 14

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                segment(visible: showTop)
                segment(visible: showBottom)
            }
            dot
        }
        .frame(width: dotSize)
    }

    private func segment(visible: Bool) -> some View {
        Rectangle()
            .fill(visible ? PTColor.red : Color.clear)
            .frame(width: lineWidth)
            .frame(maxHeight: .infinity)
    }

    @ViewBuilder private var dot: some View {
        switch style {
        case .ring:
            Circle()
                .fill(PTColor.card)
                .overlay(Circle().stroke(PTColor.red, lineWidth: 3))
                .frame(width: dotSize, height: dotSize)
        case .target:
            Circle()
                .fill(PTColor.red)
                .frame(width: dotSize, height: dotSize)
        }
    }
}

/// A teardrop location pin, drawn as a vector so it scales crisply and takes a
/// tint — no bitmap asset required. Matches the destination pin in the design
/// handoff (a red drop with a punched-out white dot).
struct MapPinShape: Shape {
    func path(in rect: CGRect) -> Path {
        // Built in the handoff's 24×24 design space, then mapped into `rect`.
        func pt(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
            CGPoint(x: rect.minX + x / 24 * rect.width,
                    y: rect.minY + y / 24 * rect.height)
        }
        var p = Path()
        p.move(to: pt(12, 22))                                                   // bottom tip
        p.addCurve(to: pt(19, 9), control1: pt(14.5, 18), control2: pt(19, 13))  // tip → right
        p.addCurve(to: pt(12, 2), control1: pt(19, 5.13), control2: pt(15.87, 2)) // right → top
        p.addCurve(to: pt(5, 9),  control1: pt(8.13, 2),  control2: pt(5, 5.13))  // top → left
        p.addCurve(to: pt(12, 22), control1: pt(5, 13),   control2: pt(9.5, 18))  // left → tip
        p.closeSubpath()
        return p
    }
}

/// The destination map-pin used in the route selector.
struct MapPinIcon: View {
    var width: CGFloat = 14
    var height: CGFloat = 14
    var color: Color = PTColor.red
    var holeColor: Color = PTColor.card

    var body: some View {
        MapPinShape()
            .fill(color)
            .overlay(
                GeometryReader { geo in
                    Circle()
                        .fill(holeColor)
                        .frame(width: geo.size.width * 5.2 / 24,
                               height: geo.size.width * 5.2 / 24)
                        .position(x: geo.size.width * 0.5,
                                  y: geo.size.height * 9 / 24)
                }
            )
            .frame(width: width, height: height)
    }
}

/// The route selector's origin→destination indicator: a small thick hollow ring
/// (origin) and a red map-pin (destination), with a short detached connector
/// between them. Each endpoint occupies a row sized to match a station label row
/// (same font + vertical padding) so the icons line up with the center of each
/// station label.
struct RouteEndpointIndicator: View {
    var body: some View {
        VStack(spacing: 0) {
            endpointRow {
                Circle()
                    .strokeBorder(PTColor.ink3, lineWidth: 2.5)
                    .frame(width: 10, height: 10)
            }
            endpointRow {
                MapPinIcon()
            }
        }
        // A short connector centered between the two rows — close to neither
        // icon, so the line reads as detached rather than joining the dots.
        .overlay(
            Capsule()
                .fill(PTColor.hairBold)
                .frame(width: 2, height: 24)
        )
        .frame(width: 14)
    }

    private func endpointRow<Content: View>(
        @ViewBuilder dot: () -> Content
    ) -> some View {
        // A hidden label sizes the row to exactly one station-button row, so the
        // dot (centered in the overlay) aligns with that label's center.
        rowSizer.overlay { dot() }
    }

    /// Mirrors `RouteSelectorCard`'s station button: `PTFont.rowLabel` text with
    /// 13pt vertical padding. Kept invisible — used only to establish row height.
    private var rowSizer: some View {
        Text(" ")
            .ptStyle(PTFont.rowLabel)
            .padding(.vertical, 13)
            .opacity(0)
            .accessibilityHidden(true)
    }
}

#Preview {
    HStack(alignment: .top, spacing: 40) {
        VStack(spacing: 0) {
            StationRailDot(style: .target, showTop: false).frame(height: 30)
            StationRailDot(style: .ring).frame(height: 30)
            StationRailDot(style: .target, showBottom: false).frame(height: 30)
        }
        RouteEndpointIndicator()
    }
    .padding(40)
    .background(PTColor.bg)
}
