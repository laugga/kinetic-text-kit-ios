//
//  ScenarioViewController.swift
//  KineticTextKit
//

import UIKit

/// The frame every UIKit scenario is hung on: a vertical run of whatever the
/// scenario wants to show, plus the controls it needs to drive it.
///
/// It exists so that each scenario does not repeat the same Auto Layout. It does
/// nothing to the components themselves — each scenario still builds and
/// configures its own.
class ScenarioViewController: UIViewController {

    private let stack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        stack.axis = .vertical
        stack.spacing = 24
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: safeArea.bottomAnchor, constant: -24)
        ])
    }

    /// Adds a view of a fixed height below whatever is already there — a text
    /// stage, mostly, which has no size of its own to be laid out at.
    func add(_ subview: UIView, height: CGFloat) {
        add(subview)

        subview.heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    /// Adds a control, a label, or anything else below whatever is already there.
    func add(_ subview: UIView) {
        stack.addArrangedSubview(subview)
    }

    /// Adds a view pinned to the leading edge, at its intrinsic size — or at
    /// `size`, for a view that has none of its own, such as `LAUPathSwitch`.
    func addLeadingAligned(_ subview: UIView, size: CGSize? = nil) {
        let row = UIView()
        subview.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(subview)

        var constraints = [
            subview.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            subview.topAnchor.constraint(equalTo: row.topAnchor),
            subview.bottomAnchor.constraint(equalTo: row.bottomAnchor),
            subview.trailingAnchor.constraint(lessThanOrEqualTo: row.trailingAnchor)
        ]

        if let size {
            constraints += [
                subview.widthAnchor.constraint(equalToConstant: size.width),
                subview.heightAnchor.constraint(equalToConstant: size.height)
            ]
        }

        NSLayoutConstraint.activate(constraints)

        add(row)
    }

    /// Adds the line telling the reviewer what to do with the scenario, for the
    /// ones that are not self-evident.
    func addNote(_ text: String) {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .secondaryLabel

        add(label)
    }

    /// A label the scenario writes to — a caption, or a value it keeps
    /// rewriting as the component reports back.
    func makeValueLabel(_ text: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .secondaryLabel

        return label
    }

    /// A caption stacked tight above the view it names, so that a scenario
    /// showing several variants side by side keeps each name with its variant.
    func addCaptioned(_ caption: String, _ subview: UIView) {
        let group = UIStackView(arrangedSubviews: [makeValueLabel(caption), subview])
        group.axis = .vertical
        group.spacing = 8
        group.alignment = .fill

        add(group)
    }

    /// A button wired straight to a closure, for the scenarios driven by one.
    func makeButton(title: String, handler: @escaping () -> Void) -> UIButton {
        var configuration = UIButton.Configuration.bordered()
        configuration.title = title

        return UIButton(configuration: configuration, primaryAction: UIAction { _ in handler() })
    }

    /// A row of buttons side by side.
    func makeButtonRow(_ buttons: [UIButton]) -> UIStackView {
        let row = UIStackView(arrangedSubviews: buttons)
        row.axis = .horizontal
        row.spacing = 12
        row.distribution = .fillEqually

        return row
    }
}
