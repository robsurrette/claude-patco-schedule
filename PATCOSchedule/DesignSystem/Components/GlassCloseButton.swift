import SwiftUI

/// Circular close ("✕") button used to dismiss modal sheets.
///
/// On iOS 26+ it adopts the system Liquid Glass material via `.glassEffect`,
/// giving the control the translucent, light-bending look of the platform's
/// native buttons (with an interactive press response). On earlier systems it
/// falls back to the app's flat `fill2` chip — or a `.ultraThinMaterial`
/// circle when the button floats over imagery — so it still reads as tappable.
struct GlassCloseButton: View {
    var diameter: CGFloat = 36
    var iconSize: CGFloat = 15
    var iconWeight: Font.Weight = .medium
    var iconColor: Color = PTColor.ink2
    /// Adds a soft drop shadow on the pre-iOS 26 fallback — used when the
    /// button sits over content (e.g. the Station Info hero) rather than a
    /// solid sheet background.
    var floatsOverContent = false
    var action: () -> Void

    var body: some View {
        Button(action: action) { label }
            .buttonStyle(.plain)
    }

    @ViewBuilder
    private var label: some View {
        let icon = Image(systemName: "xmark")
            .font(.system(size: iconSize, weight: iconWeight))
            .foregroundStyle(iconColor)
            .frame(width: diameter, height: diameter)

        if #available(iOS 26.0, *) {
            icon.glassEffect(.regular.interactive(), in: .circle)
        } else if floatsOverContent {
            icon
                .background(.ultraThinMaterial, in: Circle())
                .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 2)
        } else {
            icon.background(Circle().fill(PTColor.fill2))
        }
    }
}
