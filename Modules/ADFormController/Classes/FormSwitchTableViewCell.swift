//
//  FormSwitchTableViewCell.swift
//  Pods
//
//  Created by Samuel Gallet on 07/07/16.
//
//

import UIKit

class FormSwitchTableViewCell: UITableViewCell, FormBoolInputTableViewCell {

    private lazy var switchView: UISwitch = self.createSwitchView()
    private lazy var leftLabel: UILabel = self.createLeftLabel()
    private lazy var stackView: UIStackView = self.createStackView()
    private lazy var rightContainerView: UIView = self.createAccessoryContainerView()
    private lazy var leftContainerView: UIView = self.createAccessoryContainerView()

    private var rightView: UIView? {
        willSet {
            guard let rightView = self.rightView else {
                return
            }
            rightView.removeFromSuperview()
        }
        didSet {
            rightContainerView.isHidden = self.rightView == nil
            guard let rightView = self.rightView else {
                return
            }
            rightView.translatesAutoresizingMaskIntoConstraints = false
            rightContainerView.addSubview(rightView)
            NSLayoutConstraint.activate([
                rightView.trailingAnchor.constraint(equalTo: rightContainerView.trailingAnchor),
                rightView.leadingAnchor.constraint(equalTo: rightContainerView.leadingAnchor),
                rightView.topAnchor.constraint(equalTo: rightContainerView.topAnchor),
                rightView.bottomAnchor.constraint(equalTo: rightContainerView.bottomAnchor)
            ])
        }
    }

    private var leftView: UIView? {
        willSet {
            guard let leftView = self.leftView else {
                return
            }
            leftView.removeFromSuperview()
        }
        didSet {
            leftContainerView.isHidden = self.leftView == nil
            guard let leftView = self.leftView else {
                return
            }
            leftView.translatesAutoresizingMaskIntoConstraints = false
            leftContainerView.addSubview(leftView)
            NSLayoutConstraint.activate([
                leftView.trailingAnchor.constraint(equalTo: leftContainerView.trailingAnchor),
                leftView.leadingAnchor.constraint(equalTo: leftContainerView.leadingAnchor),
                leftView.topAnchor.constraint(equalTo: leftContainerView.topAnchor),
                leftView.bottomAnchor.constraint(equalTo: leftContainerView.bottomAnchor)
            ])
        }
    }

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
        //hack to have a nice background color for off position
        switchView.layer.cornerRadius = 16.0
        switchView.backgroundColor = configuration.tintColor
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
        layoutMargins = UIEdgeInsets.zero
        separatorInset = UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 0)
        selectionStyle = .none
        updateStackViewConstraints(with: UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 15.0))
        stackView.addArrangedSubview(leftContainerView)
        stackView.addArrangedSubview(leftLabel)
        let switchContainerView = UIView()
        switchContainerView.translatesAutoresizingMaskIntoConstraints = false
        switchContainerView.addSubview(switchView)
        NSLayoutConstraint.activate([
            switchView.trailingAnchor.constraint(equalTo: switchContainerView.trailingAnchor),
            switchView.leadingAnchor.constraint(equalTo: switchContainerView.leadingAnchor),
            switchView.centerYAnchor.constraint(equalTo: switchContainerView.centerYAnchor),
        ])
        stackView.addArrangedSubview(switchContainerView)
        stackView.addArrangedSubview(rightContainerView)
    }

    private func updateStackViewConstraints(with insets: UIEdgeInsets) {
        stackView.removeFromSuperview() // clear constraints
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -insets.right),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: insets.left),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: insets.top),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -insets.bottom)
        ])
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
        self.delegate?.boolInputTableViewCellDidChangeValue(self)
    }

    private func createStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8.0
        return stackView
    }

    private func createAccessoryContainerView() -> UIView {
        let view = UIView()
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        return view
    }
}
