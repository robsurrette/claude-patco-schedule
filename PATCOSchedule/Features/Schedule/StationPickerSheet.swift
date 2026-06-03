import SwiftUI

/// Modal sheet for selecting a station for one end of the route.
struct StationPickerSheet: View {
    let end: RouteEnd
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    private var selected: Station {
        end == .origin ? appState.origin : appState.destination
    }

    var body: some View {
        NavigationStack {
            List(Station.all) { station in
                Button {
                    appState.select(station, for: end)
                    dismiss()
                } label: {
                    HStack {
                        Text(station.name)
                            .font(PTFont.medium(17))
                            .foregroundStyle(PTColor.ink)
                        Spacer()
                        if station == selected {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(PTColor.red)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .listRowBackground(PTColor.card)
            }
            .scrollContentBackground(.hidden)
            .background(PTColor.bg)
            .navigationTitle(end == .origin ? "Origin" : "Destination")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    StationPickerSheet(end: .origin)
        .environment(AppState())
}
