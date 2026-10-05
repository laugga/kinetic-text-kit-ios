//
//  LayoutReportingView.swift
//  KineticTextKit
//

import UIKit

/// A plain `UIView` that hands its layout pass back to the scenario holding it.
///
/// It is deliberately *not* a `TextViewStage`: it knows nothing about
/// `KineticTextLayer` and decides nothing on the scenario's behalf. Each
/// scenario sets the layer's frame and re-applies its content itself, in its
/// own file, because that is what this section is about. All this view
/// contributes is *when* — a view's bounds are only reliably its own inside
/// `layoutSubviews`, and a view controller's `viewDidLayoutSubviews` runs
/// before a stack view has sized what it arranges.
final class LayoutReportingView: UIView {

    /// Called after every layout pass, when `bounds` is final.
    var didLayout: (() -> Void)?

    override func layoutSubviews() {
        super.layoutSubviews()

        didLayout?()
    }
}
