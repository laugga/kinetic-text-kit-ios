//
//  SwitchDefaultScenarioViewController.swift
//  KineticTextKit
//

import UIKit
import KineticTextKit

/// `LAUSwitch` as it comes, with nothing configured: the default titles, OFF
/// over ON, and the default style. The label underneath is fed by `.valueChanged`, so it
/// also shows that the switch sends its action on a tap.
final class SwitchDefaultScenarioViewController: ScenarioViewController {

    private let toggleSwitch = LAUSwitch()

    private lazy var valueLabel = makeValueLabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        addNote("Tap the switch to flip it. The line below is written from its .valueChanged action.")

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
#Preview("Default") {
    SwitchDefaultScenarioViewController()
}
#endif
