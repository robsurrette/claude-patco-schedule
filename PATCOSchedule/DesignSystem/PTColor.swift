import SwiftUI

/// PATCO design-system color tokens.
///
/// Values mirror the `PT` palette in the design handoff (`patco/shared.jsx`).
/// Defined in code (rather than the asset catalog) so the exact hex tokens are
/// the single source of truth; the asset-catalog `AccentColor` mirrors `red`
/// for the system global accent.
enum PTColor {
    /// App background (cool neutral grey). `#F1F1F4`
    static let bg = Color(hex: 0xF1F1F4)
    /// Card / list surfaces. `#FFFFFF`
    static let card = Color(hex: 0xFFFFFF)
    /// Primary text (near-black). `#17171B`
    static let ink = Color(hex: 0x17171B)
    /// Secondary text. `#6C6C75`
    static let ink2 = Color(hex: 0x6C6C75)
    /// Tertiary text / icons. `#A0A0A8`
    static let ink3 = Color(hex: 0xA0A0A8)

    /// Hairline dividers. `rgba(60,60,67,0.10)`
    static let hair = Color(red: 60/255, green: 60/255, blue: 67/255).opacity(0.10)
    /// Stronger hairline. `rgba(60,60,67,0.16)`
    static let hairBold = Color(red: 60/255, green: 60/255, blue: 67/255).opacity(0.16)

    /// PATCO brand red — primary accent (use sparingly). `#D11141`
    static let red = Color(hex: 0xD11141)
    /// Red tint surface (selected rows, badges). `#FBE7EC`
    static let redSoft = Color(hex: 0xFBE7EC)

    /// On-time status, success, toggles-on. `#1B8A4B`
    static let green = Color(hex: 0x1B8A4B)
    /// Green tint surface. `#E4F3EA`
    static let greenSoft = Color(hex: 0xE4F3EA)

    /// Delay / heads-up status. `#B8791C`
    static let amber = Color(hex: 0xB8791C)
    /// Amber tint surface (alert banner). `#FBEFD8`
    static let amberSoft = Color(hex: 0xFBEFD8)

    /// Inset fill chips / icon tiles. `#F1F1F4`
    static let fill = Color(hex: 0xF1F1F4)
    /// Slightly darker fill (close buttons). `#E8E8EC`
    static let fill2 = Color(hex: 0xE8E8EC)

    // MARK: One-off inline colors called out in the handoff

    /// Alert-banner title text. `#7A5210`
    static let alertTitle = Color(hex: 0x7A5210)
    /// Alert-banner body text. `#8A6420`
    static let alertBody = Color(hex: 0x8A6420)

    /// Connecting-transit + accessibility brand colors.
    enum Brand {
        static let septa = Color(hex: 0x1A6DB4)
        static let riverLine = Color(hex: 0x3AA5C4)
        static let njTransit = Color(hex: 0xE07B1A)
        static let amtrak = Color(hex: 0x1C2C57)
        /// Email quick-action tile.
        static let email = Color(hex: 0x3A6FD8)
        /// X / near-black quick-action tile.
        static let x = Color(hex: 0x111111)
        /// Accessibility tile background.
        static let accessibilityBG = Color(hex: 0xE7EEF9)
        /// Accessibility tile icon.
        static let accessibilityIcon = Color(hex: 0x3A6FD8)
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
}
