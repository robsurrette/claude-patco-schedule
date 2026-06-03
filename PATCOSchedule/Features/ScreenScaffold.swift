import SwiftUI

/// Shared per-tab layout: a pinned blurred `StickyHeader` over scrollable
/// content, with bottom inset so content clears the floating tab bar.
struct ScreenScaffold<Trailing: View, Content: View>: View {
    let title: String
    @ViewBuilder var trailing: Trailing
    @ViewBuilder var content: Content

    /// Approx. floating tab-bar height + bottom offset.
    private let tabBarInset: CGFloat = 96

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: PTSpacing.cardGap) {
                content
            }
            .padding(.horizontal, PTSpacing.screenH)
            .padding(.top, 4)
            .padding(.bottom, tabBarInset)
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            StickyHeader(title: title) { trailing }
        }
        .background(PTColor.bg)
        .ignoresSafeArea(edges: .top)
    }
}

extension ScreenScaffold where Trailing == EmptyView {
    init(title: String, @ViewBuilder content: () -> Content) {
        self.init(title: title, trailing: { EmptyView() }, content: content)
    }
}

/// Temporary content block marking a screen that's scaffolded but not yet built.
struct ComingSoonNote: View {
    let screen: String
    var body: some View {
        PTCard(padding: 18) {
            VStack(alignment: .leading, spacing: 6) {
                SectionHeader(title: "Next up")
                Text("\(screen) — design system is wired; screen implementation lands in the next phase.")
                    .ptStyle(PTFont.body)
                    .foregroundStyle(PTColor.ink2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
