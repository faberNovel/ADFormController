//
//  FormTextViewTableViewCell.swift
//  Pods
//
//  Created by Samuel Gallet on 07/07/16.
//
//

import UIKit

private struct Constants {
    static let titleLabelKeyPath: String = "titleLabel.text"
}

@objc public class FormTextViewTableViewCell : UITableViewCell, UITextViewDelegate, FormTextInputTableViewCell {
    public let textView: UITextView = {
        let placeholderTextView = PlaceholderTextView()
        placeholderTextView.textContainerInset = UIEdgeInsetsZero;
        placeholderTextView.textContainer.lineFragmentPadding = 0;
        placeholderTextView.translatesAutoresizingMaskIntoConstraints = false;
        return placeholderTextView
    } ()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        return label
    } ()
    private var dynamicConstraints: [NSLayoutConstraint] = []

    // MARK: NSObject
    deinit {
        removeObserver(self, forKeyPath: Constants.titleLabelKeyPath)
    }

    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == Constants.titleLabelKeyPath {
            self .setNeedsUpdateConstraints()
        }
    }

    // MARK: UITableViewCell

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        textView.delegate = self
        contentView.addSubview(textView)
        contentView.addSubview(titleLabel)
        separatorInset = UIEdgeInsetsMake(0, 15, 0, 0)
        addObserver(self, forKeyPath: Constants.titleLabelKeyPath, options: .New, context: nil)
        let views = [
            "placeholderTextView" : textView
        ]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[placeholderTextView]-15-|", options: .AlignAllCenterY, metrics: nil, views: views))
        layoutMargins = UIEdgeInsetsZero
    }

    // MARK: UIView

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func updateConstraints() {
        contentView.removeConstraints(dynamicConstraints)
        dynamicConstraints.removeAll()

        let views = [
            "titleLabel" : titleLabel,
            "placeholderTextView" : textView,
        ]
        if titleLabel.text?.characters.count > 0 {
            dynamicConstraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[titleLabel]-[placeholderTextView]-15-|", options: .AlignAllLeft, metrics: nil, views: views))
            dynamicConstraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[titleLabel]-15-|", options: .AlignAllCenterY, metrics: nil, views: views))
        } else {
            dynamicConstraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[placeholderTextView]-15-|", options: .AlignAllLeft, metrics: nil, views: views))
        }

        contentView.addConstraints(dynamicConstraints)
        super.updateConstraints()
    }

    // MARK: UITextViewdelegate

    public func textViewDidBeginEditing(textView: UITextView) {
        delegate?.textInputTableViewCellDidBeginEditing(self)
    }

    public func textViewDidChange(textView: UITextView) {
        delegate?.textInputTableViewCellValueChanged(self)
    }

    // MARK: FormTextInputTableViewCell
    public weak var delegate: FormTextInputTableViewCellDelegate?
    public var textContent: String? {
        get {
            return textView.text
        }
        set {
            guard let text = newValue else {
                return
            }
            textView.text = text
        }
    }
    private var _inputAccessoryView: UIView?
    override public var inputAccessoryView: UIView? {
        get {
            return _inputAccessoryView
        }
        set {
            _inputAccessoryView = newValue
        }
    }
    public var returnKeyType: UIReturnKeyType {
        get {
            return textView.returnKeyType
        }
        set {
            // no operation
        }
    }

    public func beginEditing() {
        textView.becomeFirstResponder()
    }

    public func applyConfiguration(configuration: ADFormCellTextConfiguration) {
        titleLabel.text = configuration.title

        titleLabel.font = configuration.titleFont
        titleLabel.textColor = configuration.titleColor

        textView.font = configuration.textFont
        textView.textColor = configuration.textColor
        textView.tintColor = configuration.tintColor
        textView.text = configuration.text
        (textView as! PlaceholderTextView).placeholder = configuration.placeholder
    }
}
