import SwiftUI

/// Patco Info tab — PATCO's contact channels surfaced as quick-action tiles,
/// with reference links grouped into inset cards. Mirrors `flow-info.jsx`
/// (Direction A). External links open in the system browser; the URLs are
/// carried over from the original app.
struct InfoView: View {
    @Environment(\.openURL) private var openURL

    @State private var showMail = false

    /// PATCO customer-service line (digits used for the `tel://` link).
    private static let phoneDigits = "8567726900"
    private static let phoneDisplay = "(856) 772-6900"
    /// Contact mailbox (matches the address used on the Settings tab).
    private static let contactEmail = "patco@ridepatco.com"

    var body: some View {
        ScreenScaffold(title: "Patco Info") {
            contactCard

            SectionHeader(title: "Fares & cards").padding(.top, 8)
            faresCard

            SectionHeader(title: "Station accessibility").padding(.top, 8)
            accessibilityCard

            SectionHeader(title: "Connecting transit").padding(.top, 8)
            transitCard
        }
        .sheet(isPresented: $showMail) {
            MailComposeView(recipient: Self.contactEmail, subject: "PATCO Inquiry")
                .ignoresSafeArea()
        }
    }

    // MARK: - Contact PATCO (quick actions)

    private var contactCard: some View {
        PTCard(radius: PTRadius.cardLarge, padding: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Contact PATCO")
                    .font(PTFont.bold(13))
                    .foregroundStyle(PTColor.ink)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 14)

                HStack(spacing: 8) {
                    quickAction(label: "Call", tile: PTColor.green, action: call) {
                        Image(systemName: "phone.fill").font(.system(size: 21))
                    }
                    quickAction(label: "Email", tile: PTColor.Brand.email, action: email) {
                        Image(systemName: "envelope.fill").font(.system(size: 20))
                    }
                    quickAction(label: "Website", tile: PTColor.ink, iconColor: PTColor.card) {
                        open("http://www.ridepatco.org")
                    } icon: {
                        Image(systemName: "globe").font(.system(size: 21))
                    }
                    quickAction(label: "X", tile: PTColor.Brand.x) {
                        open("https://twitter.com/RidePATCO")
                    } icon: {
                        XLogo(color: PTColor.card).frame(width: 19, height: 19)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 14)

                Hairline(inset: 0)

                HStack {
                    Text("Customer service")
                        .font(PTFont.book(13.5))
                        .foregroundStyle(PTColor.ink2)
                    Spacer(minLength: 8)
                    Text(Self.phoneDisplay)
                        .font(PTFont.bold(13.5))
                        .monospacedDigit()
                        .foregroundStyle(PTColor.ink)
                }
                .padding(.horizontal, 16)
                .frame(minHeight: 44)
            }
        }
    }

    private func quickAction<Icon: View>(
        label: String,
        tile: Color,
        iconColor: Color = .white,
        action: @escaping () -> Void,
        @ViewBuilder icon: () -> Icon
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 7) {
                icon()
                    .foregroundStyle(iconColor)
                    .frame(width: 54, height: 54)
                    .background(tile, in: RoundedRectangle(cornerRadius: PTRadius.tileLarge, style: .continuous))
                Text(label)
                    .font(PTFont.medium(13))
                    .foregroundStyle(PTColor.ink2)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Fares & cards

    private var faresCard: some View {
        PTCard(padding: 0) {
            VStack(spacing: 0) {
                infoRow(
                    label: "Fares",
                    sub: "Single ride, FREEDOM & more",
                    icon: { tile(bg: PTColor.redSoft) { glyph("ticket.fill", color: PTColor.red) } },
                    action: { open("http://www.ridepatco.org/schedules/fares.html") }
                )
                Hairline(inset: 61)
                infoRow(
                    label: "Reload FREEDOM Card",
                    sub: "Add rides to your account",
                    icon: { tile(bg: PTColor.redSoft) { glyph("creditcard.fill", color: PTColor.red) } },
                    action: { open("http://www.patcofreedomcard.org/front/account/login.jsp?path=/front/add_ride/index.jsp") }
                )
            }
        }
    }

    // MARK: - Station accessibility

    private var accessibilityCard: some View {
        PTCard(padding: 0) {
            VStack(spacing: 0) {
                infoRow(
                    label: "Current availability",
                    sub: "Elevators & escalators status",
                    icon: { tile(bg: PTColor.Brand.accessibilityBG) { glyph("figure.roll", color: PTColor.Brand.accessibilityIcon) } },
                    action: { open("http://www.ridepatco.org/schedules/alerts_more.asp?page=25") }
                )
                Hairline(inset: 61)
                infoRow(
                    label: "Parking, elevators & bikes",
                    sub: "Facilities at every station",
                    icon: { tile(bg: PTColor.Brand.accessibilityBG) { glyph("parkingsign", color: PTColor.Brand.accessibilityIcon) } },
                    action: { open("http://www.ridepatco.org/travel/access.html") }
                )
            }
        }
    }

    // MARK: - Connecting transit

    private var transitCard: some View {
        PTCard(padding: 0) {
            VStack(spacing: 0) {
                infoRow(
                    label: "SEPTA",
                    icon: { transitLogo("septa") },
                    action: { open("http://www.septa.org/m/") }
                )
                Hairline(inset: 61)
                infoRow(
                    label: "River Line",
                    icon: { transitLogo("riverline") },
                    action: { open("https://www.njtransit.com/light-rail-to") }
                )
                Hairline(inset: 61)
                infoRow(
                    label: "NJ Transit",
                    icon: { transitLogo("njtransit") },
                    action: { open("https://www.njtransit.com") }
                )
                Hairline(inset: 61)
                infoRow(
                    label: "Amtrak",
                    icon: { transitLogo("amtrak") },
                    action: { open("https://www.amtrak.com") }
                )
            }
        }
    }

    // MARK: - Row + icon helpers

    private func infoRow<Icon: View>(
        label: String,
        sub: String? = nil,
        @ViewBuilder icon: () -> Icon,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 13) {
                icon()
                VStack(alignment: .leading, spacing: 1) {
                    Text(label)
                        .font(PTFont.medium(16.5))
                        .foregroundStyle(PTColor.ink)
                    if let sub {
                        Text(sub)
                            .font(PTFont.book(12.5))
                            .foregroundStyle(PTColor.ink2)
                    }
                }
                Spacer(minLength: 8)
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(PTColor.ink3)
            }
            .padding(.horizontal, 16)
            .frame(minHeight: 56)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func tile<Icon: View>(bg: Color, @ViewBuilder icon: () -> Icon) -> some View {
        icon()
            .frame(width: 32, height: 32)
            .background(bg, in: RoundedRectangle(cornerRadius: 9, style: .continuous))
    }

    private func glyph(_ systemName: String, color: Color) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 15))
            .foregroundStyle(color)
    }

    /// A connecting-agency logo, sized to the same 32pt slot as the other row
    /// icons. The asset is a square logo with its own padding (and ships a
    /// dark-mode variant where needed), so it renders on the card unframed.
    private func transitLogo(_ name: String) -> some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .frame(width: 32, height: 32)
    }

    // MARK: - Actions

    private func call() {
        if let url = URL(string: "tel://\(Self.phoneDigits)") { openURL(url) }
    }

    private func email() {
        if MailComposeView.canSendMail {
            showMail = true
        } else if let url = URL(string: "mailto:\(Self.contactEmail)?subject=PATCO%20Inquiry") {
            openURL(url)
        }
    }

    private func open(_ string: String) {
        if let url = URL(string: string) { openURL(url) }
    }
}

// MARK: - X logo

/// The X (formerly Twitter) wordmark, recreated from the handoff's inline SVG
/// path (SF Symbols has no X glyph). Drawn in a 24×24 unit space with an
/// even-odd fill so the counter inside the strokes stays open.
private struct XLogo: View {
    var color: Color = .white

    var body: some View {
        Canvas { context, size in
            let s = min(size.width, size.height) / 24
            func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * s, y: y * s) }

            var path = Path()
            // Outer wordmark.
            path.move(to: p(17.5, 3))
            path.addLine(to: p(20.5, 3))
            path.addLine(to: p(13.5, 11))
            path.addLine(to: p(21.7, 21))
            path.addLine(to: p(15.3, 21))
            path.addLine(to: p(10.3, 14.8))
            path.addLine(to: p(8, 21))
            path.addLine(to: p(5, 21))
            path.addLine(to: p(12.4, 12.5))
            path.addLine(to: p(4.5, 3))
            path.addLine(to: p(11.1, 3))
            path.addLine(to: p(15.6, 8.7))
            path.addLine(to: p(17.5, 3))
            path.closeSubpath()
            // Inner counter.
            path.move(to: p(16.4, 19))
            path.addLine(to: p(18.1, 19))
            path.addLine(to: p(8, 4.6))
            path.addLine(to: p(6.2, 4.6))
            path.addLine(to: p(16.4, 19))
            path.closeSubpath()

            context.fill(path, with: .color(color), style: FillStyle(eoFill: true))
        }
    }
}

#Preview { InfoView() }
