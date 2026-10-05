//
//  SwitchCustomStyleScenarioViewController.swift
//  KineticTextKit
//

import UIKit
import KineticTextKit

/// `Configuration.Style`: the font and colour of the title that is selected and
/// of the one that is not. Tapping animates between the two fonts, so a wide gap
/// between the sizes is the clearest way to see what the switch actually does.
/// The titles are the default ON and OFF, so only the style differs.
final class SwitchCustomStyleScenarioViewController: ScenarioViewController {

    private let toggleSwitch = LAUSwitch()

    override func viewDidLoad() {
        super.viewDidLoad()

        addNote("A heavier, larger enabled title and a much smaller disabled one. Tap to watch it animate between them.")

        toggleSwitch.configuration = LAUSwitch.Configuration(
            title: LAUSwitch.Configuration.Title(on: "ON", off: "OFF"),
            style: LAUSwitch.Configuration.Style(
                enabled: LAUSwitch.Configuration.Style.TitleStyle(font: .systemFont(ofSize: 40, weight: .bold),
                                                                   color: .systemOrange),
                disabled: LAUSwitch.Configuration.Style.TitleStyle(font: .systemFont(ofSize: 16, weight: .light),
                                                                    color: .systemOrange.withAlphaComponent(0.4))
            )
        )
        addLeadingAligned(toggleSwitch)
    }
}

#if DEBUG
#Preview("Custom Style") {
    SwitchCustomStyleScenarioViewController()
}
#endif
