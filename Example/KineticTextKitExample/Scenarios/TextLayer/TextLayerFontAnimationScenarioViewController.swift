//
//  TextLayerFontAnimationScenarioViewController.swift
//  KineticTextKit
//

import UIKit
import KineticTextKit

/// `setFont(_:animated:)` on the bare layer — the morph belongs to
/// `KineticTextLayer` itself, not to any of the views built on it.
///
/// With `animated` off the call is the same as assigning `font`: the path is
/// replaced and the text jumps. With it on, the old path is animated into the
/// new one.
final class TextLayerFontAnimationScenarioViewController: ScenarioViewController {

    private let canvas = LayoutReportingView()

    private let textLayer = KineticTextLayer()

    private let weights: [(name: String, weight: UIFont.Weight)] = [
        ("Ultralight", .ultraLight),
        ("Regular", .regular),
        ("Bold", .bold)
    ]

    private lazy var weightControl = UISegmentedControl(items: weights.map(\.name))

    private let animatedSwitch = UISwitch()

    override func viewDidLoad() {
        super.viewDidLoad()

        addNote("Pick a weight to call setFont(_:animated:). The layer keeps the frame it was given — it does not grow to fit a heavier font, and nothing here resizes it.")

        canvas.layer.borderWidth = 1
        canvas.layer.borderColor = UIColor.separator.cgColor
        canvas.layer.addSublayer(textLayer)
        canvas.didLayout = { [weak self] in
            self?.layOutTextLayer()
        }

        add(canvas, height: 160)

        weightControl.selectedSegmentIndex = 1
        weightControl.addTarget(self, action: #selector(weightControlDidChange), for: .valueChanged)

        // `setFont(_:animated:)` animates from the path the layer already has,
        // so it needs a text and a font before the first call.
        textLayer.font = font
        textLayer.textColor = .label
        textLayer.text = "2.8"

        add(weightControl)

        animatedSwitch.isOn = true

        let animatedLabel = makeValueLabel("Animated")
        animatedLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        let animatedRow = UIStackView(arrangedSubviews: [animatedLabel, animatedSwitch])
        animatedRow.axis = .horizontal
        animatedRow.spacing = 12
        animatedRow.alignment = .center
        add(animatedRow)
    }

    /// The same frame work as the other scenarios in this section: the layer
    /// does not resize with the canvas, and the path is only laid out again
    /// when the content is set again.
    private func layOutTextLayer() {
        guard textLayer.frame != canvas.bounds else {
            return
        }

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        textLayer.frame = canvas.bounds
        textLayer.contentMode = textLayer.contentMode
        CATransaction.commit()
    }

    private var font: UIFont {
        return .systemFont(ofSize: 56,
                           weight: weights[weightControl.selectedSegmentIndex].weight)
    }

    @objc private func weightControlDidChange() {
        textLayer.setFont(font, animated: animatedSwitch.isOn)
    }
}

#if DEBUG
#Preview("Font Animation") {
    TextLayerFontAnimationScenarioViewController()
}
#endif
