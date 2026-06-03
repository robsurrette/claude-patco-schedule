import Foundation
import Observation

/// A shared 1-second clock that drives the live "Up Next" countdown and the
/// `m:ss` ticker (the real-app replacement for the prototype's `useTick`).
///
/// Uses the real wall clock by default. For previews/development you can seed a
/// fixed virtual "now" and it advances from there.
@Observable
@MainActor
final class ClockTicker {
    private(set) var now: Date

    private var timer: Timer?
    private let virtualOffset: TimeInterval

    /// - Parameter virtualNow: when provided, `now` starts here instead of the
    ///   real time (handy for screenshots matching the prototype's 12:59).
    init(virtualNow: Date? = nil) {
        if let virtualNow {
            virtualOffset = virtualNow.timeIntervalSinceNow
        } else {
            virtualOffset = 0
        }
        now = Date().addingTimeInterval(virtualOffset)
    }

    func start() {
        guard timer == nil else { return }
        let t = Timer(timeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self else { return }
                self.now = Date().addingTimeInterval(self.virtualOffset)
            }
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }
}
