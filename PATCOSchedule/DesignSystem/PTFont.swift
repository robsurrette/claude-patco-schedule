import SwiftUI

/// PATCO typography tokens.
///
/// The brand face is **Circular Std** (bundled in `Resources/Fonts`, registered
/// via `UIAppFonts` in Info.plist). PostScript names were verified against the
/// `.otf` files: `CircularStd-Book / -Medium / -Bold / -Black`.
///
/// Letter-spacing from the handoff's type scale is expressed via SwiftUI
/// `.tracking(...)`; the semantic `Text` helpers below apply it for you.
enum PTFont {
    enum Name {
        static let book = "CircularStd-Book"      // Regular (400)
        static let medium = "CircularStd-Medium"  // Medium (500)
        static let bold = "CircularStd-Bold"      // Bold (700)
        static let black = "CircularStd-Black"    // Heavy (800/900)
    }

    // MARK: Raw weight constructors

    static func book(_ size: CGFloat) -> Font { .custom(Name.book, size: size) }
    static func medium(_ size: CGFloat) -> Font { .custom(Name.medium, size: size) }
    static func bold(_ size: CGFloat) -> Font { .custom(Name.bold, size: size) }
    static func black(_ size: CGFloat) -> Font { .custom(Name.black, size: size) }

    // MARK: Semantic styles (size / weight / tracking from the handoff)

    /// Screen title (tab headers): 28pt Black, tracking -0.4.
    static let screenTitle = Style(font: black(28), tracking: -0.4)
    /// Sheet titles: 21pt Bold, tracking -0.3 (handoff range 19–23pt).
    static let sheetTitle = Style(font: bold(21), tracking: -0.3)
    /// Station Info hero title: 30pt Black, tracking -0.5.
    static let largeTitle = Style(font: black(30), tracking: -0.5)
    /// Big "Up Next" countdown number: 48pt Black, tracking -1.3.
    static let countdown = Style(font: black(48), tracking: -1.3)
    /// Station / list row label: 17pt Medium (handoff 16.5–17.5pt).
    static let rowLabel = Style(font: medium(17), tracking: 0)
    /// Trip times: 18pt Bold, tabular figures.
    static let tripTime = Style(font: bold(18), tracking: 0, monospacedDigit: true)
    /// Body / secondary: 14pt Book.
    static let body = Style(font: book(14), tracking: 0)
    /// Section header overline: 12.5pt Bold, UPPERCASE, tracking +0.6.
    static let overline = Style(font: bold(12.5), tracking: 0.6)
    /// Tab bar label: 11pt.
    static let tabLabel = Style(font: medium(11), tracking: 0)

    /// A font paired with its tracking and figure style, applied together.
    struct Style {
        var font: Font
        var tracking: CGFloat = 0
        var monospacedDigit: Bool = false
    }
}

extension Text {
    /// Apply a `PTFont.Style` (font + tracking + optional tabular figures).
    func ptStyle(_ style: PTFont.Style) -> some View {
        var text = self.font(style.monospacedDigit ? style.font.monospacedDigit() : style.font)
        text = text.tracking(style.tracking)
        return text
    }
}

#if DEBUG
import os

/// Call once on launch in DEBUG to confirm the Circular Std faces registered.
/// If a name is missing, Font.custom silently falls back to the system font.
enum PTFontDebug {
    static func verifyRegistration() {
        #if canImport(UIKit)
        let expected = [PTFont.Name.book, PTFont.Name.medium, PTFont.Name.bold, PTFont.Name.black]
        for name in expected where UIFont(name: name, size: 12) == nil {
            os_log(.fault, "PATCO: font '%{public}@' is NOT registered — check UIAppFonts / file names.", name)
        }
        #endif
    }
}
#endif
