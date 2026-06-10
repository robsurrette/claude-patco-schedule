import Foundation
import Observation
import BackgroundTasks

/// Fetches and caches the special-schedule feed (`specials.json`, published by
/// the GitHub Actions pipeline — see `tools/update_specials.py`).
///
/// Offline-first: the last good feed is persisted to Application Support and
/// loaded synchronously at startup, so a rider who opened the app earlier sees
/// special schedules with no connectivity. Refreshes are conditional (ETag),
/// making the steady-state check a 304 with no body.
///
/// Reads happen on the main thread (view bodies); mutations are funneled
/// through `apply(_:)` on the main actor.
@Observable
final class SpecialScheduleStore {
    /// Served by GitHub Pages from the `feed` branch of the app repo.
    static let feedURL = URL(string: "https://robsurrette.github.io/claude-patco-schedule/specials.json")!

    private static let etagKey = "patco.specials.etag"

    /// The current feed (cached or freshly fetched); nil before first fetch.
    private(set) var feed: SpecialScheduleFeed?
    /// When the feed was last successfully fetched or revalidated.
    private(set) var lastRefreshed: Date?

    @ObservationIgnored private let defaults: UserDefaults
    @ObservationIgnored private let session: URLSession

    init(defaults: UserDefaults = .standard, session: URLSession = .shared) {
        self.defaults = defaults
        self.session = session
    }

    /// A store pre-loaded with a fixed feed and no networking — for previews
    /// and tests (e.g. exercising the banner and "Adjusted" styling).
    convenience init(previewFeed: SpecialScheduleFeed) {
        self.init()
        feed = previewFeed
    }

    // MARK: Lookup

    /// The special schedule covering `date`, if any. Dated entries win over
    /// undated alert-only entries; undated entries only surface for today,
    /// mirroring the legacy "a special schedule has been posted" banner.
    func special(on date: Date) -> SpecialSchedule? {
        guard let specials = feed?.specials else { return nil }
        if let dated = specials.first(where: { $0.applies(to: date) }) {
            return dated
        }
        if Calendar.current.isDateInToday(date) {
            return specials.first(where: { $0.dates.isEmpty })
        }
        return nil
    }

    // MARK: Lifecycle

    /// Load the persisted feed (synchronously, it's small) and kick off a
    /// network refresh. Call once at launch.
    func start() {
        if let data = try? Data(contentsOf: Self.cacheURL),
           let cached = Self.decode(data) {
            feed = cached
        }
        Task { await refresh() }
    }

    /// Conditional fetch of the feed; keeps the cache on any failure.
    func refresh() async {
        var request = URLRequest(url: Self.feedURL)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        if let etag = defaults.string(forKey: Self.etagKey) {
            request.setValue(etag, forHTTPHeaderField: "If-None-Match")
        }

        guard let (data, response) = try? await session.data(for: request),
              let http = response as? HTTPURLResponse else { return }

        switch http.statusCode {
        case 304:
            await apply(feed: nil, etag: nil, revalidated: true)
        case 200:
            guard let fresh = Self.decode(data) else { return }
            try? FileManager.default.createDirectory(
                at: Self.cacheURL.deletingLastPathComponent(),
                withIntermediateDirectories: true)
            try? data.write(to: Self.cacheURL, options: .atomic)
            await apply(
                feed: fresh,
                etag: http.value(forHTTPHeaderField: "ETag"),
                revalidated: true)
        default:
            return
        }
    }

    @MainActor
    private func apply(feed: SpecialScheduleFeed?, etag: String?, revalidated: Bool) {
        if let feed { self.feed = feed }
        if let etag { defaults.set(etag, forKey: Self.etagKey) }
        if revalidated { lastRefreshed = .now }
    }

    // MARK: Background refresh

    /// Identifier registered in Info.plist (`BGTaskSchedulerPermittedIdentifiers`).
    static let backgroundTaskID = "com.robsurrette.PatcoTrainSchedule.refresh"

    /// Ask the system for a background refresh a few hours out. Called when
    /// the app backgrounds and after each background run; duplicates are a
    /// harmless no-op error.
    func scheduleBackgroundRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: Self.backgroundTaskID)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 4 * 60 * 60)
        try? BGTaskScheduler.shared.submit(request)
    }

    // MARK: Persistence

    private static var cacheURL: URL {
        let support = FileManager.default.urls(
            for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return support.appendingPathComponent("specials.json")
    }

    private static func decode(_ data: Data) -> SpecialScheduleFeed? {
        guard let feed = try? JSONDecoder().decode(SpecialScheduleFeed.self, from: data),
              feed.schemaVersion <= SpecialScheduleFeed.supportedSchemaVersion
        else { return nil }
        return feed
    }
}
