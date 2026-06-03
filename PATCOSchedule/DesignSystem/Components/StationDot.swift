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

/// The route selector's origin→destination indicator: hollow ring (origin), a
/// 2px connector, and a red map-pin (destination).
struct RouteEndpointIndicator: View {
    var body: some View {
        VStack(spacing: 0) {
            Circle()
                .stroke(PTColor.ink3, lineWidth: 2)
                .frame(width: 12, height: 12)
            Rectangle()
                .fill(PTColor.hairBold)
                .frame(width: 2, height: 22)
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 14))
                .foregroundStyle(PTColor.red)
        }
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
