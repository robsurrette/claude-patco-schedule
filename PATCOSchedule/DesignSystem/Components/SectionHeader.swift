import SwiftUI

/// An uppercase overline section header (e.g. "LATER TODAY", "APPEARANCE").
struct SectionHeader: View {
    let title: String
    /// Optional leading dot color (e.g. the red "● UP NEXT" pulsing dot is a
    /// separate `PulsingDot`; this is for static colored dots).
    var dotColor: Color? = nil

    var body: some View {
        HStack(spacing: 6) {
            if let dotColor {
                Circle().fill(dotColor).frame(width: 6, height: 6)
            }
            Text(title.uppercased())
                .ptStyle(PTFont.overline)
                .foregroundStyle(PTColor.ink2)
        }
    }
}

/// A 0.5pt hairline divider, inset from the leading edge to align under row
/// text (matching the handoff's inset dividers).
struct Hairline: View {
    var inset: CGFloat = PTSpacing.hairlineInset
    var bold: Bool = false

    var body: some View {
        Rectangle()
            .fill(bold ? PTColor.hairBold : PTColor.hair)
            .frame(height: 0.5)
            .padding(.leading, inset)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 12) {
        SectionHeader(title: "Later today")
        SectionHeader(title: "Up next", dotColor: PTColor.red)
        Hairline()
    }
    .padding()
    .background(PTColor.bg)
}
