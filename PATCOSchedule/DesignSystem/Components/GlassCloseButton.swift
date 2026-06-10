import SwiftUI

/// Circular ✕ button for dismissing modal sheets.
///
/// On iOS 26 (when built with Xcode 26 / Swift 6.2 or newer) it adopts
/// SwiftUI's native Liquid Glass button style. On older OS versions — and
/// when compiled with an SDK that predates the API — it falls back to a plain
/// circular button. The `#if compiler` gate is required because
/// `.buttonStyle(.glass)` does not exist in pre-iOS 26 SDKs, so a runtime
/// `#available` check alone still fails to compile.
struct GlassCloseButton: View {
    var diameter: CGFloat = 28
    var glyphSize: CGFloat = 18
    var action: () -> Void

    var body: some View {
        #if compiler(>=6.2)
        if #available(iOS 26.0, *) {
            button
                .buttonStyle(.glass)
                .buttonBorderShape(.circle)
        } else {
            button
                .buttonBorderShape(.circle)
        }
        #else
        button
            .buttonBorderShape(.circle)
        #endif
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
