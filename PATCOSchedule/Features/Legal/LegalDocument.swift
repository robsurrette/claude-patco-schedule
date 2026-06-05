import Foundation

/// A legal document (Privacy Policy / Terms of Use) shown in-app and linked from
/// the Remove Ads purchase screen to satisfy App Store guideline 3.1.2.
///
/// The body uses a tiny markup the viewer understands:
///   "## Heading"   → section heading
///   "- bullet"     → bullet row
///   blank line     → paragraph break
///
/// Identical copies live in `docs/legal/` for hosting (App Store Connect needs
/// a public Privacy Policy URL).
struct LegalDocument: Identifiable {
    let id: String
    let title: String
    let effectiveDate: String
    let body: String
}

extension LegalDocument {
    /// Provider/developer name used throughout the documents.
    static let provider = "Robert Surrette"
    static let appName = "PATCO Schedule"
    static let effective = "June 5, 2026"

    static let privacy = LegalDocument(
        id: "privacy",
        title: "Privacy Policy",
        effectiveDate: effective,
        body: """
        \(provider) ("we," "us") built \(appName) (the "App"). This policy \
        explains what information the App handles and how. We designed the App \
        to collect as little as possible.

        ## Information you provide
        The App does not require an account. The only information you actively \
        share is what you enter in the in-app feedback form:
        - Your message (required)
        - Your name and email address (both optional)
        - The App version, sent automatically with your message

        We use this solely to read and respond to your feedback. If you leave \
        the name and email blank, we cannot identify or reply to you.

        ## Purchases
        The optional "Remove Ads" purchase is processed by Apple through the \
        App Store. Apple handles your payment; we never receive your card or \
        billing details. We only learn whether you are entitled to the \
        ad-free upgrade so the App can unlock it and restore it on your devices.

        ## Information we do NOT collect
        - We do not require or collect your name unless you choose to share it.
        - We do not collect your location, contacts, or photos.
        - We do not track you across other apps or websites.
        - We do not sell your personal information.

        ## Where your information goes
        Feedback you submit is transmitted over a secure connection to our \
        service provider (Amazon Web Services) so we can receive it. Purchase \
        and restore requests go to Apple. We do not share your information with \
        anyone else except as required by law.

        ## Data retention
        We keep feedback messages only as long as needed to address them, then \
        delete them. You can ask us to delete feedback you sent by contacting \
        us (see below).

        ## Children
        The App is not directed to children under 13, and we do not knowingly \
        collect information from them.

        ## Your choices and contact
        Providing your name and email in feedback is always optional. To ask a \
        question or request deletion of feedback you submitted, reach us through \
        the "Submit app developer feedback" option in Settings, or by email at \
        robsurrette@gmail.com.

        ## Changes to this policy
        We may update this policy from time to time. Material changes will be \
        reflected by the effective date above.
        """
    )

    static let terms = LegalDocument(
        id: "terms",
        title: "Terms of Use",
        effectiveDate: effective,
        body: """
        These Terms of Use ("Terms") govern your use of \(appName) (the "App"), \
        provided by \(provider). By downloading or using the App you agree to \
        these Terms. The App is also subject to Apple's standard Licensed \
        Application End User License Agreement (EULA), available at \
        https://www.apple.com/legal/internet-services/itunes/dev/stdeula/; where \
        these Terms add to it, both apply.

        ## License
        We grant you a personal, non-exclusive, non-transferable license to use \
        the App on Apple devices you own or control, for your personal, \
        non-commercial use, in accordance with the Apple EULA.

        ## Schedule information disclaimer
        \(appName) is an independent app. It is not affiliated with, endorsed \
        by, or sponsored by the Port Authority Transit Corporation (PATCO) or \
        the Delaware River Port Authority (DRPA). Schedule, fare, and service \
        information is provided for convenience only and may be incomplete, \
        delayed, or inaccurate. Always confirm times and service with official \
        PATCO sources before you travel. We are not responsible for missed \
        trains or connections.

        ## In-app purchase
        The App offers a one-time, non-consumable "Remove Ads" purchase. Once \
        purchased, it can be restored on your devices that use the same Apple \
        Account at no additional charge. Payments are handled by Apple and are \
        subject to Apple's terms. Refunds, if any, are handled by Apple \
        according to its policies.

        ## Acceptable use
        You agree not to misuse the App, including attempting to interfere with \
        its normal operation, reverse engineer it except as permitted by law, \
        or use it in violation of any applicable law.

        ## No warranty
        The App is provided "as is" and "as available," without warranties of \
        any kind, whether express or implied, including fitness for a particular \
        purpose and accuracy of information, to the fullest extent permitted by \
        law.

        ## Limitation of liability
        To the fullest extent permitted by law, \(provider) will not be liable \
        for any indirect, incidental, or consequential damages arising out of \
        your use of, or inability to use, the App.

        ## Governing law
        These Terms are governed by the laws of the State of \
        New Jersey, without regard to its conflict-of-laws rules.

        ## Contact
        Questions about these Terms? Reach us through the "Submit app developer \
        feedback" option in Settings, or by email at robsurrette@gmail.com.
        """
    )
}
