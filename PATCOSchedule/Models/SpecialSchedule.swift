import Foundation

// MARK: - Special-schedule feed schema
//
// PATCO posts a "special schedule" PDF (same layout as the printed timetable,
// with adjusted rows highlighted) for individual dates — concerts, holidays,
// track work. A server-side pipeline (tools/update_specials.py, run by GitHub
// Actions) parses each PDF into this feed, which the app fetches and caches
// so adjusted times appear automatically and remain available offline.
//
// Trust model: when the pipeline can parse and validate a PDF it publishes the
// COMPLETE timetable for the affected date(s); when it can't (layout change,
// scanned PDF, ambiguous dates) it publishes an `alertOnly` entry, which the
// app renders as a banner over the regular timetable — never wrong times,
// at worst un-adjusted ones.

/// Root document fetched from the published feed (`specials.json`).
struct SpecialScheduleFeed: Codable {
    /// Breaking-change gate: the app ignores feeds with a newer major schema.
    static let supportedSchemaVersion = 1

    var schemaVersion: Int
    /// ISO-8601 timestamp the feed was generated.
    var generatedAt: String
    var specials: [SpecialSchedule]
}

/// One special-schedule posting.
struct SpecialSchedule: Codable, Identifiable {
    var id: String
    /// Affected service days as "yyyy-MM-dd" in PATCO's timezone (Eastern).
    /// May be empty when the pipeline couldn't determine dates — such entries
    /// are shown as an undated banner on "today" only.
    var dates: [String]
    /// Rider-facing heading, e.g. "Special Schedule — Dec 25".
    var title: String
    /// Optional rider-facing detail line.
    var message: String?
    /// Link to the source PDF on RidePATCO.org.
    var sourceURL: String?
    /// True when only the banner should be shown (no parsed times).
    var alertOnly: Bool
    /// The complete timetable in effect on `dates` (all day types, both
    /// directions — same shape as the bundled document). `nil` iff `alertOnly`.
    var services: [ServiceSchedule]?
}

extension SpecialSchedule {
    /// PATCO operates in Eastern time; feed dates are resolved against it so a
    /// rider checking from another timezone still sees the right service day.
    static let timeZone = TimeZone(identifier: "America/New_York") ?? .current

    private static let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = timeZone
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    /// Whether this special applies to the service day containing `date`.
    func applies(to date: Date) -> Bool {
        dates.contains(Self.dayFormatter.string(from: date))
    }
}
