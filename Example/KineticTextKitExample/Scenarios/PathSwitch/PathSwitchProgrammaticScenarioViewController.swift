//
//  PathSwitchProgrammaticScenarioViewController.swift
//  KineticTextKit
//

import UIKit
import KineticTextKit

/// `setToggle(state:animated: true)` from buttons, so any state can be morphed
/// to any other — tapping the switch only ever steps forward.
final class PathSwitchProgrammaticScenarioViewController: ScenarioViewController {

    private let pathSwitch = LAUPathSwitch()

    private lazy var valueLabel = makeValueLabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        addNote("Each button calls setToggle(state:animated: true). Next steps on with toggle(), as a tap does.")

        addLeadingAligned(pathSwitch, size: CGSize(width: 60, height: 16))

        add(valueLabel)

        add(makeButtonRow(LAUPathSwitchToggleState.allCases.map { state in
            makeButton(title: ".\(state)") { [weak self] in
                self?.set(state)
            }
        } + [
            makeButton(title: "Next") { [weak self] in
                guard let self else { return }
                self.set(self.pathSwitch.toggleState.toggle())
            }
        ]))

        showValue()
    }

    private func set(_ state: LAUPathSwitchToggleState) {
        pathSwitch.setToggle(state: state, animated: true)
        showValue()
    }

    private func showValue() {
        valueLabel.text = "toggleState: .\(pathSwitch.toggleState)"
    }
}

#if DEBUG
#Preview("Programmatic") {
    PathSwitchProgrammaticScenarioViewController()
}
#endif
