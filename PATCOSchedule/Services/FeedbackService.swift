import Foundation

/// Posts app-developer feedback to the project's AWS API Gateway endpoint.
///
/// Mirrors the legacy UIKit implementation: a single JSON `POST` with the app
/// version plus the user's (optional) name/email and required message. Empty
/// fields are sent as `"N/A"` because the Lambda rejects empty strings.
struct FeedbackService {
    /// The submit-feedback API Gateway endpoint.
    var endpoint: URL?
    /// Injected so previews/tests don't hit the network.
    var session: URLSession = .shared

    static let live = FeedbackService(
        endpoint: URL(string: "https://2xqtbkpq5l.execute-api.us-east-1.amazonaws.com/submitFeedback")
    )

    enum SubmitError: LocalizedError {
        case invalidURL
        case invalidResponse
        case server(Int)

        var errorDescription: String? {
            switch self {
            case .invalidURL:      return "Couldn't reach the feedback service."
            case .invalidResponse: return "Got an unexpected response. Please try again."
            case .server(let code): return "The server returned an error (\(code)). Please try again."
            }
        }
    }

    /// Submit feedback. Throws `SubmitError` (or a `URLError`) on failure.
    func submit(name: String, email: String, message: String) async throws {
        guard let endpoint else { throw SubmitError.invalidURL }

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
        // The Lambda fails on empty strings, so substitute "N/A".
        let payload: [String: String] = [
            "appVersion": appVersion,
            "name": name.isEmpty ? "N/A" : name,
            "email": email.isEmpty ? "N/A" : email,
            "message": message.isEmpty ? "N/A" : message,
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)

        let (_, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw SubmitError.invalidResponse }
        guard (200...299).contains(http.statusCode) else { throw SubmitError.server(http.statusCode) }
    }
}
