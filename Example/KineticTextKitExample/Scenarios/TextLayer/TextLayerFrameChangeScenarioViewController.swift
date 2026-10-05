//
//  TextLayerFrameChangeScenarioViewController.swift
//  KineticTextKit
//

import UIKit
import KineticTextKit

/// The other half of the frame contract: what a consumer has to do when the
/// frame changes after the content was set.
///
/// The slider resizes the canvas, and the layer is given the new bounds every
/// layout pass. That alone moves the layer but not the path inside it —
/// `contentMode` has to be set again for the text to be laid out against the
/// new height. The switch turns that one line off, so the difference is
/// something the reviewer can watch rather than take on trust.
final class TextLayerFrameChangeScenarioViewController: ScenarioViewController {

    private let canvas = LayoutReportingView()

    private let textLayer = KineticTextLayer()

    private lazy var canvasHeight = canvas.heightAnchor.constraint(equalToConstant: 160)

    private let heightSlider = UISlider()

    private lazy var heightLabel = makeValueLabel()

    private let reapplySwitch = UISwitch()

    private let modes: [(name: String, mode: UIView.ContentMode)] = [
        (".center", .center),
        (".topLeft", .topLeft),
        (".bottomLeft", .bottomLeft)
    ]

    private lazy var modeControl = UISegmentedControl(items: modes.map(\.name))

    override func viewDidLoad() {
        super.viewDidLoad()

        addNote("Drag the slider to resize the canvas. With the switch off the layer is moved but the text is not laid out again, so it keeps the position it had at the old height.")

        canvas.layer.borderWidth = 1
        canvas.layer.borderColor = UIColor.separator.cgColor
        canvas.layer.addSublayer(textLayer)
        canvas.didLayout = { [weak self] in
            self?.layOutTextLayer()
        }

        add(canvas)
        canvasHeight.isActive = true

        textLayer.font = .systemFont(ofSize: 40, weight: .semibold)
        textLayer.textColor = .label
        textLayer.text = "2.8"

        heightSlider.minimumValue = 80
        heightSlider.maximumValue = 240
        heightSlider.value = Float(canvasHeight.constant)
        heightSlider.isContinuous = false
        heightSlider.addTarget(self, action: #selector(heightSliderDidChange), for: .valueChanged)

        add(heightLabel)
        add(heightSlider)
        updateHeightLabel()

        reapplySwitch.isOn = true
        add(makeSwitchRow(title: "Re-apply contentMode on layout", control: reapplySwitch))

        modeControl.selectedSegmentIndex = 0
        modeControl.addTarget(self, action: #selector(modeControlDidChange), for: .valueChanged)
        add(modeControl)
    }

    /// The layer is given the canvas's new bounds every layout pass. That
    /// moves it; it does not lay the path out again. The switch decides whether
    /// the one line that does is run.
    private func layOutTextLayer() {
        guard textLayer.frame != canvas.bounds else {
            return
        }

        CATransaction.begin()
        CATransaction.setDisableActions(true)

        textLayer.frame = canvas.bounds

        if reapplySwitch.isOn {
            // Setting `contentMode` is what lays the path out again — the value
            // does not have to change, only be set.
            textLayer.contentMode = textLayer.contentMode
        }

        CATransaction.commit()
    }

    @objc private func heightSliderDidChange() {
        canvasHeight.constant = CGFloat(heightSlider.value.rounded())
        updateHeightLabel()
    }

    /// Setting `contentMode` lays the path out against the frame the layer has
    /// now, so a mode picked here takes effect immediately — it is only a later
    /// frame change that leaves it stale.
    @objc private func modeControlDidChange() {
        textLayer.contentMode = modes[modeControl.selectedSegmentIndex].mode
    }

    private func updateHeightLabel() {
        heightLabel.text = "Canvas height: \(Int(canvasHeight.constant)) pt"
    }

    private func makeSwitchRow(title: String, control: UISwitch) -> UIStackView {
        let label = makeValueLabel(title)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        let row = UIStackView(arrangedSubviews: [label, control])
        row.axis = .horizontal
        row.spacing = 12
        row.alignment = .center

        return row
    }
}

#if DEBUG
#Preview("Frame Changes") {
    TextLayerFrameChangeScenarioViewController()
}
#endif
