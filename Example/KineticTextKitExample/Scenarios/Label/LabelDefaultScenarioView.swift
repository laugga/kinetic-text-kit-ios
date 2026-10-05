//
//  LabelDefaultScenarioView.swift
//  KineticTextKit
//

import SwiftUI
import KineticTextKit

/// `LAULabel` as it comes: the SwiftUI wrapper, given a text, a font and a
/// colour, and a frame to sit in. The border is the frame SwiftUI gave it.
///
/// The text sits centred on the frame's top edge rather than inside it. That
/// is the component, not the scenario: `LAULabel` never gives its text layer a
/// frame, so the layer lays the text out against a height of zero, and nothing
/// public reaches the layer to do it instead. The space above the frame is only
/// there so the text does not run into the note.
struct LabelDefaultScenarioView: View {

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("LAULabel(text:font:textColor:) in a 120 pt high frame, outlined. The text sits on the frame's top edge: LAULabel never sizes its text layer.")
                .font(.footnote)
                .foregroundStyle(.secondary)

            LAULabel(text: "2.8", font: .systemFont(ofSize: 48, weight: .semibold), textColor: .primary)
                .frame(height: 120)
                .border(Color(uiColor: .separator))
                .padding(.top, 32)

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
    }
}

#if DEBUG
#Preview("Default") {
    LabelDefaultScenarioView()
}
#endif
