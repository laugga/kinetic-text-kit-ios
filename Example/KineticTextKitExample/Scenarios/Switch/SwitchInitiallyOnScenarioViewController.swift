//
//  SwitchInitiallyOnScenarioViewController.swift
//  KineticTextKit
//

import UIKit
import KineticTextKit

/// The switch set on before it is ever shown, the way a remembered choice is
/// restored. It should open with ON in the enabled style — the other way up
/// from the default scenario — and without animating on the way in.
final class SwitchInitiallyOnScenarioViewController: ScenarioViewController {

    private let toggleSwitch = LAUSwitch()

    private lazy var valueLabel = makeValueLabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        addNote("isOn was set to true before the switch was added, so it opens on.")

        toggleSwitch.isOn = true
        toggleSwitch.addTarget(self, action: #selector(toggleSwitchValueDidChange), for: .valueChanged)
        addLeadingAligned(toggleSwitch)

        add(valueLabel)

        showValue()
    }

    @objc private func toggleSwitchValueDidChange() {
        showValue()
    }

    private func showValue() {
        valueLabel.text = "isOn: \(toggleSwitch.isOn)"
    }
}

#if DEBUG
#Preview("Initially On") {
    SwitchInitiallyOnScenarioViewController()
}
#endif
