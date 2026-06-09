import Foundation

/// Computes fares between station pairs.
///
/// PATCO fares depend on which side of the Delaware a station is on and how far
/// the New Jersey station sits from Camden. `PATCOFareProvider` encodes PATCO's
/// published one-way fare matrix; round-trips are exactly twice the one-way.
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

/// PATCO's published one-way fares. Fares are symmetric (the price does not
/// depend on travel direction). Round-trips are twice the one-way fare, so the
/// default `roundTripFare` is used as-is.
///
/// Station indices follow `Station.all` (west→east, 0 = Lindenwold):
/// - `0...8`  New Jersey stations (Lindenwold → City Hall)
/// - `9...13` Philadelphia stations (Franklin Square → 15/16th & Locust)
struct PATCOFareProvider: FareProvider {
    /// Lowest index of the Philadelphia (Pennsylvania) stations.
    private static let firstPhillyIndex = 9
    /// Broadway and City Hall — the two Camden core stations.
    private static let camdenCore: Set<Int> = [7, 8]

    private func isPhilly(_ station: Station) -> Bool {
        station.index >= Self.firstPhillyIndex
    }

    func oneWayFare(from origin: Station, to dest: Station) -> Decimal {
        let originPhilly = isPhilly(origin)
        let destPhilly = isPhilly(dest)

        switch (originPhilly, destPhilly) {
        case (true, true):
            // Any Philadelphia station ↔ any Philadelphia station.
            return 1.40

        case (false, false):
            // New Jersey ↔ New Jersey: $1.40 between Broadway and City Hall,
            // otherwise $1.60.
            return Self.camdenCore == [origin.index, dest.index] ? 1.40 : 1.60

        default:
            // New Jersey ↔ Philadelphia: priced by the New Jersey station's
            // distance from Camden.
            let njIndex = originPhilly ? dest.index : origin.index
            switch njIndex {
            case 0...2: return 3.00   // Lindenwold, Ashland, Woodcrest
            case 3...5: return 2.60   // Haddonfield, Westmont, Collingswood
            case 6:     return 2.25   // Ferry Avenue (Camden)
            default:    return 1.40   // Broadway & City Hall (Camden)
            }
        }
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
