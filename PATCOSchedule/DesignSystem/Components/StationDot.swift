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

/// The route selector's origin→destination indicator: a hollow ring (origin)
/// and a red map-pin (destination) joined by a thin connector. Each endpoint
/// occupies a row sized to match a station label row (same font + vertical
/// padding) so the dots line up with the center of each station label.
struct RouteEndpointIndicator: View {
    var body: some View {
        VStack(spacing: 0) {
            endpointRow(showTop: false, showBottom: true) {
                Circle()
                    .fill(PTColor.card)
                    .overlay(Circle().stroke(PTColor.ink3, lineWidth: 2))
                    .frame(width: 12, height: 12)
            }
            endpointRow(showTop: true, showBottom: false) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(PTColor.red)
            }
        }
        .frame(width: 14)
    }

    private func endpointRow<Content: View>(
        showTop: Bool,
        showBottom: Bool,
        @ViewBuilder dot: () -> Content
    ) -> some View {
        // A hidden label sizes the row to exactly one station-button row, so the
        // dot (centered in the overlay) aligns with that label's center.
        rowSizer
            .overlay {
                ZStack {
                    VStack(spacing: 0) {
                        connector(visible: showTop)
                        connector(visible: showBottom)
                    }
                    dot()
                }
            }
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

    private func connector(visible: Bool) -> some View {
        Rectangle()
            .fill(visible ? PTColor.hairBold : Color.clear)
            .frame(width: 2)
            .frame(maxHeight: .infinity)
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
