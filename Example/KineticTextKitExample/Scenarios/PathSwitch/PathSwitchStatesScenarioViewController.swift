//
//  PathSwitchStatesScenarioViewController.swift
//  KineticTextKit
//

import UIKit
import KineticTextKit

/// Every `LAUPathSwitchToggleState`, one switch each, set without animation.
///
/// They go through `setToggle(state:animated:)` rather than `toggleState`:
/// assigning `toggleState` records the state but does not redraw the path.
final class PathSwitchStatesScenarioViewController: ScenarioViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addNote("One switch per state, each set with setToggle(state:animated: false).")

        for state in LAUPathSwitchToggleState.allCases {
            let pathSwitch = LAUPathSwitch()
            pathSwitch.setToggle(state: state, animated: false)

            let row = UIView()
            pathSwitch.translatesAutoresizingMaskIntoConstraints = false
            row.addSubview(pathSwitch)

            NSLayoutConstraint.activate([
                pathSwitch.leadingAnchor.constraint(equalTo: row.leadingAnchor),
                pathSwitch.topAnchor.constraint(equalTo: row.topAnchor),
                pathSwitch.bottomAnchor.constraint(equalTo: row.bottomAnchor),
                pathSwitch.widthAnchor.constraint(equalToConstant: 60),
                pathSwitch.heightAnchor.constraint(equalToConstant: 16)
            ])

            addCaptioned(".\(state)", row)
        }
    }
}

#if DEBUG
#Preview("States") {
    PathSwitchStatesScenarioViewController()
}
#endif
