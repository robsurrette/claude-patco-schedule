import Foundation

/// Live status of a trip's departure.
enum TripStatus: Equatable {
    case onTime
    /// Delayed by `minutes` (drives the amber styling + "+N min delay").
    case delayed(minutes: Int)

    var delayMinutes: Int {
        if case let .delayed(m) = self { return m }
        return 0
    }
}

/// A concrete, rider-facing trip between the selected origin and destination on
/// the selected date — the unit rendered by "Up Next" and "Later today".
///
/// Resolved from the schedule for a specific date, so `depart`/`arrive` are full
/// `Date`s (not minutes-after-midnight).
struct Trip: Identifiable, Equatable {
    let id: String
    let origin: Station
    let dest: Station
    /// Scheduled departure from `origin`.
    let depart: Date
    /// Scheduled arrival at `dest`.
    let arrive: Date
    var status: TripStatus = .onTime
    /// True when this trip's times come from a special schedule and differ
    /// from the regular timetable (drives the "Adjusted" highlight).
    var isAdjusted: Bool = false

    /// Effective departure including any delay.
    var effectiveDepart: Date {
        depart.addingTimeInterval(TimeInterval(status.delayMinutes * 60))
    }

    /// Ride duration in whole minutes.
    var rideMinutes: Int {
        max(0, Int(arrive.timeIntervalSince(depart) / 60))
    }

    /// Number of stops ridden (inclusive of origin & dest endpoints).
    var stopCount: Int {
        abs(dest.index - origin.index) + 1
    }

    /// Seconds from `now` until effective departure (negative once departed).
    func secondsUntilDeparture(now: Date) -> Int {
        Int(effectiveDepart.timeIntervalSince(now))
    }
}
