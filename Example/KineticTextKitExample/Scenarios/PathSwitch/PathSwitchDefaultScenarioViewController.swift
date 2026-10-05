//
//  PathSwitchDefaultScenarioViewController.swift
//  KineticTextKit
//

import UIKit
import KineticTextKit

/// `LAUPathSwitch` as it comes: no tint set, so its path is drawn in a shape
/// layer's default black. It has no intrinsic size, so it is given the 60 × 16
/// its paths are drawn for.
final class PathSwitchDefaultScenarioViewController: ScenarioViewController {

    private let pathSwitch = LAUPathSwitch()

    override func viewDidLoad() {
        super.viewDidLoad()

        addNote("Tap to step through .none, .yes and .no. Each step morphs the path over two seconds.")

        addLeadingAligned(pathSwitch, size: CGSize(width: 60, height: 16))
    }
}

#if DEBUG
#Preview("Default") {
    PathSwitchDefaultScenarioViewController()
}
#endif
