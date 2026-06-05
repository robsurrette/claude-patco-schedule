import SwiftUI

/// Settings tab — premium upsell, appearance, app icon, and feedback.
/// Mirrors `flow-settings.jsx` (Direction A).
struct SettingsView: View {
    @Environment(PremiumStore.self) private var premium
    @Environment(AppState.self) private var appState
    @Environment(\.openURL) private var openURL

    @State private var showPaywall = false
    @State private var showDeveloperFeedback = false
    @State private var showPatcoMail = false

    private static let patcoFeedbackEmail = "patco@ridepatco.com"

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—"
    }

    var body: some View {
        @Bindable var appState = appState

        ScreenScaffold(title: "Settings") {
            premiumCard

            SectionHeader(title: "Appearance").padding(.top, 8)
            appearanceCard(selection: $appState.theme)

            appIconRow

            SectionHeader(title: "Feedback").padding(.top, 8)
            feedbackCard

            footer
        }
        .sheet(isPresented: $showPaywall) {
            RemoveAdsSheet()
        }
        .sheet(isPresented: $showDeveloperFeedback) {
            DeveloperFeedbackSheet()
        }
        .sheet(isPresented: $showPatcoMail) {
            MailComposeView(recipient: Self.patcoFeedbackEmail, subject: "PATCO Feedback")
                .ignoresSafeArea()
        }
    }

    // MARK: - Premium

    @ViewBuilder
    private var premiumCard: some View {
        if premium.isPremium {
            PTCard(radius: PTRadius.cardLarge, padding: 16) {
                HStack(spacing: 13) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(PTColor.green)
                        .frame(width: 44, height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(PTColor.greenSoft)
                        )
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Ad-free unlocked")
                            .font(PTFont.bold(17))
                            .foregroundStyle(PTColor.ink)
                        Text("Thanks for supporting the app.")
                            .font(PTFont.book(13.5))
                            .foregroundStyle(PTColor.ink2)
                    }
                    Spacer(minLength: 0)
                }
            }
        } else {
            Button { showPaywall = true } label: {
                PTCard(radius: PTRadius.cardLarge, padding: 16) {
                    HStack(spacing: 14) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(PTColor.red)
                            .frame(width: 46, height: 46)
                            .background(
                                RoundedRectangle(cornerRadius: 13, style: .continuous)
                                    .fill(PTColor.redSoft)
                            )
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Remove ads")
                                .font(PTFont.bold(17))
                                .foregroundStyle(PTColor.ink)
                            Text("Go ad-free · one-time \(premium.displayPrice)")
                                .font(PTFont.book(13.5))
                                .foregroundStyle(PTColor.ink2)
                        }
                        Spacer(minLength: 0)
                        Text("Upgrade")
                            .font(PTFont.bold(14))
                            .foregroundStyle(PTColor.red)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Capsule().fill(PTColor.redSoft))
                    }
                }
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Appearance

    private func appearanceCard(selection: Binding<AppTheme>) -> some View {
        PTCard(padding: 14) {
            HStack(spacing: 10) {
                ForEach(AppTheme.allCases) { theme in
                    let isOn = selection.wrappedValue == theme
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selection.wrappedValue = theme
                        }
                    } label: {
                        VStack(spacing: 8) {
                            ThemeSwatch(theme: theme)
                                .padding(3)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(isOn ? PTColor.red : .clear)
                                )
                            HStack(spacing: 5) {
                                if isOn {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundStyle(PTColor.red)
                                }
                                Text(theme.label)
                                    .font(isOn ? PTFont.bold(14) : PTFont.medium(14))
                                    .foregroundStyle(isOn ? PTColor.ink : PTColor.ink2)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - App icon (stubbed until alternate icon assets are imported)

    private var appIconRow: some View {
        // TODO: present `AppIconPickerSheet` once the 15 alternate-icon
        // .appiconset previews are added to Assets.xcassets (see Appearance.swift).
        PTCard(padding: 0) {
            HStack(spacing: 13) {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(PTColor.fill)
                    .frame(width: 40, height: 40)
                    .overlay {
                        Image(systemName: "app.dashed")
                            .font(.system(size: 18))
                            .foregroundStyle(PTColor.ink3)
                    }
                VStack(alignment: .leading, spacing: 1) {
                    Text("Change app icon")
                        .ptStyle(PTFont.rowLabel)
                        .foregroundStyle(PTColor.ink)
                    Text("Coming soon")
                        .font(PTFont.book(13))
                        .foregroundStyle(PTColor.ink3)
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .frame(minHeight: 64)
        }
        .opacity(0.7)
    }

    // MARK: - Feedback

    private var feedbackCard: some View {
        PTCard(padding: 0) {
            VStack(spacing: 0) {
                SettingsRow(symbol: "bubble.left", title: "Submit PATCO feedback") {
                    openPatcoFeedback()
                }
                Hairline(inset: 59)
                SettingsRow(symbol: "text.bubble", title: "Submit app developer feedback") {
                    showDeveloperFeedback = true
                }
            }
        }
    }

    private func openPatcoFeedback() {
        if MailComposeView.canSendMail {
            showPatcoMail = true
        } else if let url = URL(string: "mailto:\(Self.patcoFeedbackEmail)?subject=PATCO%20Feedback") {
            openURL(url)
        }
    }

    // MARK: - Footer

    private var footer: some View {
        VStack(spacing: 3) {
            Text("PATCO Schedule")
                .font(PTFont.medium(13.5))
                .foregroundStyle(PTColor.ink3)
            Text("Version \(appVersion)")
                .font(PTFont.book(12.5))
                .foregroundStyle(PTColor.ink3)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 18)
    }
}

// MARK: - Settings row

/// A tappable settings list row: icon tile, label, chevron.
private struct SettingsRow: View {
    let symbol: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 13) {
                Image(systemName: symbol)
                    .font(.system(size: 16))
                    .foregroundStyle(PTColor.ink)
                    .frame(width: 30, height: 30)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(PTColor.fill)
                    )
                Text(title)
                    .ptStyle(PTFont.rowLabel)
                    .foregroundStyle(PTColor.ink)
                Spacer(minLength: 8)
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(PTColor.ink3)
            }
            .padding(.horizontal, 16)
            .frame(minHeight: 54)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Theme swatch

/// A miniature phone preview for the appearance picker (light / dark / system).
private struct ThemeSwatch: View {
    let theme: AppTheme

    var body: some View {
        Group {
            switch theme {
            case .automatic: split
            case .light:     panel(bg: .white, bars: [.black.opacity(0.16), .black.opacity(0.10)])
            case .dark:      panel(bg: Color(hex: 0x1C1C20), bars: [.white.opacity(0.35), .white.opacity(0.18)])
            }
        }
        .frame(height: 58)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(.black.opacity(0.08), lineWidth: 1)
        )
    }

    private func panel(bg: Color, bars: [Color]) -> some View {
        bg.overlay(alignment: .leading) {
            VStack(alignment: .leading, spacing: 5) {
                Circle().fill(PTColor.red).frame(width: 9, height: 9)
                Capsule().fill(bars[0]).frame(width: 50, height: 4)
                Capsule().fill(bars[1]).frame(width: 34, height: 4)
            }
            .padding(.leading, 9)
        }
    }

    private var split: some View {
        ZStack {
            Color.white
            Color(hex: 0x1C1C20)
                .clipShape(Triangle())
            Circle().fill(PTColor.red).frame(width: 7, height: 7)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.leading, 9).padding(.top, 12)
            Circle().fill(PTColor.red).frame(width: 7, height: 7)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(.trailing, 9).padding(.bottom, 12)
        }
    }
}

/// Lower-left triangle used for the "Automatic" split swatch.
private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    SettingsView()
        .environment(PremiumStore())
        .environment(AppState())
}
