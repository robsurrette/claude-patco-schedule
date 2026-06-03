import SwiftUI

/// Appearance preference set on the Settings tab.
enum AppTheme: String, CaseIterable, Identifiable, Codable {
    case automatic
    case light
    case dark

    var id: String { rawValue }

    var label: String {
        switch self {
        case .automatic: return "Automatic"
        case .light:     return "Light"
        case .dark:      return "Dark"
        }
    }

    /// Maps to SwiftUI's `preferredColorScheme` (nil = follow system).
    var colorScheme: ColorScheme? {
        switch self {
        case .automatic: return nil
        case .light:     return .light
        case .dark:      return .dark
        }
    }
}

/// An alternate app icon option for the picker (`setAlternateIconName(_:)`).
///
/// `iconName` is the `CFBundleAlternateIcons` key in Info.plist; `nil` means the
/// primary icon. `assetName` is the preview thumbnail in the asset catalog.
struct AppIconOption: Identifiable, Hashable {
    enum Group: String, CaseIterable, Identifiable {
        case colors = "Colors"
        case styles = "Styles"
        case seasonal = "Seasonal"
        var id: String { rawValue }
    }

    let id: String          // stable key, e.g. "classic"
    let displayName: String
    let iconName: String?   // alternate-icon name, nil for primary
    let assetName: String   // preview image in Assets.xcassets
    let group: Group
}

extension AppIconOption {
    /// The 15 alternate icons from the handoff (`patco/icons/`), grouped.
    /// Preview asset names are placeholders until the icon sets are imported.
    static let all: [AppIconOption] = [
        // Colors
        .init(id: "classic", displayName: "Classic", iconName: nil,            assetName: "icon-classic", group: .colors),
        .init(id: "black",   displayName: "Black",   iconName: "AppIconBlack", assetName: "icon-black",   group: .colors),
        .init(id: "white",   displayName: "White",   iconName: "AppIconWhite", assetName: "icon-white",   group: .colors),
        .init(id: "blue",    displayName: "Blue",    iconName: "AppIconBlue",  assetName: "icon-blue",    group: .colors),
        .init(id: "green",   displayName: "Green",   iconName: "AppIconGreen", assetName: "icon-green",   group: .colors),
        .init(id: "mint",    displayName: "Mint",    iconName: "AppIconMint",  assetName: "icon-mint",    group: .colors),
        .init(id: "peach",   displayName: "Peach",   iconName: "AppIconPeach", assetName: "icon-peach",   group: .colors),
        .init(id: "purple",  displayName: "Purple",  iconName: "AppIconPurple",assetName: "icon-purple",  group: .colors),
        .init(id: "yellow",  displayName: "Yellow",  iconName: "AppIconYellow",assetName: "icon-yellow",  group: .colors),
        // Styles
        .init(id: "geometric",  displayName: "Geometric",  iconName: "AppIconGeometric",  assetName: "icon-geometric",  group: .styles),
        .init(id: "neon",       displayName: "Neon",       iconName: "AppIconNeon",       assetName: "icon-neon",       group: .styles),
        .init(id: "monochrome", displayName: "Monochrome", iconName: "AppIconMonochrome", assetName: "icon-monochrome", group: .styles),
        // Seasonal
        .init(id: "halloween",     displayName: "Halloween",      iconName: "AppIconHalloween",     assetName: "icon-halloween",     group: .seasonal),
        .init(id: "snow",          displayName: "Snow",           iconName: "AppIconSnow",          assetName: "icon-snow",          group: .seasonal),
        .init(id: "holidayLights", displayName: "Holiday Lights", iconName: "AppIconHolidayLights", assetName: "icon-holidayLights", group: .seasonal),
    ]

    static let `default` = all[0]

    static func option(id: String) -> AppIconOption { all.first { $0.id == id } ?? .default }
}
