//
//  TextLayerFrameOrderScenarioViewController.swift
//  KineticTextKit
//

import UIKit
import KineticTextKit

/// Why the frame has to come first, shown rather than described.
///
/// `KineticTextLayer` lays its path out against its own frame at the moment
/// `text`, `font` or `contentMode` is set, and it does not lay it out again by
/// itself. Two layers here get the same text, the same font and the same frame;
/// they differ only in the order, and the top one never recovers.
final class TextLayerFrameOrderScenarioViewController: ScenarioViewController {

    private let contentFirstCanvas = LayoutReportingView()

    private let contentFirstLayer = KineticTextLayer()

    private let frameFirstCanvas = LayoutReportingView()

    private let frameFirstLayer = KineticTextLayer()

    private var hasSetFrameFirstContent = false

    override func viewDidLoad() {
        super.viewDidLoad()

        addNote("The same layer, the same text, the same font, the same frame. The only difference is the order.")

        outline(contentFirstCanvas, hosting: contentFirstLayer)
        contentFirstCanvas.didLayout = { [weak self] in
            guard let self else { return }

            // The frame arrives, but the content is never set again — so the
            // path keeps the layout it was given when there was no height.
            self.setFrame(of: self.contentFirstLayer, to: self.contentFirstCanvas.bounds)
        }

        add(contentFirstCanvas, height: 96)
        add(makeValueLabel("Content first — set in viewDidLoad, while the layer's frame is still .zero. The path was laid out for a height of zero, so .center centres it on the top edge, and nothing lays it out again."))

        outline(frameFirstCanvas, hosting: frameFirstLayer)
        frameFirstCanvas.didLayout = { [weak self] in
            guard let self else { return }

            self.setFrame(of: self.frameFirstLayer, to: self.frameFirstCanvas.bounds)

            // Only now, with a frame to be laid out against, is the content set.
            if !self.hasSetFrameFirstContent, !self.frameFirstCanvas.bounds.isEmpty {
                self.hasSetFrameFirstContent = true
                self.configure(self.frameFirstLayer)
            }
        }

        add(frameFirstCanvas, height: 96)
        add(makeValueLabel("Frame first — the content is set from the canvas's layout pass, once it has bounds and the layer has been given them. Centred, as asked for."))

        configure(contentFirstLayer)
    }

    /// Border and superlayer only — the frame work stays in the layout
    /// closures above, where it can be read.
    private func outline(_ canvas: UIView, hosting textLayer: KineticTextLayer) {
        canvas.layer.borderWidth = 1
        canvas.layer.borderColor = UIColor.separator.cgColor
        canvas.layer.addSublayer(textLayer)
    }

    /// A `CALayer` added to a view's layer does not resize with it, so both
    /// layers are given their frame by hand. On its own this moves the layer
    /// and leaves the path where it was.
    private func setFrame(of textLayer: KineticTextLayer, to bounds: CGRect) {
        guard textLayer.frame != bounds else {
            return
        }

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        textLayer.frame = bounds
        CATransaction.commit()
    }

    private func configure(_ textLayer: KineticTextLayer) {
        textLayer.font = .systemFont(ofSize: 32, weight: .semibold)
        textLayer.textColor = .label
        textLayer.text = "2.8"
    }
}

#if DEBUG
#Preview("Frame Before Content") {
    TextLayerFrameOrderScenarioViewController()
}
#endif
