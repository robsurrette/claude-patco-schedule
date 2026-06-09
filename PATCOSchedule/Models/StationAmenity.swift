import Foundation

/// A station amenity surfaced on the Station Info sheet.
///
/// The `rawValue` doubles as the chip label. Cases are declared in the order
/// they should appear on the sheet (elevator → escalator → bike racks →
/// parking), matching the PATCO accessibility/amenities table.
enum StationAmenity: String, CaseIterable, Identifiable {
    case elevator = "Elevator"
    case escalator = "Escalator"
    case bikeRacks = "Bike racks"
    case parking = "Parking"

    var id: String { rawValue }
    var label: String { rawValue }
}

extension Station {
    /// Amenities shown on the Station Info sheet, in canonical chip order.
    ///
    /// Sourced from PATCO's per-station amenity table rather than a positional
    /// heuristic: every station has an elevator and bike racks; "up" escalators
    /// are present everywhere except City Hall and 9/10th & Locust; parking is
    /// limited to the New Jersey park-and-ride stations (Lindenwold through
    /// Ferry Avenue — note Broadway has none).
    var amenities: [StationAmenity] {
        let available = Self.amenitiesByID[id] ?? []
        return StationAmenity.allCases.filter(available.contains)
    }

    private static let amenitiesByID: [String: Set<StationAmenity>] = [
        "lindenwold":      [.elevator, .escalator, .bikeRacks, .parking],
        "ashland":         [.elevator, .escalator, .bikeRacks, .parking],
        "woodcrest":       [.elevator, .escalator, .bikeRacks, .parking],
        "haddonfield":     [.elevator, .escalator, .bikeRacks, .parking],
        "westmont":        [.elevator, .escalator, .bikeRacks, .parking],
        "collingswood":    [.elevator, .escalator, .bikeRacks, .parking],
        "ferry-avenue":    [.elevator, .escalator, .bikeRacks, .parking],
        "broadway":        [.elevator, .escalator, .bikeRacks],
        "city-hall":       [.elevator, .bikeRacks],
        "franklin-square": [.elevator, .escalator, .bikeRacks],
        "8th-market":      [.elevator, .escalator, .bikeRacks],
        "9-10th-locust":   [.elevator, .bikeRacks],
        "12-13th-locust":  [.elevator, .escalator, .bikeRacks],
        "15-16th-locust":  [.elevator, .escalator, .bikeRacks],
    ]
}
