import SwiftUI

/// Prev/next day chevrons flanking a date button that opens a graphical date
/// picker popover.
struct DayStepper: View {
    @Environment(AppState.self) private var appState

    private var dayLabel: String {
        let cal = Calendar.current
        if cal.isDateInToday(appState.selectedDate) { return "Today" }
        if cal.isDateInYesterday(appState.selectedDate) { return "Yesterday" }
        if cal.isDateInTomorrow(appState.selectedDate) { return "Tomorrow" }
        return appState.selectedDate.formatted(.dateTime.weekday(.wide))
    }

    private var dateLabel: String {
        appState.selectedDate.formatted(.dateTime.month(.abbreviated).day())
    }

    var body: some View {
        @Bindable var appState = appState
        let isOpen = appState.datePopoverOpen

        HStack(spacing: 8) {
            stepButton("chevron.left") { appState.stepDate(by: -1) }

            Button { appState.datePopoverOpen.toggle() } label: {
                HStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(isOpen ? PTColor.red : PTColor.ink2)
                    Text(dayLabel)
                        .font(PTFont.bold(15.5))
                        .foregroundStyle(isOpen ? PTColor.red : PTColor.ink)
                    Text(dateLabel)
                        .font(PTFont.book(14.5))
                        .foregroundStyle(isOpen ? PTColor.red : PTColor.ink2)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 11)
                .background(isOpen ? PTColor.redSoft : PTColor.card)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .shadow(
                    color: isOpen ? .clear : .black.opacity(0.04),
                    radius: 1, x: 0, y: 1
                )
            }
            .buttonStyle(.plain)
            .popover(isPresented: $appState.datePopoverOpen) {
                DatePicker(
                    "Select date",
                    selection: $appState.selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .labelsHidden()
                .padding(8)
                .frame(minWidth: 300)
                .presentationCompactAdaptation(.popover)
            }

            stepButton("chevron.right") { appState.stepDate(by: 1) }
        }
    }

    private func stepButton(_ symbol: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(PTColor.ink)
                .frame(width: 42, height: 42)
                .background(PTColor.card)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .ptShadow(.card)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    DayStepper()
        .padding()
        .background(PTColor.bg)
        .environment(AppState())
}
