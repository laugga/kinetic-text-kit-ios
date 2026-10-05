//
//  TextLayerDefaultScenarioViewController.swift
//  KineticTextKit
//

import UIKit
import KineticTextKit

/// `KineticTextLayer` on its own: added to a plain `UIView`'s layer, with the
/// three things it needs before it draws anything — a `text`, a `font` and a
/// `textColor`.
///
/// There is no `LAUTextView` here, so nothing keeps the layer's frame up to
/// date. The layer lays its path out against its own frame at the moment the
/// content is set, and a `CALayer` does not resize with the view it was added
/// to, so `layOutTextLayer()` below is work a consumer writes for themselves.
/// It is spelled out rather than hidden in a helper because it is the subject
/// of this section.
final class TextLayerDefaultScenarioViewController: ScenarioViewController {

    /// A plain `UIView` — nothing from the kit. Its `layer` is the superlayer,
    /// and its layout pass is what the scenario hangs the frame work on.
    private let canvas = LayoutReportingView()

    private let textLayer = KineticTextLayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        addNote("A KineticTextLayer added straight to a plain UIView's layer. The outline is that view's bounds.")

        canvas.layer.borderWidth = 1
        canvas.layer.borderColor = UIColor.separator.cgColor
        canvas.layer.addSublayer(textLayer)
        canvas.didLayout = { [weak self] in
            self?.layOutTextLayer()
        }

        add(canvas, height: 120)

        // Set here, while the canvas still has no bounds — which is the usual
        // order, and on its own the wrong one. The layout pass below is what
        // rescues it. "Frame Before Content" shows what it looks like without.
        textLayer.font = .systemFont(ofSize: 48, weight: .semibold)
        textLayer.textColor = .label
        textLayer.text = "2.8"

        addNote("Rotate the device: the canvas lays out again, and the layer is given the new frame and asked to lay its path out against it.")
    }

    /// The two steps, both needed: the frame, because the layer does not follow
    /// its superlayer, and then a re-applied `contentMode`, because that is what
    /// lays the path out again against the frame the layer now has.
    private func layOutTextLayer() {
        guard textLayer.frame != canvas.bounds else {
            return
        }

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        textLayer.frame = canvas.bounds
        textLayer.contentMode = textLayer.contentMode
        CATransaction.commit()
    }
}

#if DEBUG
#Preview("Default") {
    TextLayerDefaultScenarioViewController()
}
#endif
