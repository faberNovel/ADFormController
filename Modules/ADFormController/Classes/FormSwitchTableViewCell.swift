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
    private lazy var leftLabel = self.createLeftLabel()
    private var dynamicConstraints: [NSLayoutConstraint] = []
    private var rightView: UIView?
    private let margin = 15.0

    //MARK: - UIView

    override func updateConstraints() {
        contentView.removeConstraints(dynamicConstraints)
        dynamicConstraints.removeAll()
        if let rightView = rightView {
            let views: [String: Any] = [
                "switchView": switchView,
                "rightView": rightView
            ]
            let metrics: [String: Any] = [
                "rightViewWidth": rightView.bounds.width,
                "rightViewHeight": rightView.bounds.height,
                "margin": margin
            ]
            var constraints = NSLayoutConstraint.constraints(
                withVisualFormat: "H:[switchView]-[rightView(rightViewWidth)]|",
                options: .alignAllCenterY,
                metrics: metrics,
                views: views
            )
            dynamicConstraints.append(contentsOf: constraints)
            constraints = NSLayoutConstraint.constraints(
                withVisualFormat: "V:[rightView(rightViewHeight)]",
                options: .alignAllLeft,
                metrics: metrics,
                views: views
            )
            dynamicConstraints.append(contentsOf: constraints)
        } else {
            let views = [
                "switchView" : switchView
            ]
            let metrics = [
                "margin" : margin
            ]
            let constraints = NSLayoutConstraint.constraints(
                withVisualFormat: "H:[switchView]-margin-|",
                options: .alignAllLeft,
                metrics: metrics,
                views: views
            )
            dynamicConstraints.append(contentsOf: constraints)
        }
        contentView.addConstraints(dynamicConstraints)
        super.updateConstraints()
    }

    //MARK: - UITableViewCell

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        switchView.addTarget(
            self,
            action: #selector(FormSwitchTableViewCell.switchValueChanged(_:)),
            for: .valueChanged
        )
        contentView.addSubview(switchView)
        contentView.addSubview(leftLabel)
        setupStaticConstraints()
        layoutMargins = UIEdgeInsets.zero
        separatorInset = UIEdgeInsetsMake(0, CGFloat(margin) as CGFloat, 0, 0)
        selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
    }

    //MARK: - Private

    private func createSwitchView() -> UISwitch {
        let switchView = UISwitch()
        switchView.translatesAutoresizingMaskIntoConstraints = false
        return switchView
    }

    private func createLeftLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }

    func setupStaticConstraints() {
        switchView.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        let views: [String: Any] = [
            "switchView": switchView,
            "leftLabel": leftLabel
        ]
        let metrics = [
            "margin": margin
        ]
        addConstraint(
            NSLayoutConstraint(
                item: contentView,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: switchView,
                attribute: .centerY,
                multiplier: 1.0,
                constant: 0.0
            )
        )
        contentView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-margin-[leftLabel]-margin-[switchView]",
                options: .alignAllCenterY,
                metrics: metrics,
                views: views
            )
        )
        contentView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[leftLabel(>=42)]|",
                options: .alignAllLeft,
                metrics: metrics,
                views: views
            )
        )
    }

    @objc private func switchValueChanged(_ sender: UISwitch) {
        self.delegate?.boolInputTableViewCellDidChangeValue(self)
    }
}
