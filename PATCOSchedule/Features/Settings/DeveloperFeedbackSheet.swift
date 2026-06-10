import SwiftUI

/// "Submit app developer feedback" — a small form (optional name/email, required
/// message) that POSTs to the AWS feedback endpoint via `FeedbackService`.
struct DeveloperFeedbackSheet: View {
    @Environment(\.services) private var services
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    @State private var phase: Phase = .form
    @State private var errorMessage: String?
    @State private var showError = false
    @FocusState private var focused: Field?

    private enum Phase { case form, submitting, success }
    private enum Field { case name, email, message }

    private var trimmedMessage: String {
        message.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canSubmit: Bool {
        !trimmedMessage.isEmpty && phase != .submitting
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            if phase == .success {
                successState
            } else {
                form
                submitFooter
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(PTColor.bg)
        .presentationDetents([.large])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(PTRadius.sheet)
        .alert("Couldn't send feedback", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage ?? "Please try again.")
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Text("Send feedback")
                .font(PTFont.bold(23))
                .tracking(-0.3)
                .foregroundStyle(PTColor.ink)
            Spacer(minLength: 8)
            if #available(iOS 26.0, *) {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(PTColor.ink2)
                        .frame(width: 28, height: 28)
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.circle)
            } else {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(PTColor.ink2)
                        .frame(width: 28, height: 28)
                }
                .buttonBorderShape(.circle)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 12)
    }

    // MARK: - Form

    private var form: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Have an idea, bug, or request? Send it straight to the developer. Your name and email are optional — add them if you'd like a reply.")
                    .font(PTFont.book(14))
                    .foregroundStyle(PTColor.ink2)
                    .fixedSize(horizontal: false, vertical: true)

                field(label: "Name", optional: true) {
                    TextField("Your name", text: $name)
                        .textContentType(.name)
                        .focused($focused, equals: .name)
                        .submitLabel(.next)
                        .onSubmit { focused = .email }
                }

                field(label: "Email", optional: true) {
                    TextField("Your email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .focused($focused, equals: .email)
                        .submitLabel(.next)
                        .onSubmit { focused = .message }
                }

                field(label: "Message", optional: false) {
                    TextField("What's on your mind?", text: $message, axis: .vertical)
                        .lineLimit(4...10)
                        .focused($focused, equals: .message)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 4)
            .padding(.bottom, 20)
        }
    }

    private func field<Content: View>(
        label: String,
        optional: Bool,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(spacing: 5) {
                Text(label.uppercased())
                    .ptStyle(PTFont.overline)
                    .foregroundStyle(PTColor.ink2)
                if optional {
                    Text("Optional")
                        .font(PTFont.book(11))
                        .foregroundStyle(PTColor.ink3)
                } else {
                    Text("Required")
                        .font(PTFont.book(11))
                        .foregroundStyle(PTColor.red)
                }
            }
            content()
                .font(PTFont.book(16))
                .foregroundStyle(PTColor.ink)
                .tint(PTColor.red)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(PTColor.card)
                )
        }
    }

    // MARK: - Submit footer

    private var submitFooter: some View {
        VStack(spacing: 0) {
            Button(action: submit) {
                ZStack {
                    Text("Submit feedback")
                        .font(PTFont.bold(17))
                        .foregroundStyle(.white)
                        .opacity(phase == .submitting ? 0 : 1)
                    if phase == .submitting {
                        ProgressView().tint(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(canSubmit ? PTColor.red : PTColor.red.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            }
            .buttonStyle(.plain)
            .disabled(!canSubmit)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 26)
        .background(
            PTColor.bg.opacity(0.9)
                .background(.ultraThinMaterial)
        )
        .overlay(alignment: .top) { Hairline(inset: 0) }
    }

    // MARK: - Success

    private var successState: some View {
        VStack(spacing: 14) {
            Spacer()
            Image(systemName: "checkmark")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(PTColor.green)
                .frame(width: 76, height: 76)
                .background(Circle().fill(PTColor.greenSoft))
            Text("Thanks for your feedback!")
                .font(PTFont.bold(20))
                .foregroundStyle(PTColor.ink)
            Text("We read every message and use it to make PATCO Schedule better.")
                .font(PTFont.book(14.5))
                .foregroundStyle(PTColor.ink2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 300)
            Spacer()
            Button { dismiss() } label: {
                Text("Done")
                    .font(PTFont.bold(17))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(PTColor.red)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 20)
            .padding(.bottom, 26)
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Actions

    private func submit() {
        focused = nil
        phase = .submitting
        Task {
            do {
                try await services.feedback.submit(
                    name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                    email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                    message: trimmedMessage
                )
                phase = .success
            } catch {
                errorMessage = (error as? LocalizedError)?.errorDescription
                    ?? error.localizedDescription
                showError = true
                phase = .form
            }
        }
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            DeveloperFeedbackSheet()
                .environment(\.services, .live)
        }
}
