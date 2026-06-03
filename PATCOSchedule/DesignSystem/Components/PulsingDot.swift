import SwiftUI

/// The live "now" indicator — a solid dot with a ring that scales out and fades
/// (the `ptpulse` keyframe: scale 1→2.6 while fading, 1.8s ease-out infinite).
///
/// Respects Reduce Motion: the animated ring is decorative and is omitted when
/// motion is reduced, leaving the static dot visible.
struct PulsingDot: View {
    var color: Color = PTColor.red
    var size: CGFloat = 7

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var animating = false

    var body: some View {
        ZStack {
            if !reduceMotion {
                Circle()
                    .fill(color.opacity(0.45))
                    .frame(width: size, height: size)
                    .scaleEffect(animating ? 2.6 : 1)
                    .opacity(animating ? 0 : 0.45)
                    .animation(.easeOut(duration: 1.8).repeatForever(autoreverses: false), value: animating)
            }
            Circle()
                .fill(color)
                .frame(width: size, height: size)
        }
        .frame(width: size, height: size)
        .onAppear { animating = true }
    }
}

#Preview {
    HStack(spacing: 24) {
        PulsingDot()
        PulsingDot(color: PTColor.green)
        PulsingDot(color: PTColor.amber)
    }
    .padding(40)
    .background(PTColor.bg)
}
