import Foundation

/// Computes fares between station pairs.
///
/// PATCO fares are **distance/zone-based**. This provider models that with a
/// per-station zone and a zone-distance → price table. The values below are
/// **placeholders** structured the right way — replace `fareTable` with PATCO's
/// official fare matrix (and adjust `zone(for:)` if their zoning differs).
protocol FareProvider {
    /// One-way fare between two stations.
    func oneWayFare(from origin: Station, to dest: Station) -> Decimal
    /// Round-trip fare (defaults to 2× one-way).
    func roundTripFare(from origin: Station, to dest: Station) -> Decimal
}

extension FareProvider {
    func roundTripFare(from origin: Station, to dest: Station) -> Decimal {
        oneWayFare(from: origin, to: dest) * 2
    }
}

/// Zone-distance fare model. Placeholder values until the real matrix lands.
struct ZoneFareProvider: FareProvider {
    /// Zone assigned to each station id. PLACEHOLDER zoning.
    private func zone(for station: Station) -> Int {
        // Roughly group the 14 stops into 4 distance bands from Center City.
        switch station.index {
        case 0...2:   return 4   // Lindenwold / Ashland / Woodcrest
        case 3...5:   return 3   // Haddonfield / Westmont / Collingswood
        case 6...9:   return 2   // Ferry Ave / Broadway / City Hall / Franklin Sq
        default:      return 1   // Center City stations
        }
    }

    /// one-way price keyed by absolute zone distance. PLACEHOLDER fares.
    private let fareTable: [Int: Decimal] = [
        0: 1.40,
        1: 1.60,
        2: 2.25,
        3: 2.60,
        4: 3.00,
    ]

    func oneWayFare(from origin: Station, to dest: Station) -> Decimal {
        let distance = abs(zone(for: origin) - zone(for: dest))
        return fareTable[distance] ?? 3.00
    }
}

extension Decimal {
    /// Formatted as USD currency, e.g. "$3.00".
    var asUSD: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: self as NSDecimalNumber) ?? "$\(self)"
    }
}
