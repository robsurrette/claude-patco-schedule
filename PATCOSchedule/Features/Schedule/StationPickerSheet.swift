import SwiftUI

/// Modal sheet for selecting a station for one end of the route.
/// Matches the design reference: custom header, search field, favorites
/// section, and all-stations section with radio dots and star toggles.
struct StationPickerSheet: View {
    let end: RouteEnd
    @Environment(AppState.self) private var appState
    @Environment(FavoritesStore.self) private var favorites
    @Environment(\.dismiss) private var dismiss

    @State private var query = ""

    private var selected: Station {
        end == .origin ? appState.origin : appState.destination
    }

    private var isSearching: Bool {
        !query.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private var filteredStations: [Station] {
        let q = query.trimmingCharacters(in: .whitespaces).lowercased()
        guard !q.isEmpty else { return Station.all }
        return Station.all.filter { $0.name.lowercased().contains(q) }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(alignment: .center) {
                Text(end == .origin ? "Origin station" : "Destination station")
                    .font(PTFont.bold(23))
                    .tracking(-0.3)
                    .foregroundStyle(PTColor.ink)
                Spacer(minLength: 8)
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(PTColor.ink2)
                        .frame(width: 38, height: 38)
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.circle)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 12)

            // Search field
            HStack(spacing: 9) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 15))
                    .foregroundStyle(PTColor.ink3)
                TextField("Search stations", text: $query)
                    .font(PTFont.book(16))
                    .foregroundStyle(PTColor.ink)
                    .tint(PTColor.red)
                if !query.isEmpty {
                    Button { query = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(PTColor.ink3)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 11)
            .background(PTColor.card)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: .black.opacity(0.04), radius: 1, x: 0, y: 1)
            .padding(.horizontal, 16)
            .padding(.bottom, 12)

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Favorites section — hidden while searching
                    let favStations = favorites.favoriteStations
                    if !isSearching && !favStations.isEmpty {
                        SectionHeader(title: "Favorites")
                            .padding(.horizontal, 4)
                            .padding(.bottom, 8)
                        stationCard(stations: favStations, inFavSection: true)
                            .padding(.bottom, 18)
                    }

                    // All stations / Results section
                    SectionHeader(title: isSearching ? "Results" : "All stations")
                        .padding(.horizontal, 4)
                        .padding(.bottom, 8)

                    if filteredStations.isEmpty {
                        PTCard(padding: 16) {
                            Text("No stations match \"\(query)\".")
                                .font(PTFont.book(15))
                                .foregroundStyle(PTColor.ink3)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    } else {
                        stationCard(stations: filteredStations, inFavSection: false)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .background(PTColor.bg)
        .presentationBackground(PTColor.bg)
    }

    private func stationCard(stations: [Station], inFavSection: Bool) -> some View {
        PTCard(padding: 0) {
            VStack(spacing: 0) {
                ForEach(Array(stations.enumerated()), id: \.element.id) { idx, station in
                    StationPickerRow(
                        station: station,
                        isSelected: station == selected,
                        isFavorite: favorites.isFavorite(station),
                        inFavSection: inFavSection,
                        showHairline: idx < stations.count - 1,
                        onSelect: {
                            appState.select(station, for: end)
                            dismiss()
                        },
                        onToggleFav: { favorites.toggle(station) }
                    )
                }
            }
        }
    }
}

// MARK: - Row

private struct StationPickerRow: View {
    let station: Station
    let isSelected: Bool
    let isFavorite: Bool
    let inFavSection: Bool
    let showHairline: Bool
    let onSelect: () -> Void
    let onToggleFav: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            HStack(spacing: 0) {
                // Selectable region: radio dot + name + optional checkmark
                Button(action: onSelect) {
                    HStack(spacing: 13) {
                        ZStack {
                            Circle()
                                .fill(isSelected ? PTColor.red : .clear)
                            Circle()
                                .strokeBorder(
                                    isSelected ? PTColor.red : PTColor.ink3,
                                    lineWidth: 2.5
                                )
                        }
                        .frame(width: 12, height: 12)

                        Text(station.name)
                            .font(isSelected ? PTFont.bold(17) : PTFont.book(17))
                            .foregroundStyle(PTColor.ink)

                        Spacer()

                        if isSelected {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(PTColor.red)
                                .padding(.trailing, 4)
                        }
                    }
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, minHeight: 54)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                // Star toggle — always filled in the favorites section
                Button(action: onToggleFav) {
                    let filled = inFavSection || isFavorite
                    Image(systemName: filled ? "star.fill" : "star")
                        .font(.system(size: 16.5))
                        .foregroundStyle(filled ? PTColor.red : PTColor.ink3)
                        .frame(width: 50, height: 54)
                }
                .buttonStyle(.plain)
            }
            .background(isSelected ? PTColor.redSoft : PTColor.card)

            if showHairline {
                Hairline(inset: 41)
            }
        }
    }
}

#Preview {
    StationPickerSheet(end: .origin)
        .environment(AppState())
        .environment(FavoritesStore())
}
