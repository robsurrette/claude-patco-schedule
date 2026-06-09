import Foundation

/// A PATCO Speedline station.
///
/// `id` is a stable slug used as the key in the schedule document, favorites
/// storage, and saved routes — it must never change once shipped. `index` is
/// the west→east position on the line (0 = Lindenwold).
struct Station: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let index: Int

    /// True for the four underground Center-City Philadelphia stations
    /// (8th & Market eastward). Station Info amenities are looked up per
    /// station rather than by position — see `amenities`.
    var isCenterCity: Bool { index >= 10 }
}

extension Station {
    /// The 14 stations in real west→east order (Lindenwold, NJ → Center City).
    static let all: [Station] = [
        Station(id: "lindenwold",       name: "Lindenwold",          index: 0),
        Station(id: "ashland",          name: "Ashland",             index: 1),
        Station(id: "woodcrest",        name: "Woodcrest",           index: 2),
        Station(id: "haddonfield",      name: "Haddonfield",         index: 3),
        Station(id: "westmont",         name: "Westmont",            index: 4),
        Station(id: "collingswood",     name: "Collingswood",        index: 5),
        Station(id: "ferry-avenue",     name: "Ferry Avenue",        index: 6),
        Station(id: "broadway",         name: "Broadway",            index: 7),
        Station(id: "city-hall",        name: "City Hall",           index: 8),
        Station(id: "franklin-square",  name: "Franklin Square",     index: 9),
        Station(id: "8th-market",       name: "8th & Market",        index: 10),
        Station(id: "9-10th-locust",    name: "9/10th & Locust",     index: 11),
        Station(id: "12-13th-locust",   name: "12/13th & Locust",    index: 12),
        Station(id: "15-16th-locust",   name: "15/16th & Locust",    index: 13),
    ]

    private static let byID = Dictionary(uniqueKeysWithValues: all.map { ($0.id, $0) })

    static func station(id: String) -> Station? { byID[id] }
}
