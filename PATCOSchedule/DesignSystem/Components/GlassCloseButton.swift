import SwiftUI

/// Circular ✕ button for dismissing modal sheets.
///
/// On iOS 26 it adopts SwiftUI's native Liquid Glass button style; on older
/// OS versions it falls back to a plain circular button. The project now
/// builds with the iOS 26 SDK (Xcode 26), so a runtime `#available` check is
/// sufficient — no `#if compiler` gate is needed.
struct GlassCloseButton: View {
    var diameter: CGFloat = 28
    var glyphSize: CGFloat = 18
    var action: () -> Void

    var body: some View {
        if #available(iOS 26.0, *) {
            button
                .buttonStyle(.glass)
                .buttonBorderShape(.circle)
        } else {
            button
                .buttonBorderShape(.circle)
        }
    }

    private var button: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .font(.system(size: glyphSize, weight: .medium))
                .foregroundStyle(PTColor.ink2)
                .frame(width: diameter, height: diameter)
        }
    }
}
