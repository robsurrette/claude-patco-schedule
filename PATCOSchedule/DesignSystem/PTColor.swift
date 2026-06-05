import SwiftUI

/// PATCO design-system color tokens.
///
/// Values mirror the `PT` palette in the design handoff (`patco/shared.jsx`),
/// which specifies **light mode** only. Each token is defined as a *dynamic*
/// color (`Color(light:dark:)`) so the whole app adapts when the user picks
/// Light / Dark / Automatic on the Settings tab (which drives
/// `preferredColorScheme`). The dark values are derived to keep the brand red,
/// readable neutrals, and the soft tint surfaces consistent in both modes.
enum PTColor {
    // MARK: Neutrals / surfaces

    /// App background (cool neutral grey). Light `#F1F1F4`.
    static let bg = dyn(0xF1F1F4, 0x0E0E11)
    /// Card / list surfaces. Light `#FFFFFF`.
    static let card = dyn(0xFFFFFF, 0x1C1C20)
    /// Primary text (near-black → near-white). Light `#17171B`.
    static let ink = dyn(0x17171B, 0xF2F2F5)
    /// Secondary text. Light `#6C6C75`.
    static let ink2 = dyn(0x6C6C75, 0x9A9AA3)
    /// Tertiary text / icons. Light `#A0A0A8`.
    static let ink3 = dyn(0xA0A0A8, 0x6B6B73)

    /// Hairline dividers. Light `rgba(60,60,67,0.10)`, dark `rgba(255,255,255,0.12)`.
    static let hair = Color(
        light: Color(hex: 0x3C3C43, opacity: 0.10),
        dark: Color(hex: 0xFFFFFF, opacity: 0.12)
    )
    /// Stronger hairline. Light `rgba(60,60,67,0.16)`, dark `rgba(255,255,255,0.22)`.
    static let hairBold = Color(
        light: Color(hex: 0x3C3C43, opacity: 0.16),
        dark: Color(hex: 0xFFFFFF, opacity: 0.22)
    )

    // MARK: Brand accents

    /// PATCO brand red — primary accent. Kept constant across modes so
    /// white-on-red buttons stay legible. `#D11141`.
    static let red = Color(hex: 0xD11141)
    /// Red tint surface (selected rows, badges, icon tiles). Light `#FBE7EC`;
    /// dark = translucent red over the surface.
    static let redSoft = Color(
        light: Color(hex: 0xFBE7EC),
        dark: Color(hex: 0xD11141, opacity: 0.22)
    )

    /// On-time status, success, toggles-on. Brightened for dark legibility.
    static let green = dyn(0x1B8A4B, 0x34D17A)
    /// Green tint surface. Light `#E4F3EA`; dark = translucent green.
    static let greenSoft = Color(
        light: Color(hex: 0xE4F3EA),
        dark: Color(hex: 0x34D17A, opacity: 0.20)
    )

    /// Delay / heads-up status. Brightened for dark legibility.
    static let amber = dyn(0xB8791C, 0xE6AE47)
    /// Amber tint surface (alert banner). Light `#FBEFD8`; dark = translucent amber.
    static let amberSoft = Color(
        light: Color(hex: 0xFBEFD8),
        dark: Color(hex: 0xE6AE47, opacity: 0.18)
    )

    // MARK: Fills

    /// Inset fill chips / icon tiles. Light `#F1F1F4`.
    static let fill = dyn(0xF1F1F4, 0x2A2A30)
    /// Slightly darker fill (close buttons). Light `#E8E8EC`.
    static let fill2 = dyn(0xE8E8EC, 0x34343B)

    /// Active floating-tab-bar pill background (subtle wash behind the selection).
    static let tabActive = Color(
        light: Color(hex: 0x000000, opacity: 0.05),
        dark: Color(hex: 0xFFFFFF, opacity: 0.10)
    )

    // MARK: One-off inline colors called out in the handoff

    /// Alert-banner title text. Light `#7A5210`; lightened for the dark banner.
    static let alertTitle = dyn(0x7A5210, 0xF0C66A)
    /// Alert-banner body text. Light `#8A6420`; lightened for the dark banner.
    static let alertBody = dyn(0x8A6420, 0xE0BC84)

    /// Connecting-transit + accessibility brand colors (logo-like; constant).
    enum Brand {
        static let septa = Color(hex: 0x1A6DB4)
        static let riverLine = Color(hex: 0x3AA5C4)
        static let njTransit = Color(hex: 0xE07B1A)
        static let amtrak = Color(hex: 0x1C2C57)
        /// Email quick-action tile.
        static let email = Color(hex: 0x3A6FD8)
        /// X / near-black quick-action tile.
        static let x = PTColor.dyn(0x111111, 0xF2F2F5)
        /// Accessibility tile background.
        static let accessibilityBG = PTColor.dyn(0xE7EEF9, 0x1B2436)
        /// Accessibility tile icon.
        static let accessibilityIcon = Color(hex: 0x3A6FD8)
    }

    // MARK: Helpers

    /// A token that resolves to one of two `0xRRGGBB` literals by color scheme.
    static func dyn(_ light: UInt32, _ dark: UInt32) -> Color {
        Color(light: Color(hex: light), dark: Color(hex: dark))
    }
}

extension Color {
    /// Initialize from a 24-bit `0xRRGGBB` literal in the sRGB space.
    init(hex: UInt32, opacity: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: opacity)
    }

    /// A dynamic color that resolves to `light` or `dark` based on the active
    /// interface style. Adapts to SwiftUI's `colorScheme` environment — including
    /// when it's forced via `.preferredColorScheme(_:)`.
    init(light: Color, dark: Color) {
        #if canImport(UIKit)
        self.init(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
        #else
        self = light
        #endif
    }
}
