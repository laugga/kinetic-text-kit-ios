//
//  LabelStateScenarioView.swift
//  KineticTextKit
//

import SwiftUI
import KineticTextKit

/// `LAULabel` driven by SwiftUI state, which is how a SwiftUI consumer changes
/// it: every change builds the label again with new values, and SwiftUI hands
/// them to the existing view through `updateUIView`.
struct LabelStateScenarioView: View {

    @State private var text = "2.8"

    @State private var isBold = false

    @State private var colourName = "Black"

    private let texts = ["1.4", "2.8", "16", "f/22"]

    private let colours: [(name: String, colour: Color)] = [
        ("Black", .black),
        ("Red", .red),
        ("Blue", .blue)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Text, weight and colour are @State; the label is rebuilt from them on every change. The text sits on the frame's top edge: LAULabel never sizes its text layer.")
                .font(.footnote)
                .foregroundStyle(.secondary)

            LAULabel(text: text,
                     font: .systemFont(ofSize: 48, weight: isBold ? .bold : .regular),
                     textColor: colours.first { $0.name == colourName }?.colour ?? .black)
                .frame(height: 120)
                .border(Color(uiColor: .separator))
                .padding(.top, 32)

            Picker("Text", selection: $text) {
                ForEach(texts, id: \.self) { Text($0) }
            }
            .pickerStyle(.segmented)

            Picker("Colour", selection: $colourName) {
                ForEach(colours, id: \.name) { Text($0.name) }
            }
            .pickerStyle(.segmented)

            Toggle("Bold", isOn: $isBold)

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
    }
}

#if DEBUG
#Preview("State Updates") {
    LabelStateScenarioView()
}
#endif
