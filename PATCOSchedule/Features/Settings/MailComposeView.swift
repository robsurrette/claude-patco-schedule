import SwiftUI
import MessageUI

/// SwiftUI wrapper around `MFMailComposeViewController` for the in-app mail
/// compose flow (used by "Submit PATCO feedback"). Callers should check
/// `MailComposeView.canSendMail` and fall back to a `mailto:` URL otherwise.
struct MailComposeView: UIViewControllerRepresentable {
    let recipient: String
    var subject: String = ""
    @Environment(\.dismiss) private var dismiss

    /// Whether the device is configured to send mail in-app.
    static var canSendMail: Bool { MFMailComposeViewController.canSendMail() }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let controller = MFMailComposeViewController()
        controller.mailComposeDelegate = context.coordinator
        controller.setToRecipients([recipient])
        if !subject.isEmpty { controller.setSubject(subject) }
        return controller
    }

    func updateUIViewController(_ controller: MFMailComposeViewController, context: Context) { }

    func makeCoordinator() -> Coordinator { Coordinator(dismiss: dismiss) }

    final class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        private let dismiss: DismissAction
        init(dismiss: DismissAction) { self.dismiss = dismiss }

        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            dismiss()
        }
    }
}
