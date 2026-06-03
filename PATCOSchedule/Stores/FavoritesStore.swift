import Foundation
import Observation

/// Favorited stations, surfaced in the station picker's Favorites section.
///
/// Persisted in `UserDefaults` (the real-app replacement for the prototype's
/// `localStorage` key `patco.favStations`). Stored as an array of station ids.
@Observable
final class FavoritesStore {
    private static let key = "patco.favStations"
    private let defaults: UserDefaults

    /// Default favorites match the prototype's seed.
    private static let seed = ["woodcrest", "15-16th-locust", "haddonfield"]

    private(set) var favoriteIDs: [String]

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let stored = defaults.array(forKey: Self.key) as? [String] {
            favoriteIDs = stored
        } else {
            favoriteIDs = Self.seed
        }
    }

    func isFavorite(_ station: Station) -> Bool {
        favoriteIDs.contains(station.id)
    }

    func toggle(_ station: Station) {
        if let idx = favoriteIDs.firstIndex(of: station.id) {
            favoriteIDs.remove(at: idx)
        } else {
            favoriteIDs.append(station.id)
        }
        persist()
    }

    /// Favorited stations resolved to `Station`, in line order.
    var favoriteStations: [Station] {
        favoriteIDs.compactMap(Station.station(id:)).sorted { $0.index < $1.index }
    }

    private func persist() {
        defaults.set(favoriteIDs, forKey: Self.key)
    }
}
