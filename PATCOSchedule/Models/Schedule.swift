import Foundation

/// Direction of travel along the line.
enum Direction: String, Codable, CaseIterable {
    /// Toward Lindenwold (decreasing station index).
    case westbound
    /// Toward Center City Philadelphia (increasing station index).
    case eastbound

    /// Direction implied by traveling from `origin` to `dest`.
    static func between(origin: Station, dest: Station) -> Direction {
        dest.index > origin.index ? .eastbound : .westbound
    }
}

/// Service calendar bucket. PATCO runs distinct timetables for these.
enum DayType: String, Codable, CaseIterable {
    case weekday
    case saturday
    case sundayHoliday

    /// The day type for a given date (holidays handled separately later).
    static func forDate(_ date: Date, calendar: Calendar = .current) -> DayType {
        switch calendar.component(.weekday, from: date) {
        case 1: return .sundayHoliday   // Sunday
        case 7: return .saturday        // Saturday
        default: return .weekday
        }
    }
}

// MARK: - Bundled / downloadable schedule schema
//
// This is the single schema used for BOTH the bundled timetable (MVP) and the
// future over-the-network refresh. Times are stored as minutes-after-midnight
// (Int), which is GTFS-derivable and timezone-agnostic; the app resolves them
// against the rider's selected date. Keep this schema stable & versioned so a
// newer remote document can be validated and swapped in without code changes.

/// Root document loaded from `Schedule.json` (and later from the network).
struct ScheduleDocument: Codable {
    /// Monotonic schema/content version. The remote refresh only replaces the
    /// bundled document when `version` is greater than what's stored.
    var version: Int
    /// ISO-8601 timestamp the document was generated.
    var generatedAt: String
    /// Station ids in west→east order (sanity-checked against `Station.all`).
    var stationOrder: [String]
    /// All train runs, grouped by service + direction.
    var services: [ServiceSchedule]
}

/// All train runs for one (dayType, direction) combination.
struct ServiceSchedule: Codable {
    var dayType: DayType
    var direction: Direction
    var trains: [TrainRun]
}

/// A single train's run: an ordered list of timed stops.
struct TrainRun: Codable, Identifiable {
    var id: String
    var stops: [ScheduledStop]
}

/// One stop on a train run.
struct ScheduledStop: Codable {
    /// Station id (matches `Station.id`).
    var stationId: String
    /// Departure time as minutes after midnight (0...1439, may exceed for
    /// post-midnight service).
    var minutes: Int
}
