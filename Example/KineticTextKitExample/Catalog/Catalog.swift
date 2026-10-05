//
//  Catalog.swift
//  KineticTextKit
//

import SwiftUI

/// Everything the reviewer can open, in the order it is listed.
///
/// The catalog holds the index and nothing else — each entry hands back a
/// scenario that sets itself up.
///
/// The sections are the kit's public types rather than the categories the
/// pattern suggests: each type is a separate thing a consumer reaches for, and a
/// reviewer arrives here knowing which one they came to look at.
///
/// `KineticTextLayer` is listed first because it is the type the others are
/// built on.
enum Catalog {

    static let sections: [CatalogSection] = [

        CatalogSection(title: "KineticTextLayer", scenarios: [
            CatalogScenario(
                title: "Default",
                description: "The layer added straight to a plain UIView's layer — text, font and textColor, no wrapper."
            ) {
                TextLayerDefaultScenarioViewController()
            },
            CatalogScenario(
                title: "Frame Before Content",
                description: "The same text set before and after the layer has a frame, one above the other."
            ) {
                TextLayerFrameOrderScenarioViewController()
            },
            CatalogScenario(
                title: "Frame Changes",
                description: "Resizing the canvas, with the contentMode re-apply that keeps the text laid out switchable."
            ) {
                TextLayerFrameChangeScenarioViewController()
            },
            CatalogScenario(
                title: "Font Animation",
                description: "setFont(_:animated:) on the bare layer, which is where the morph lives."
            ) {
                TextLayerFontAnimationScenarioViewController()
            }
        ]),

        CatalogSection(title: "LAUTextView", scenarios: [
            CatalogScenario(
                title: "Default",
                description: "Text, font and colour on the text view's KineticTextLayer, centred."
            ) {
                TextViewDefaultScenarioViewController()
            },
            CatalogScenario(
                title: "Font Animation",
                description: "setFont(_:animated:) — the text's path morphs between weights and sizes."
            ) {
                TextViewFontAnimationScenarioViewController()
            },
            CatalogScenario(
                title: "Text and Colour",
                description: "text and textColor, set from buttons and segments."
            ) {
                TextViewTextAndColourScenarioViewController()
            },
            CatalogScenario(
                title: "Content Mode",
                description: ".center, .topLeft and .bottomLeft, the three modes the layer lays text out for."
            ) {
                TextViewContentModeScenarioViewController()
            }
        ]),

        CatalogSection(title: "LAULabel", scenarios: [
            CatalogScenario(
                title: "Default",
                description: "The SwiftUI wrapper with a text, a font and a colour — drawn on its top edge."
            ) {
                UIHostingController(rootView: LabelDefaultScenarioView())
            },
            CatalogScenario(
                title: "Font Animation",
                description: "setFont(font:animated:) called from SwiftUI buttons."
            ) {
                UIHostingController(rootView: LabelFontAnimationScenarioView())
            },
            CatalogScenario(
                title: "State Updates",
                description: "Text, weight and colour driven by @State through updateUIView."
            ) {
                UIHostingController(rootView: LabelStateScenarioView())
            }
        ]),

        CatalogSection(title: "LAUSwitch", scenarios: [
            CatalogScenario(
                title: "Default",
                description: "The switch as it comes: OFF over ON, tapped to flip."
            ) {
                SwitchDefaultScenarioViewController()
            },
            CatalogScenario(
                title: "Initially On",
                description: "Set on before it is ever shown, so it opens the other way up."
            ) {
                SwitchInitiallyOnScenarioViewController()
            },
            CatalogScenario(
                title: "Custom Titles",
                description: "Configuration.Title, with FRONT and BACK for a camera choice."
            ) {
                SwitchCustomTitlesScenarioViewController()
            },
            CatalogScenario(
                title: "Custom Style",
                description: "Configuration.Style: the fonts and colours of the enabled and disabled title."
            ) {
                SwitchCustomStyleScenarioViewController()
            },
            CatalogScenario(
                title: "Programmatic Toggle",
                description: "setOn(_:animated:) driven from buttons — the same change with and without the animation."
            ) {
                SwitchProgrammaticScenarioViewController()
            }
        ]),

        CatalogSection(title: "LAUPathSwitch", scenarios: [
            CatalogScenario(
                title: "Default",
                description: "Tap to step through none, yes and no; each step morphs the path."
            ) {
                PathSwitchDefaultScenarioViewController()
            },
            CatalogScenario(
                title: "States",
                description: "Every LAUPathSwitchToggleState, set without animation."
            ) {
                PathSwitchStatesScenarioViewController()
            },
            CatalogScenario(
                title: "Programmatic",
                description: "setToggle(state:animated:) from buttons, to any state from any other."
            ) {
                PathSwitchProgrammaticScenarioViewController()
            },
            CatalogScenario(
                title: "Tint Colour",
                description: "tintColor, which fills the path."
            ) {
                PathSwitchTintScenarioViewController()
            }
        ]),

        CatalogSection(title: "KineticTextKitDynamicItem", scenarios: [
            CatalogScenario(
                title: "Attachment and Push",
                description: "Two text layers under UIKit Dynamics, tied together and pushed."
            ) {
                DynamicsAttachmentScenarioViewController()
            }
        ])
    ]
}
