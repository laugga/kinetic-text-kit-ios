//
//  TextViewTextAndColourScenarioViewController.swift
//  KineticTextKit
//

import UIKit
import KineticTextKit

/// `text` and `textColor`, the two plain properties of `KineticTextLayer`.
/// Setting either one redraws the layer; neither goes through `setFont`.
final class TextViewTextAndColourScenarioViewController: ScenarioViewController {

    private let stage = TextViewStage()

    private let colours: [(name: String, colour: UIColor)] = [
        ("Black", .black),
        ("Red", .systemRed),
        ("Blue", .systemBlue),
        ("Orange", .systemOrange)
    ]

    private lazy var colourControl = UISegmentedControl(items: colours.map(\.name))

    override func viewDidLoad() {
        super.viewDidLoad()

        addNote("The buttons set text; the segments set textColor.")

        let textLayer = stage.textView.textLayer
        textLayer.text = "2.8"
        textLayer.font = .systemFont(ofSize: 48, weight: .semibold)
        textLayer.textColor = colours[0].colour

        add(stage, height: 120)

        add(makeButtonRow(["1.4", "2.8", "16", "f/22"].map { text in
            makeButton(title: text) { [weak self] in
                self?.stage.textView.textLayer.text = text
            }
        }))

        colourControl.selectedSegmentIndex = 0
        colourControl.addTarget(self, action: #selector(colourControlDidChange), for: .valueChanged)
        add(colourControl)
    }

    @objc private func colourControlDidChange() {
        stage.textView.textLayer.textColor = colours[colourControl.selectedSegmentIndex].colour
    }
}

#if DEBUG
#Preview("Text and Colour") {
    TextViewTextAndColourScenarioViewController()
}
#endif
