import SwiftUI

/// The floating, blurred, rounded (26pt) bottom tab bar from the handoff.
///
/// Active tab = PATCO red icon + bold label over a subtle rounded background;
/// inactive = ink icon + book label. Sits 14pt off the bottom.
struct FloatingTabBar: View {
    @Binding var selection: AppTab

    var body: some View {
        HStack(spacing: 4) {
            ForEach(AppTab.allCases) { tab in
                tabButton(tab)
            }
        }
        .padding(6)
        .background(
            PTColor.bg.opacity(0.86)
                .background(.ultraThinMaterial)
        )
        .clipShape(RoundedRectangle(cornerRadius: PTRadius.tabBar, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: PTRadius.tabBar, style: .continuous)
                .stroke(PTColor.hair, lineWidth: 0.5)
        )
        .ptShadow(.tabBar)
        .padding(.horizontal, 28)
        .padding(.bottom, 14)
    }

    private func tabButton(_ tab: AppTab) -> some View {
        let isActive = selection == tab
        return Button {
            selection = tab
        } label: {
            VStack(spacing: 3) {
                Image(systemName: tab.symbol)
                    .font(.system(size: 20, weight: isActive ? .semibold : .regular))
                Text(tab.title)
                    .ptStyle(isActive ? PTFont.Style(font: PTFont.bold(11)) : PTFont.tabLabel)
            }
            .foregroundStyle(isActive ? PTColor.red : PTColor.ink)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(isActive ? PTColor.tabActive : .clear)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(tab.title)
        .accessibilityAddTraits(isActive ? [.isSelected] : [])
    }
}

#Preview {
    struct Harness: View {
        @State var tab: AppTab = .schedule
        var body: some View {
            VStack {
                Spacer()
                FloatingTabBar(selection: $tab)
            }
            .background(PTColor.bg)
        }
    }
    return Harness()
}
