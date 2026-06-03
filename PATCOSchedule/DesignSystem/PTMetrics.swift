import SwiftUI

/// Corner radii from the handoff.
enum PTRadius {
    static let card: CGFloat = 16        // standard cards / list surfaces
    static let cardLarge: CGFloat = 20   // "Up Next" + summary cards
    static let sheet: CGFloat = 22       // bottom-sheet top corners
    static let tabBar: CGFloat = 26      // floating tab bar
    static let tileSmall: CGFloat = 8    // small icon tiles
    static let tile: CGFloat = 11        // icon tiles (swap button, quick actions)
    static let tileLarge: CGFloat = 16   // larger icon tiles
    static let pill: CGFloat = 999       // full-round pills / chips
}

/// Spacing tokens from the handoff.
enum PTSpacing {
    static let screenH: CGFloat = 16     // horizontal content padding
    static let headerTop: CGFloat = 56   // sticky-header status-bar clearance
    static let rowV: CGFloat = 14        // vertical rhythm inside rows
    static let cardGap: CGFloat = 14     // gap between stacked cards
    static let hairlineInset: CGFloat = 16
}

/// Shadow tokens from the handoff, applied via `.ptShadow(_:)`.
struct PTShadow {
    var color: Color
    var radius: CGFloat
    var x: CGFloat
    var y: CGFloat

    /// Resting card: `0 1px 2px rgba(0,0,0,0.04)`.
    static let card = PTShadow(color: .black.opacity(0.04), radius: 2, x: 0, y: 1)
    /// Elevated "Up Next" card: `0 5px 18px rgba(17,17,27,0.07)`.
    static let elevated = PTShadow(color: Color(hex: 0x17171B, opacity: 0.07), radius: 18, x: 0, y: 5)
    /// Popover: `0 16px 40px rgba(17,17,27,0.22)`.
    static let popover = PTShadow(color: Color(hex: 0x17171B, opacity: 0.22), radius: 40, x: 0, y: 16)
    /// Date popover: `0 18px 44px rgba(17,17,27,0.24)`.
    static let datePopover = PTShadow(color: Color(hex: 0x17171B, opacity: 0.24), radius: 44, x: 0, y: 18)
    /// Bottom sheet: `0 -10px 40px rgba(0,0,0,0.18)`.
    static let sheet = PTShadow(color: .black.opacity(0.18), radius: 40, x: 0, y: -10)
    /// Tab bar: `0 6px 24px rgba(0,0,0,0.10)`.
    static let tabBar = PTShadow(color: .black.opacity(0.10), radius: 24, x: 0, y: 6)
}

extension View {
    /// Apply a `PTShadow` token.
    ///
    /// Note: the design's shadow blur is a CSS blur value; SwiftUI's `radius`
    /// is roughly half of that, so the tokens above are pre-halved for parity.
    func ptShadow(_ shadow: PTShadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius / 2, x: shadow.x, y: shadow.y)
    }
}
