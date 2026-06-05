import Foundation

/// A station amenity surfaced on the Station Info sheet.
///
/// The `rawValue` doubles as the chip label, matching the handoff's
/// `amenitiesFor` strings.
enum StationAmenity: String, CaseIterable, Identifiable {
    case parking = "Parking"
    case bikeRacks = "Bike racks"
    case elevator = "Elevator"
    case escalator = "Escalator"

    var id: String { rawValue }
    var label: String { rawValue }
}

extension Station {
    /// Amenities shown on the Station Info sheet.
    ///
    /// Mirrors the handoff's `amenitiesFor`: the six urban stations from City
    /// Hall onward (`index >= 8` — Camden's civic stops plus the underground
    /// Philadelphia stations) list elevator + escalator only, while the
    /// park-and-ride stations before them (Lindenwold through Broadway) add
    /// parking and bike racks.
    var amenities: [StationAmenity] {
        index >= 8 ? [.elevator, .escalator] : [.parking, .bikeRacks, .elevator]
    }
}
