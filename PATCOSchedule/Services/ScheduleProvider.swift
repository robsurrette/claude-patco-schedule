import Foundation

/// Source of timetable data. `BundledScheduleSource` serves the timetable
/// shipped in the app; `OverlayScheduleSource` wraps it and substitutes a
/// special schedule (from `SpecialScheduleStore`) on dates that have one.
protocol ScheduleProvider {
    /// The loaded timetable document.
    var document: ScheduleDocument { get }

    /// Trips from `origin` to `dest` on `date`, ordered by departure.
    func trips(origin: Station, dest: Station, date: Date, calendar: Calendar) -> [Trip]
}

extension ScheduleProvider {
    /// Upcoming (not-yet-departed) trips relative to `now`.
    func upcomingTrips(origin: Station, dest: Station, date: Date, now: Date, calendar: Calendar = .current) -> [Trip] {
        trips(origin: origin, dest: dest, date: date, calendar: calendar)
            .filter { $0.effectiveDepart > now }
    }
}

/// Shared timetable→trips resolution, used for both the bundled document and
/// special-schedule overlays (which carry the same `[ServiceSchedule]` shape).
enum ScheduleResolver {
    static func trips(
        in services: [ServiceSchedule],
        origin: Station, dest: Station, date: Date, calendar: Calendar
    ) -> [Trip] {
        guard origin != dest else { return [] }

        let direction = Direction.between(origin: origin, dest: dest)
        let dayType = DayType.forDate(date, calendar: calendar)

        guard let service = services.first(where: {
            $0.direction == direction && $0.dayType == dayType
        }) else { return [] }

        let midnight = calendar.startOfDay(for: date)

        return service.trains.compactMap { run -> Trip? in
            guard
                let originStop = run.stops.first(where: { $0.stationId == origin.id }),
                let destStop = run.stops.first(where: { $0.stationId == dest.id }),
                destStop.minutes > originStop.minutes
            else { return nil }

            let depart = midnight.addingTimeInterval(TimeInterval(originStop.minutes * 60))
            let arrive = midnight.addingTimeInterval(TimeInterval(destStop.minutes * 60))
            return Trip(id: run.id, origin: origin, dest: dest, depart: depart, arrive: arrive)
        }
        .sorted { $0.depart < $1.depart }
    }
}

/// Loads the timetable bundled in the app (`Schedule.json`, generated from
/// the official PATCO timetable PDF by `tools/parse_timetable.py`).
struct BundledScheduleSource: ScheduleProvider {
    let document: ScheduleDocument

    /// Load from the app bundle. Fails loudly in DEBUG if the resource is
    /// missing or malformed so data problems surface immediately.
    init(resource: String = "Schedule", bundle: Bundle = .main) {
        guard
            let url = bundle.url(forResource: resource, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let decoded = try? JSONDecoder().decode(ScheduleDocument.self, from: data)
        else {
            assertionFailure("Missing or invalid \(resource).json in bundle")
            self.document = ScheduleDocument(version: 0, generatedAt: "", stationOrder: [], services: [])
            return
        }
        self.document = decoded
    }

    func trips(origin: Station, dest: Station, date: Date, calendar: Calendar) -> [Trip] {
        ScheduleResolver.trips(
            in: document.services,
            origin: origin, dest: dest, date: date, calendar: calendar
        )
    }
}

/// Overlays special schedules on a baseline provider: on a date covered by a
/// parsed special schedule, trips come from that timetable instead, with runs
/// whose times differ from the regular timetable flagged `isAdjusted`.
/// Alert-only specials (no parsed times) fall through to the baseline.
struct OverlayScheduleSource: ScheduleProvider {
    let base: ScheduleProvider
    let specials: SpecialScheduleStore

    var document: ScheduleDocument { base.document }

    func trips(origin: Station, dest: Station, date: Date, calendar: Calendar) -> [Trip] {
        let baseline = {
            base.trips(origin: origin, dest: dest, date: date, calendar: calendar)
        }
        guard let services = specials.special(on: date)?.services else {
            return baseline()
        }

        var trips = ScheduleResolver.trips(
            in: services,
            origin: origin, dest: dest, date: date, calendar: calendar
        )
        let regular = Set(baseline().map { TimePair(depart: $0.depart, arrive: $0.arrive) })
        for i in trips.indices {
            trips[i].isAdjusted = !regular.contains(
                TimePair(depart: trips[i].depart, arrive: trips[i].arrive))
        }
        return trips
    }

    private struct TimePair: Hashable {
        let depart: Date
        let arrive: Date
    }
}
