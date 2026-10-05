//
//  SwitchCustomTitlesScenarioViewController.swift
//  KineticTextKit
//

import UIKit
import KineticTextKit

/// `Configuration.Title`: the words on the two halves of the switch. The style
/// is written out at its default values, since a configuration takes both.
final class SwitchCustomTitlesScenarioViewController: ScenarioViewController {

    private let toggleSwitch = LAUSwitch()

    override func viewDidLoad() {
        super.viewDidLoad()

        addNote("BACK over FRONT, the camera choice this switch was first built for. Tap to flip it.")

        toggleSwitch.configuration = LAUSwitch.Configuration(
            title: LAUSwitch.Configuration.Title(on: "FRONT", off: "BACK"),
            style: LAUSwitch.Configuration.Style(
                enabled: LAUSwitch.Configuration.Style.TitleStyle(font: .systemFont(ofSize: 30),
                                                                   color: .black),
                disabled: LAUSwitch.Configuration.Style.TitleStyle(font: .systemFont(ofSize: 22),
                                                                    color: .black.withAlphaComponent(0.5))
            )
        )
        addLeadingAligned(toggleSwitch)
    }
}

#if DEBUG
#Preview("Custom Titles") {
    SwitchCustomTitlesScenarioViewController()
}
#endif
