//
//  TextViewDefaultScenarioViewController.swift
//  KineticTextKit
//

import UIKit
import KineticTextKit

/// `LAUTextView` with the three things its `KineticTextLayer` needs before it
/// draws anything — a text, a font and a colour — and `contentMode` left at its
/// default, `.center`.
final class TextViewDefaultScenarioViewController: ScenarioViewController {

    private let stage = TextViewStage()

    override func viewDidLoad() {
        super.viewDidLoad()

        addNote("Text, font and colour set; contentMode left at .center. The outline is the view's bounds.")

        let textLayer = stage.textView.textLayer
        textLayer.text = "2.8"
        textLayer.font = .systemFont(ofSize: 48, weight: .semibold)
        textLayer.textColor = .label

        add(stage, height: 120)
    }
}

#if DEBUG
#Preview("Default") {
    TextViewDefaultScenarioViewController()
}
#endif
