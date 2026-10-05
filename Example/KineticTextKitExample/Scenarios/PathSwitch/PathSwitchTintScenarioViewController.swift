//
//  PathSwitchTintScenarioViewController.swift
//  KineticTextKit
//

import UIKit
import KineticTextKit

/// `tintColor`, which is what fills the path. White on black is how the
/// playground has always shown it; the blue one is on the plain background.
final class PathSwitchTintScenarioViewController: ScenarioViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addNote("tintColor fills the path. Tap either switch to step it on.")

        let onBlack = LAUPathSwitch()
        onBlack.tintColor = .white
        onBlack.backgroundColor = .black
        addCaptioned("White on black", leadingAligned(onBlack))

        let blue = LAUPathSwitch()
        blue.tintColor = .systemBlue
        addCaptioned("System blue", leadingAligned(blue))
    }

    private func leadingAligned(_ pathSwitch: LAUPathSwitch) -> UIView {
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

        return row
    }
}

#if DEBUG
#Preview("Tint Colour") {
    PathSwitchTintScenarioViewController()
}
#endif
