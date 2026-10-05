//
//  LabelFontAnimationScenarioView.swift
//  KineticTextKit
//

import SwiftUI
import KineticTextKit

/// `LAULabel.setFont(font:animated:)`, the animated font change from SwiftUI.
///
/// The label is kept as a property rather than rebuilt in `body`, because
/// `setFont` talks to the view the label made — a label built afresh on each
/// pass would have made a different one. For the same reason nothing here is
/// state: a pass through `body` would hand the label's original font back to
/// the view.
struct LabelFontAnimationScenarioView: View {

    private let label = LAULabel(text: "2.8", font: .systemFont(ofSize: 48, weight: .regular), textColor: .primary)

    private let weights: [(name: String, weight: UIFont.Weight)] = [
        ("Ultralight", .ultraLight),
        ("Regular", .regular),
        ("Bold", .bold)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Each button calls setFont(font:animated: true) on the label. The text sits on the frame's top edge: LAULabel never sizes its text layer.")
                .font(.footnote)
                .foregroundStyle(.secondary)

            label
                .frame(height: 120)
                .border(Color(uiColor: .separator))
                .padding(.top, 32)

            HStack(spacing: 12) {
                ForEach(weights, id: \.name) { weight in
                    Button(weight.name) {
                        label.setFont(font: .systemFont(ofSize: 48, weight: weight.weight), animated: true)
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
                }
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
    }
}

#if DEBUG
#Preview("Font Animation") {
    LabelFontAnimationScenarioView()
}
#endif
