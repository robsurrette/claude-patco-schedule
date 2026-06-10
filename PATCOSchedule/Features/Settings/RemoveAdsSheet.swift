import SwiftUI

/// "Remove Ads" in-app-purchase sheet. Hero + benefits + a sticky purchase
/// footer wired to `PremiumStore` (StoreKit 2). Mirrors `flow-paywall.jsx`.
struct RemoveAdsSheet: View {
    @Environment(PremiumStore.self) private var premium
    @Environment(\.dismiss) private var dismiss

    @State private var showError = false
    @State private var isRestoring = false
    @State private var showRestoreEmpty = false
    @State private var legalDocument: LegalDocument?

    private struct Benefit: Identifiable {
        let id = UUID()
        let symbol: String
        let title: String
        let subtitle: String
    }

    private let benefits = [
        Benefit(symbol: "checkmark", title: "No banner ads", subtitle: "Every screen, completely ad-free"),
        Benefit(symbol: "bolt.fill", title: "Faster, cleaner schedules", subtitle: "Nothing between you and your train"),
        Benefit(symbol: "heart.fill", title: "Support an indie developer", subtitle: "A one-time thank you, no subscription"),
    ]

    var body: some View {
        VStack(spacing: 0) {
            closeBar
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    hero.padding(.top, 6)
                    benefitsCard.padding(.top, 24)
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 24)
            }
            purchaseFooter
        }
        .background(PTColor.bg)
        .presentationDetents([.large])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(PTRadius.sheet)
        .onChange(of: premium.isPremium) { _, isPremium in
            if isPremium { dismiss() }
        }
        .alert("Purchase didn't complete", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Something went wrong. You weren't charged — please try again.")
        }
        .alert("No purchases to restore", isPresented: $showRestoreEmpty) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("We couldn't find a previous Remove Ads purchase on this Apple Account.")
        }
        .sheet(item: $legalDocument) { doc in
            LegalDocumentSheet(document: doc)
        }
    }

    // MARK: - Close

    private var closeBar: some View {
        HStack {
            Spacer()
            #if compiler(>=6.2)
            if #available(iOS 26.0, *) {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(PTColor.ink2)
                        .frame(width: 28, height: 28)
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.circle)
            } else {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(PTColor.ink2)
                        .frame(width: 28, height: 28)
                }
                .buttonBorderShape(.circle)
            }
            #else
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(PTColor.ink2)
                    .frame(width: 28, height: 28)
            }
            .buttonBorderShape(.circle)
            #endif
        }
        .padding(.horizontal, 14)
        .padding(.top, 8)
    }

    // MARK: - Hero

    private var hero: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [PTColor.red, Color(hex: 0xB30E37)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 84, height: 84)
                .overlay {
                    Image(systemName: "star.fill")
                        .font(.system(size: 38))
                        .foregroundStyle(.white)
                }
                .shadow(color: PTColor.red.opacity(0.32), radius: 13, x: 0, y: 10)

            Text("Remove Ads")
                .ptStyle(PTFont.largeTitle)
                .foregroundStyle(PTColor.ink)
                .padding(.top, 18)

            Text("Unlock a clean, ad-free PATCO Schedule with a single one-time purchase.")
                .font(PTFont.book(15))
                .foregroundStyle(PTColor.ink2)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .frame(maxWidth: 280)
                .padding(.top, 7)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Benefits

    private var benefitsCard: some View {
        PTCard(radius: 18, padding: 0) {
            VStack(spacing: 0) {
                ForEach(Array(benefits.enumerated()), id: \.element.id) { index, benefit in
                    HStack(spacing: 14) {
                        Image(systemName: benefit.symbol)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(PTColor.green)
                            .frame(width: 34, height: 34)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(PTColor.greenSoft)
                            )
                        VStack(alignment: .leading, spacing: 1) {
                            Text(benefit.title)
                                .font(PTFont.bold(16))
                                .foregroundStyle(PTColor.ink)
                            Text(benefit.subtitle)
                                .font(PTFont.book(13))
                                .foregroundStyle(PTColor.ink2)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(.vertical, 14)
                    .overlay(alignment: .bottom) {
                        if index < benefits.count - 1 { Hairline(inset: 48) }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Purchase footer

    private var purchaseFooter: some View {
        VStack(spacing: 13) {
            Button(action: buy) {
                ZStack {
                    Text("Buy now · \(premium.displayPrice)")
                        .font(PTFont.bold(17))
                        .foregroundStyle(.white)
                        .opacity(premium.isPurchasing ? 0 : 1)
                    if premium.isPurchasing {
                        ProgressView().tint(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(PTColor.red)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .shadow(color: PTColor.red.opacity(0.28), radius: 9, x: 0, y: 6)
            }
            .buttonStyle(.plain)
            .disabled(premium.isPurchasing)

            Button(action: restore) {
                if isRestoring {
                    ProgressView().controlSize(.small)
                } else {
                    Text("Restore purchase")
                        .font(PTFont.medium(13.5))
                        .foregroundStyle(PTColor.ink2)
                }
            }
            .buttonStyle(.plain)
            .disabled(premium.isPurchasing || isRestoring)

            HStack(spacing: 14) {
                Button("Terms") { legalDocument = .terms }
                    .font(PTFont.medium(13))
                    .foregroundStyle(PTColor.ink2)
                Circle().fill(PTColor.ink3).frame(width: 3, height: 3)
                Button("Privacy") { legalDocument = .privacy }
                    .font(PTFont.medium(13))
                    .foregroundStyle(PTColor.ink2)
            }
            .buttonStyle(.plain)

            Text("One-time purchase · no subscription")
                .font(PTFont.book(12))
                .foregroundStyle(PTColor.ink3)
        }
        .padding(.horizontal, 22)
        .padding(.top, 14)
        .padding(.bottom, 26)
        .frame(maxWidth: .infinity)
        .background(
            PTColor.bg.opacity(0.9)
                .background(.ultraThinMaterial)
        )
        .overlay(alignment: .top) { Hairline(inset: 0) }
    }

    // MARK: - Actions

    private func buy() {
        Task {
            // Dismissal on success is handled by the `isPremium` onChange; only
            // surface an error when the purchase genuinely failed (not a cancel
            // or a pending parental-approval flow).
            if await premium.purchase() == .failed {
                showError = true
            }
        }
    }

    private func restore() {
        Task {
            isRestoring = true
            await premium.restore()
            isRestoring = false
            // On success `isPremium` flips and the sheet dismisses via onChange;
            // if nothing was restored, tell the user.
            if !premium.isPremium {
                showRestoreEmpty = true
            }
        }
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            RemoveAdsSheet()
                .environment(PremiumStore())
        }
}
