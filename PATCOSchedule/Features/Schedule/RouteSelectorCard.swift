import SwiftUI

/// The route selector in the Schedule header: tappable origin and destination
/// rows separated by a hairline, with a swap button on the trailing edge.
struct RouteSelectorCard: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        HStack(spacing: 0) {
            RouteEndpointIndicator()
                .padding(.leading, 14)
                .padding(.trailing, 12)

            VStack(spacing: 0) {
                stationButton(appState.origin.name) {
                    appState.activeSheet = .stationPicker(.origin)
                }
                Hairline(inset: 0)
                stationButton(appState.destination.name) {
                    appState.activeSheet = .stationPicker(.destination)
                }
            }
            .frame(maxWidth: .infinity)

            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                    appState.swapRoute()
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(PTColor.ink)
                    .frame(width: 42, height: 42)
                    .background(PTColor.fill)
                    .clipShape(RoundedRectangle(cornerRadius: PTRadius.tile, style: .continuous))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 8)
        }
        .background(PTColor.card)
        .clipShape(RoundedRectangle(cornerRadius: PTRadius.card, style: .continuous))
        .ptShadow(.card)
    }

    private func stationButton(_ name: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(name)
                .ptStyle(PTFont.rowLabel)
                .foregroundStyle(PTColor.ink)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 13)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    RouteSelectorCard()
        .padding()
        .background(PTColor.bg)
        .environment(AppState())
}
