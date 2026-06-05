import SwiftUI

/// "App icon" picker — a grouped grid of the alternate PATCO icons. Selecting one
/// calls `AppState.applyAppIcon`, which swaps the home-screen icon. Mirrors
/// `flow-appicon.jsx`.
struct AppIconPickerSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(AppIconOption.Group.allCases) { group in
                        SectionHeader(title: group.rawValue)
                            .padding(.top, 16)
                            .padding(.bottom, 14)
                            .padding(.horizontal, 4)
                        LazyVGrid(columns: columns, spacing: 18) {
                            ForEach(options(in: group)) { option in
                                tile(option)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 28)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(PTColor.bg)
        .presentationDetents([.large])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(PTRadius.sheet)
    }

    private func options(in group: AppIconOption.Group) -> [AppIconOption] {
        AppIconOption.all.filter { $0.group == group }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Text("App icon")
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

    // MARK: - Tile

    private func tile(_ option: AppIconOption) -> some View {
        let isOn = appState.currentAppIcon.id == option.id
        return Button {
            Task { await appState.applyAppIcon(option) }
        } label: {
            VStack(spacing: 8) {
                ZStack(alignment: .bottomTrailing) {
                    Image(option.assetName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 72, height: 72)
                        .clipShape(RoundedRectangle(cornerRadius: 17, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 17, style: .continuous)
                                .strokeBorder(PTColor.hairBold, lineWidth: 0.5)
                        )
                        .padding(3)
                        .background(
                            RoundedRectangle(cornerRadius: 21, style: .continuous)
                                .fill(isOn ? PTColor.red : .clear)
                        )

                    if isOn {
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 24, height: 24)
                            .background(Circle().fill(PTColor.red))
                            .overlay(Circle().strokeBorder(PTColor.bg, lineWidth: 2.5))
                            .offset(x: 2, y: 2)
                    }
                }
                Text(option.displayName)
                    .font(isOn ? PTFont.bold(13.5) : PTFont.medium(13.5))
                    .foregroundStyle(isOn ? PTColor.ink : PTColor.ink2)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            AppIconPickerSheet()
                .environment(AppState())
        }
}
