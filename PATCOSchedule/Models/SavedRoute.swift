import Foundation

/// A user-saved origin→destination pair shown in the Saved-routes popover.
struct SavedRoute: Identifiable, Codable, Hashable {
    let id: UUID
    var label: String
    var originID: String
    var destID: String

    init(id: UUID = UUID(), label: String, originID: String, destID: String) {
        self.id = id
        self.label = label
        self.originID = originID
        self.destID = destID
    }

    var origin: Station? { Station.station(id: originID) }
    var dest: Station? { Station.station(id: destID) }
}

extension SavedRoute {
    /// Seed routes matching the prototype's popover (Home / Work / weekend).
    static let samples: [SavedRoute] = [
        SavedRoute(label: "Home",    originID: "woodcrest",     destID: "15-16th-locust"),
        SavedRoute(label: "Work",    originID: "15-16th-locust", destID: "woodcrest"),
        SavedRoute(label: "Weekend", originID: "haddonfield",    destID: "8th-market"),
    ]
}
