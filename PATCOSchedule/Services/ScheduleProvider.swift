import Foundation

/// Source of timetable data. The MVP ships `BundledScheduleSource`; a future
/// `RemoteScheduleSource` (twice-a-year refresh) conforms to the same protocol
/// and uses the identical `ScheduleDocument` schema, so swapping it in requires
/// no changes to callers.
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

/// Loads the timetable bundled in the app (`MockSchedule.json` for now).
struct BundledScheduleSource: ScheduleProvider {
    let document: ScheduleDocument

    /// Load from the app bundle. Fails loudly in DEBUG if the resource is
    /// missing or malformed so data problems surface immediately.
    init(resource: String = "MockSchedule", bundle: Bundle = .main) {
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
        guard origin != dest else { return [] }

        let direction = Direction.between(origin: origin, dest: dest)
        let dayType = DayType.forDate(date, calendar: calendar)

        guard let service = document.services.first(where: {
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
