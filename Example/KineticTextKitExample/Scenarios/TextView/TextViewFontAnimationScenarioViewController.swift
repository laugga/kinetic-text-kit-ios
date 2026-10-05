//
//  TextViewFontAnimationScenarioViewController.swift
//  KineticTextKit
//

import UIKit
import KineticTextKit

/// The kinetic part of KineticTextKit: `setFont(_:animated:)`, which morphs the
/// text's path from the old font to the new one. The weight and the size are
/// the two things a font change moves, so each gets its own control.
final class TextViewFontAnimationScenarioViewController: ScenarioViewController {

    private let stage = TextViewStage()

    private let weights: [(name: String, weight: UIFont.Weight)] = [
        ("Ultralight", .ultraLight),
        ("Regular", .regular),
        ("Bold", .bold)
    ]

    private lazy var weightControl = UISegmentedControl(items: weights.map(\.name))

    private let sizeSlider = UISlider()

    private let animatedSwitch = UISwitch()

    override func viewDidLoad() {
        super.viewDidLoad()

        addNote("Change the weight or the size. Each change calls setFont(_:animated:), with animated taken from the switch.")

        weightControl.selectedSegmentIndex = 1
        weightControl.addTarget(self, action: #selector(fontControlDidChange), for: .valueChanged)

        sizeSlider.minimumValue = 15
        sizeSlider.maximumValue = 120
        sizeSlider.value = 48
        sizeSlider.isContinuous = false
        sizeSlider.addTarget(self, action: #selector(fontControlDidChange), for: .valueChanged)

        animatedSwitch.isOn = true

        let textLayer = stage.textView.textLayer
        textLayer.text = "2.8"
        textLayer.font = font
        textLayer.textColor = .label

        add(stage, height: 160)
        add(weightControl)
        add(sizeSlider)

        let animatedRow = UIStackView(arrangedSubviews: [UILabel(), animatedSwitch])
        (animatedRow.arrangedSubviews.first as? UILabel)?.text = "Animated"
        animatedRow.axis = .horizontal
        add(animatedRow)
    }

    private var font: UIFont {
        return .systemFont(ofSize: CGFloat(sizeSlider.value),
                           weight: weights[weightControl.selectedSegmentIndex].weight)
    }

    @objc private func fontControlDidChange() {
        stage.textView.textLayer.setFont(font, animated: animatedSwitch.isOn)
    }
}

#if DEBUG
#Preview("Font Animation") {
    TextViewFontAnimationScenarioViewController()
}
#endif
