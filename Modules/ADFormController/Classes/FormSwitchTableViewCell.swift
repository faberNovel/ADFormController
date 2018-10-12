//
//  FormSwitchTableViewCell.swift
//  Pods
//
//  Created by Samuel Gallet on 07/07/16.
//
//

import UIKit

class FormSwitchTableViewCell: FormBaseTableViewCell, FormBoolInputTableViewCell {

    private lazy var switchView: UISwitch = self.createSwitchView()
    private lazy var leftLabel: UILabel = self.createLeftLabel()

    //MARK: - UITableViewCell

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    //MARK: - FormBoolInputTableViewCell

    weak var delegate: FormBoolInputTableViewCellDelegate?

    var boolContent: Bool {
        get {
            return switchView.isOn
        }
        set {
            switchView.isOn = newValue
        }
    }

    func apply(configuration: FormCellBoolConfiguration) {
        rightView = configuration.rightView
        leftView = configuration.leftView
        leftLabel.text = configuration.title
        leftLabel.font = configuration.titleFont
        leftLabel.textColor = configuration.titleColor
        switchView.isOn = configuration.boolValue
        switchView.onTintColor = configuration.onTintColor
        switchView.accessibilityIdentifier = configuration.switchAccessibilityIdentifier
        //hack to have a nice background color for off position
        switchView.layer.cornerRadius = 16.0
        switchView.backgroundColor = configuration.tintColor
        hideRightViewWhenEditing = configuration.hideRightViewWhenEditing
        let scale = CGAffineTransform(
            scaleX: CGFloat(configuration.switchZoom),
            y: CGFloat(configuration.switchZoom)
        )
        let clipToRightTransform = CGAffineTransform(
            translationX: CGFloat(switchView.frame.width) * (1.0 - CGFloat(configuration.switchZoom)) / 2.0,
            y: 0.0
        )
        self.switchView.transform = scale.concatenating(clipToRightTransform)
        switchView.isEnabled = configuration.enabled
        if let separatorInset = configuration.separatorInset {
            self.separatorInset = separatorInset
        }
        if let contentInset = configuration.contentInset {
            updateStackViewConstraints(with: contentInset)
        }
    }

    //MARK: - Private

    private func setup() {
        insertSubviewInStackView(leftLabel)
        let switchContainerView = UIView()
        switchContainerView.translatesAutoresizingMaskIntoConstraints = false
        switchContainerView.addSubview(switchView)
        NSLayoutConstraint.activate([
            switchView.trailingAnchor.constraint(equalTo: switchContainerView.trailingAnchor),
            switchView.leadingAnchor.constraint(equalTo: switchContainerView.leadingAnchor),
            switchView.centerYAnchor.constraint(equalTo: switchContainerView.centerYAnchor),
        ])
        insertSubviewInStackView(switchContainerView)
    }

    private func createSwitchView() -> UISwitch {
        let switchView = UISwitch()
        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.setContentHuggingPriority(.required, for: .horizontal)
        switchView.addTarget(
            self,
            action: #selector(FormSwitchTableViewCell.switchValueChanged(_:)),
            for: .valueChanged
        )
        return switchView
    }

    private func createLeftLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }

    @objc private func switchValueChanged(_ sender: UISwitch) {
        if hideRightViewWhenEditing { rightView?.isHidden = true }
        self.delegate?.boolInputTableViewCellDidChangeValue(self)
    }
}
