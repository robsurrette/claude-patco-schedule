import SwiftUI

/// A blurred, translucent sticky header with a large screen title and an
/// optional trailing accessory (e.g. the Schedule tab's "Saved" pill).
///
/// The blur uses an ultra-thin material over the app background tint, matching
/// the handoff's `backdrop-filter: blur(18–20px)` translucent surface.
struct StickyHeader<Trailing: View>: View {
    let title: String
    @ViewBuilder var trailing: Trailing

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .ptStyle(PTFont.screenTitle)
                .foregroundStyle(PTColor.ink)
            Spacer(minLength: 8)
            trailing
        }
        .padding(.horizontal, PTSpacing.screenH)
        .padding(.top, PTSpacing.headerTop)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            PTColor.bg.opacity(0.86)
                .background(.ultraThinMaterial)
        )
    }
}

extension StickyHeader where Trailing == EmptyView {
    init(title: String) {
        self.init(title: title) { EmptyView() }
    }
}

#Preview {
    VStack(spacing: 0) {
        StickyHeader(title: "Schedule") {
            Label("Saved", systemImage: "star")
                .ptStyle(PTFont.rowLabel)
                .padding(.horizontal, 12).padding(.vertical, 7)
                .background(Capsule().fill(PTColor.card))
        }
        StickyHeader(title: "Station Map")
        Spacer()
    }
    .background(PTColor.bg)
    .ignoresSafeArea()
}
