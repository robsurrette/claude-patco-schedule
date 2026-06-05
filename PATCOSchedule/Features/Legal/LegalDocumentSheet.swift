import SwiftUI

/// Renders a `LegalDocument` (Privacy Policy / Terms of Use) as a scrollable
/// sheet. Understands the document's tiny markup: `## ` headings, `- ` bullets,
/// and blank-line paragraph breaks.
struct LegalDocumentSheet: View {
    let document: LegalDocument
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView(showsIndicators: true) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Effective \(document.effectiveDate)")
                        .font(PTFont.book(13))
                        .foregroundStyle(PTColor.ink3)
                        .padding(.bottom, 16)
                    ForEach(Array(blocks.enumerated()), id: \.offset) { _, block in
                        block.view
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 28)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(PTColor.bg)
        .presentationDetents([.large])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(PTRadius.sheet)
    }

    private var header: some View {
        HStack {
            Text(document.title)
                .font(PTFont.bold(23))
                .tracking(-0.3)
                .foregroundStyle(PTColor.ink)
            Spacer(minLength: 8)
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(PTColor.ink2)
                    .frame(width: 38, height: 38)
                    .background(Circle().fill(PTColor.fill2))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 12)
    }

    // MARK: - Markup parsing

    private enum Block {
        case heading(String)
        case bullet(String)
        case paragraph(String)

        @ViewBuilder var view: some View {
            switch self {
            case .heading(let text):
                Text(text)
                    .font(PTFont.bold(16))
                    .foregroundStyle(PTColor.ink)
                    .padding(.top, 18)
                    .padding(.bottom, 7)
            case .bullet(let text):
                HStack(alignment: .top, spacing: 8) {
                    Text("•").foregroundStyle(PTColor.ink3)
                    Text(text)
                        .font(PTFont.book(15))
                        .foregroundStyle(PTColor.ink2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.bottom, 4)
            case .paragraph(let text):
                Text(text)
                    .font(PTFont.book(15))
                    .foregroundStyle(PTColor.ink2)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 10)
            }
        }
    }

    private var blocks: [Block] {
        document.body
            .components(separatedBy: "\n")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .map { line in
                if line.hasPrefix("## ") {
                    return .heading(String(line.dropFirst(3)))
                } else if line.hasPrefix("- ") {
                    return .bullet(String(line.dropFirst(2)))
                } else {
                    return .paragraph(line)
                }
            }
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            LegalDocumentSheet(document: .privacy)
        }
}
