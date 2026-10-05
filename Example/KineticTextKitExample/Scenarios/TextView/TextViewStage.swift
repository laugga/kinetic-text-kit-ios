//
//  TextViewStage.swift
//  KineticTextKit
//

import UIKit
import KineticTextKit

/// An `LAUTextView` with its bounds outlined, so the reviewer can see where the
/// text sits inside the frame it was laid out against.
///
/// `LAUTextView` never sizes its `textLayer`, and `KineticTextLayer` lays its
/// path out against its own frame at the moment `text`, `font` or `contentMode`
/// is set. So the stage does what any consumer has to: it keeps the layer's
/// frame equal to the view's bounds, and re-applies `contentMode` — which lays
/// the path out again — whenever that frame changes.
final class TextViewStage: UIView {

    let textView = LAUTextView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.borderWidth = 1
        layer.borderColor = UIColor.separator.cgColor

        textView.frame = bounds
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(textView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let textLayer = textView.textLayer

        guard textLayer.frame != textView.bounds else {
            return
        }

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        textLayer.frame = textView.bounds
        let contentMode = textLayer.contentMode
        textLayer.contentMode = contentMode
        CATransaction.commit()
    }
}
