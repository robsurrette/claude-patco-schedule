import SwiftUI

/// Small amber capsule marking a trip whose times come from a special
/// schedule and differ from the regular timetable.
struct AdjustedTag: View {
    var body: some View {
        Text("Adjusted")
            .font(PTFont.bold(10.5))
            .foregroundStyle(PTColor.alertTitle)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(Capsule().fill(PTColor.amberSoft))
    }
}

#Preview {
    AdjustedTag()
        .padding()
        .background(PTColor.bg)
}
