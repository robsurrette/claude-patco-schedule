import SwiftUI

/// Patco Info tab — placeholder scaffold.
struct InfoView: View {
    var body: some View {
        ScreenScaffold(title: "Patco Info") {
            ComingSoonNote(screen: "Contact tiles, fares, accessibility, and connecting transit")
        }
    }
}

#Preview { InfoView() }
