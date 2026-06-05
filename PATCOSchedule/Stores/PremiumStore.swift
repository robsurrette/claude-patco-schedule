import Foundation
import Observation
import StoreKit

/// Owns the one-time "Remove Ads" purchase and the resulting premium flag.
///
/// Uses StoreKit 2. The product identifier is the live "Remove Ads" IAP from
/// App Store Connect, so the product loads and existing customers can Restore.
/// Premium state is cached in UserDefaults for instant launch, then reconciled
/// against `Transaction.currentEntitlements`.
@Observable
@MainActor
final class PremiumStore {
    /// The live "Remove Ads" product id from App Store Connect.
    static let removeAdsProductID = "com.robsurrette.PatcoTrainSchedule.removeAds"

    private static let cacheKey = "patco.isPremium"
    private let defaults: UserDefaults

    /// Whether ads should be hidden. Drives the Settings "Ad-free" state.
    private(set) var isPremium: Bool
    /// The loaded product (for price display), once fetched.
    private(set) var removeAdsProduct: Product?
    private(set) var isPurchasing = false

    private var updatesTask: Task<Void, Never>?

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.isPremium = defaults.bool(forKey: Self.cacheKey)
    }

    /// Start listening for transactions and reconcile entitlements. Call once
    /// on launch.
    func start() {
        updatesTask = Task { [weak self] in
            for await update in Transaction.updates {
                await self?.handle(verification: update)
            }
        }
        Task { await refreshEntitlements() }
        Task { await loadProducts() }
    }

    /// Display price, e.g. "$0.99". Falls back to the configured price until the
    /// product loads from StoreKit.
    var displayPrice: String {
        removeAdsProduct?.displayPrice ?? "$0.99"
    }

    func loadProducts() async {
        do {
            let products = try await Product.products(for: [Self.removeAdsProductID])
            removeAdsProduct = products.first
        } catch {
            // Non-fatal: keep the fallback price; product is nil until StoreKit
            // config / App Store Connect entry exists.
            removeAdsProduct = nil
        }
    }

    /// The outcome of a purchase attempt, so callers can tell a user cancel
    /// (no error UI) apart from a genuine failure.
    enum PurchaseOutcome {
        case success
        case cancelled
        case pending
        case failed
    }

    /// Trigger the purchase flow.
    @discardableResult
    func purchase() async -> PurchaseOutcome {
        guard let product = removeAdsProduct else { return .failed }
        isPurchasing = true
        defer { isPurchasing = false }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                await handle(verification: verification)
                return isPremium ? .success : .failed
            case .userCancelled:
                return .cancelled
            case .pending:
                return .pending
            @unknown default:
                return .failed
            }
        } catch {
            return .failed
        }
    }

    func restore() async {
        try? await AppStore.sync()
        await refreshEntitlements()
    }

    // MARK: Private

    private func refreshEntitlements() async {
        for await entitlement in Transaction.currentEntitlements {
            await handle(verification: entitlement)
        }
    }

    private func handle(verification: VerificationResult<Transaction>) async {
        guard case .verified(let transaction) = verification else { return }
        if transaction.productID == Self.removeAdsProductID, transaction.revocationDate == nil {
            setPremium(true)
        }
        await transaction.finish()
    }

    private func setPremium(_ value: Bool) {
        isPremium = value
        defaults.set(value, forKey: Self.cacheKey)
    }
}
