//
//  FormSwitchTableViewCell.swift
//  Pods
//
//  Created by Samuel Gallet on 07/07/16.
//
//

import UIKit

class FormSwitchTableViewCell: UITableViewCell, FormBoolInputTableViewCell {
    let switchView: UISwitch = {
        let switchView = UISwitch()
        switchView.translatesAutoresizingMaskIntoConstraints = false
        return switchView
    } ()
    var dynamicConstraints: [NSLayoutConstraint] = []
    var rightView: UIView?
    let leftLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    } ()
    let margin = 15.0

    // MARK: UIView
    override func updateConstraints() {
        contentView.removeConstraints(dynamicConstraints)
        dynamicConstraints.removeAll()
        if let rightView = rightView {
            let views : [String: AnyObject] = [
                "switchView" : switchView,
                "rightView" : rightView
            ]
            let metrics : [String: AnyObject] = [
                "rightViewWidth" : CGRectGetWidth(rightView.bounds),
                "rightViewHeight" : CGRectGetHeight(rightView.bounds),
                "margin" : margin
            ]
            var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[switchView]-[rightView(rightViewWidth)]|",
                                                                             options: .AlignAllCenterY,
                                                                             metrics: metrics,
                                                                             views: views)
            dynamicConstraints.appendContentsOf(constraints)
            constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[rightView(rightViewHeight)]",
                                                                         options: .AlignAllLeft,
                                                                         metrics: metrics,
                                                                         views: views)
            dynamicConstraints.appendContentsOf(constraints)
        } else {
            let views = [
                "switchView" : switchView
            ]
            let metrics = [
                "margin" : margin
            ]
            let constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[switchView]-margin-|",
                                                                             options: .AlignAllLeft,
                                                                             metrics: metrics,
                                                                             views: views)
            dynamicConstraints.appendContentsOf(constraints)
        }
        contentView.addConstraints(dynamicConstraints)
        super.updateConstraints()
    }

    // MARK: UITableViewCell
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        switchView.addTarget(self, action: #selector(FormSwitchTableViewCell.switchValueChanged(_:)), forControlEvents: .ValueChanged)
        contentView.addSubview(switchView)
        contentView.addSubview(leftLabel)
        setupStaticConstraints()
        layoutMargins = UIEdgeInsetsZero
        separatorInset = UIEdgeInsetsMake(0, CGFloat(margin) as CGFloat, 0, 0)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: FormBoolInputTableViewCell
    weak var delegate: FormBoolInputTableViewCellDelegate?
    var boolContent: Bool {
        get {
            return switchView.on
        }
        set {
            switchView.on = newValue
        }
    }

    func applyConfiguration(configuration: FormCellBoolConfiguration) {
        rightView = configuration.rightView
        leftLabel.text = configuration.title
        leftLabel.font = configuration.titleFont
        leftLabel.textColor = configuration.titleColor
        switchView.on = configuration.boolValue
        switchView.onTintColor = configuration.onTintColor
        //hack to have a nice background color for off position
        switchView.layer.cornerRadius = 16.0
        switchView.backgroundColor = configuration.tintColor
        let scale = CGAffineTransformMakeScale(CGFloat(configuration.switchZoom), CGFloat(configuration.switchZoom));
        let clipToRightTransform = CGAffineTransformMakeTranslation(CGFloat(CGRectGetWidth(switchView.frame)) * (1.0 - CGFloat(configuration.switchZoom)) / 2.0, 0.0);
        self.switchView.transform = CGAffineTransformConcat(scale, clipToRightTransform);

        switchView.enabled = configuration.enabled
    }

    // MARK: Private

    func setupStaticConstraints() {
        switchView.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        let views = [
            "switchView" : switchView,
            "leftLabel" : leftLabel
        ]
        let metrics = [
            "margin" : margin
        ]
        addConstraint(NSLayoutConstraint(item: contentView,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: switchView,
            attribute: .CenterY,
            multiplier: 1.0,
            constant: 0.0))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-margin-[leftLabel]-margin-[switchView]",
            options: .AlignAllCenterY,
            metrics: metrics,
            views: views))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[leftLabel(>=42)]|",
            options: .AlignAllLeft,
            metrics: metrics,
            views: views))
    }

    @objc func switchValueChanged(sender: UISwitch) {
        self.delegate?.boolInputTableViewCellDidChangeValue(self)
    }

}
