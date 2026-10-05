//
//  TextViewContentModeScenarioViewController.swift
//  KineticTextKit
//

import UIKit
import KineticTextKit

/// The three content modes `KineticTextLayer` lays its path out for, one above
/// the other. `LAUSwitch` stacks its two titles with `.topLeft` and
/// `.bottomLeft`, which is why those two exist.
final class TextViewContentModeScenarioViewController: ScenarioViewController {

    private let modes: [(name: String, mode: UIView.ContentMode)] = [
        (".center", .center),
        (".topLeft", .topLeft),
        (".bottomLeft", .bottomLeft)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        addNote("Each mode only moves the text vertically; horizontally it always starts at the leading edge.")

        for (name, mode) in modes {
            let stage = TextViewStage()

            let textLayer = stage.textView.textLayer
            textLayer.contentMode = mode
            textLayer.text = "2.8"
            textLayer.font = .systemFont(ofSize: 40, weight: .semibold)
            textLayer.textColor = .label

            stage.heightAnchor.constraint(equalToConstant: 88).isActive = true
            addCaptioned(name, stage)
        }
    }
}

#if DEBUG
#Preview("Content Mode") {
    TextViewContentModeScenarioViewController()
}
#endif
