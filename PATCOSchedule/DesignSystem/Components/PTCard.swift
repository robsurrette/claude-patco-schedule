import SwiftUI

/// A white rounded surface — the base for the route selector, list cards, and
/// summary cards. Defaults to the resting card shadow + standard radius.
struct PTCard<Content: View>: View {
    var radius: CGFloat = PTRadius.card
    var shadow: PTShadow = .card
    var padding: CGFloat? = nil
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(padding ?? 0)
            .background(PTColor.card)
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .ptShadow(shadow)
    }
}

/// A full-round pill container used for chips and small buttons.
struct PTPill<Content: View>: View {
    var fill: Color = PTColor.card
    @ViewBuilder var content: Content

    var body: some View {
        content
            .clipShape(Capsule(style: .continuous))
            .background(Capsule(style: .continuous).fill(fill))
    }
}

#Preview {
    VStack(spacing: 16) {
        PTCard(padding: 16) {
            Text("Resting card").ptStyle(PTFont.rowLabel)
        }
        PTCard(radius: PTRadius.cardLarge, shadow: .elevated, padding: 16) {
            Text("Elevated card").ptStyle(PTFont.rowLabel)
        }
    }
    .padding()
    .background(PTColor.bg)
}
