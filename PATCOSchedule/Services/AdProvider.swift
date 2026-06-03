import SwiftUI

/// Abstraction over the ad SDK so screens depend on a protocol, not a vendor.
///
/// The skeleton ships `NoOpAdProvider` — no SDK dependency is added yet. When
/// you wire **Google AdMob** (the planned provider), implement `AdMobProvider`
/// against this protocol and swap it in at the root; nothing else changes.
/// Ads are only shown when the user is **not** premium.
protocol AdProvider {
    /// A banner view to place on ad-supported screens (empty when premium / no SDK).
    @MainActor func bannerView() -> AnyView
}

/// Placeholder provider: renders nothing. Keeps the app buildable with no SDK.
struct NoOpAdProvider: AdProvider {
    @MainActor func bannerView() -> AnyView { AnyView(EmptyView()) }
}

/// Google AdMob test identifiers, for reference when the SDK is integrated.
/// Replace with the live app/unit ids from the existing AdMob account.
enum AdMobConfig {
    static let testAppID = "ca-app-pub-3940256099942544~1458002511"
    static let testBannerUnitID = "ca-app-pub-3940256099942544/2934735716"
    // TODO: production app id + banner/interstitial unit ids.
}
