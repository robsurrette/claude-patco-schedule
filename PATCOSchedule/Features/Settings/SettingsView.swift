import SwiftUI

/// Settings tab — placeholder scaffold. Shows the live premium state to confirm
/// `PremiumStore` is wired; Remove-Ads, appearance, app-icon, and feedback land
/// next phase.
struct SettingsView: View {
    @Environment(PremiumStore.self) private var premium

    var body: some View {
        ScreenScaffold(title: "Settings") {
            PTCard(padding: 16) {
                HStack(spacing: 12) {
                    Image(systemName: premium.isPremium ? "checkmark.seal.fill" : "star.fill")
                        .foregroundStyle(premium.isPremium ? PTColor.green : PTColor.red)
                        .frame(width: 32, height: 32)
                        .background(
                            RoundedRectangle(cornerRadius: PTRadius.tile, style: .continuous)
                                .fill(premium.isPremium ? PTColor.greenSoft : PTColor.redSoft)
                        )
                    VStack(alignment: .leading, spacing: 2) {
                        Text(premium.isPremium ? "Ad-free unlocked" : "Remove ads")
                            .ptStyle(PTFont.rowLabel)
                        Text(premium.isPremium ? "Thanks for your support" : "One-time \(premium.displayPrice)")
                            .ptStyle(PTFont.body).foregroundStyle(PTColor.ink2)
                    }
                    Spacer()
                }
            }
            ComingSoonNote(screen: "Remove Ads sheet, appearance, app-icon picker, and feedback")
        }
    }
}

#Preview {
    SettingsView()
        .environment(PremiumStore())
}
