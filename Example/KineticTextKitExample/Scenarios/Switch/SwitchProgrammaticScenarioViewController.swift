//
//  SwitchProgrammaticScenarioViewController.swift
//  KineticTextKit
//

import UIKit
import KineticTextKit

/// The two programmatic ways in: `setOn(_:animated:)`, and `isOn` — which is the
/// same call with `animated: false`. The buttons drive both switches at once, so
/// the animated and unanimated transitions run side by side.
final class SwitchProgrammaticScenarioViewController: ScenarioViewController {

    private let animatedSwitch = LAUSwitch()

    private let immediateSwitch = LAUSwitch()

    override func viewDidLoad() {
        super.viewDidLoad()

        addNote("setOn(_:animated: true), above; isOn, below. The buttons set both.")

        addLeadingAligned(animatedSwitch)
        addLeadingAligned(immediateSwitch)

        add(makeButtonRow([
            makeButton(title: "On") { [weak self] in
                self?.set(true)
            },
            makeButton(title: "Off") { [weak self] in
                self?.set(false)
            },
            makeButton(title: "Flip") { [weak self] in
                guard let self else { return }
                self.set(!self.animatedSwitch.isOn)
            }
        ]))
    }

    private func set(_ isOn: Bool) {
        animatedSwitch.setOn(isOn, animated: true)
        immediateSwitch.isOn = isOn
    }
}

#if DEBUG
#Preview("Programmatic Toggle") {
    SwitchProgrammaticScenarioViewController()
}
#endif
