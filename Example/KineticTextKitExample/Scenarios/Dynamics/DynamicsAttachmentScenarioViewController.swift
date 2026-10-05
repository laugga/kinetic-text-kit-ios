//
//  DynamicsAttachmentScenarioViewController.swift
//  KineticTextKit
//

import UIKit
import KineticTextKit

/// `KineticTextKitDynamicItem`, which puts a `KineticTextLayer` under UIKit
/// Dynamics. Two layers are tied together by a springy attachment; Push gives
/// the first one an instantaneous shove and the second follows on the tie.
final class DynamicsAttachmentScenarioViewController: ScenarioViewController {

    private let stage = UIView()

    private let layerA = KineticTextLayer()

    private let layerB = KineticTextLayer()

    private lazy var itemA = KineticTextKitDynamicItem(layer: layerA)

    private lazy var itemB = KineticTextKitDynamicItem(layer: layerB)

    private var animator: UIDynamicAnimator?

    override func viewDidLoad() {
        super.viewDidLoad()

        addNote("Push shoves A to the right; B is attached to it and follows. Reset puts both back.")

        stage.clipsToBounds = true
        stage.layer.borderWidth = 1
        stage.layer.borderColor = UIColor.separator.cgColor
        add(stage, height: 200)

        configure(layerA, text: "A")
        configure(layerB, text: "B")

        add(makeButtonRow([
            makeButton(title: "Push") { [weak self] in
                self?.push()
            },
            makeButton(title: "Reset") { [weak self] in
                self?.reset()
            }
        ]))

        reset()
    }

    private func configure(_ textLayer: KineticTextLayer, text: String) {
        textLayer.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        textLayer.text = text
        textLayer.font = .systemFont(ofSize: 40, weight: .semibold)
        textLayer.textColor = .label
        stage.layer.addSublayer(textLayer)
    }

    private func push() {
        reset()

        let animator = UIDynamicAnimator(referenceView: stage)

        let attachment = UIAttachmentBehavior.limitAttachment(with: itemA,
                                                              offsetFromCenter: UIOffset(horizontal: 0.1, vertical: 0.1),
                                                              attachedTo: itemB,
                                                              offsetFromCenter: .zero)
        attachment.frequency = 2.0
        attachment.damping = 0.1
        attachment.length = 50
        animator.addBehavior(attachment)

        let push = UIPushBehavior(items: [itemA], mode: .instantaneous)
        push.angle = 0
        push.magnitude = 1.0
        animator.addBehavior(push)

        // The animator stops as soon as nothing holds it.
        self.animator = animator
    }

    private func reset() {
        animator?.removeAllBehaviors()
        animator = nil

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        itemA.transform = .identity
        itemB.transform = .identity
        itemA.center = CGPoint(x: 80, y: 100)
        itemB.center = CGPoint(x: 180, y: 100)
        CATransaction.commit()
    }
}

#if DEBUG
#Preview("Attachment and Push") {
    DynamicsAttachmentScenarioViewController()
}
#endif
