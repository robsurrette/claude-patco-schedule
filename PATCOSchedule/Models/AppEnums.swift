import Foundation

/// The four primary tabs.
enum AppTab: String, CaseIterable, Identifiable {
    case schedule
    case stationMap
    case info
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .schedule:   return "Schedule"
        case .stationMap: return "Station Map"
        case .info:       return "Patco Info"
        case .settings:   return "Settings"
        }
    }

    /// SF Symbol for the tab bar — outlined (inactive) variant.
    var symbol: String {
        switch self {
        case .schedule:   return "clock"
        case .stationMap: return "tram"
        case .info:       return "info.circle"
        case .settings:   return "gearshape"
        }
    }

    /// SF Symbol for the tab bar — filled (active) variant.
    var symbolFilled: String {
        switch self {
        case .schedule:   return "clock.fill"
        case .stationMap: return "tram.fill"
        case .info:       return "info.circle.fill"
        case .settings:   return "gearshape.fill"
        }
    }
}

/// Which end of the route the station picker is currently editing.
enum RouteEnd {
    case origin
    case destination
}

/// Modally-presented sheets. Mirrors the prototype's `sheet` / sheet-ish state.
enum AppSheet: Identifiable {
    case stationPicker(RouteEnd)
    case tripDetails(Trip)
    case stationInfo(Station)
    case paywall
    case appIconPicker

    var id: String {
        switch self {
        case .stationPicker(let end): return "station-\(end == .origin ? "o" : "d")"
        case .tripDetails(let trip):  return "trip-\(trip.id)"
        case .stationInfo(let s):     return "info-\(s.id)"
        case .paywall:                return "paywall"
        case .appIconPicker:          return "appicon"
        }
    }
}
