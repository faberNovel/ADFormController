//
//  FormTextViewTableViewCell.swift
//  Pods
//
//  Created by Samuel Gallet on 07/07/16.
//
//

import UIKit

private struct Constants {
    static let titleLabelKeyPath = "titleLabel.text"
}

class FormTextViewTableViewCell : UITableViewCell, UITextViewDelegate, FormTextInputTableViewCell {

    private lazy var textView: UITextView = self.createTextView()
    @objc private dynamic lazy var titleLabel: UILabel = self.createTitleLabel() // dynamic for KVO
    private var dynamicConstraints: [NSLayoutConstraint] = []

    //MARK: - NSObject

    deinit {
        removeObserver(self, forKeyPath: Constants.titleLabelKeyPath)
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == Constants.titleLabelKeyPath {
            self .setNeedsUpdateConstraints()
        }
    }

    //MARK: - UITableViewCell

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        textView.delegate = self
        contentView.addSubview(textView)
        contentView.addSubview(titleLabel)
        separatorInset = UIEdgeInsetsMake(0, 15, 0, 0)
        addObserver(self, forKeyPath: Constants.titleLabelKeyPath, options: .new, context: nil)
        let views = [
            "placeholderTextView": textView
        ]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[placeholderTextView]-15-|", options: .alignAllCenterY, metrics: nil, views: views))
        layoutMargins = UIEdgeInsets.zero
    }

    //MARK: - UIView

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func updateConstraints() {
        contentView.removeConstraints(dynamicConstraints)
        dynamicConstraints.removeAll()

        let views: [String: Any] = [
            "titleLabel": titleLabel,
            "placeholderTextView": textView,
        ]
        if let count = titleLabel.text?.count, count > 0 {
            dynamicConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[titleLabel]-[placeholderTextView]-15-|", options: .alignAllLeft, metrics: nil, views: views))
            dynamicConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[titleLabel]-15-|", options: .alignAllCenterY, metrics: nil, views: views))
        } else {
            dynamicConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[placeholderTextView]-15-|", options: .alignAllLeft, metrics: nil, views: views))
        }

        contentView.addConstraints(dynamicConstraints)
        super.updateConstraints()
    }

    //MARK: - UITextViewDelegate

    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.textInputTableViewCellDidBeginEditing(self)
    }

    func textViewDidChange(_ textView: UITextView) {
        delegate?.textInputTableViewCellValueChanged(self)
    }

    //MARK: - FormTextInputTableViewCell

    weak var delegate: FormTextInputTableViewCellDelegate?

    var textContent: String? {
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

    override var inputAccessoryView: UIView? {
        get {
            return _inputAccessoryView
        }
        set {
            _inputAccessoryView = newValue
        }
    }

    var returnKeyType: UIReturnKeyType {
        get {
            return textView.returnKeyType
        }
        set {
            // no operation
        }
    }

    func beginEditing() {
        textView.becomeFirstResponder()
    }

    func apply(configuration: FormCellTextConfiguration) {
        titleLabel.text = configuration.title

        titleLabel.font = configuration.titleFont
        titleLabel.textColor = configuration.titleColor

        textView.font = configuration.textFont
        textView.textColor = configuration.textColor
        textView.tintColor = configuration.tintColor
        textView.text = configuration.text
        if let placeholderTextView = textView as? PlaceholderTextView {
            placeholderTextView.placeholder = configuration.placeholder
        }
        textView.isEditable = configuration.enabled
        if let separatorInset = configuration.separatorInset {
            self.separatorInset = separatorInset
        }
    }

    //MARK: - Private

    private func createTextView() -> UITextView {
        let placeholderTextView = PlaceholderTextView()
        placeholderTextView.textContainerInset = UIEdgeInsets.zero
        placeholderTextView.textContainer.lineFragmentPadding = 0
        placeholderTextView.translatesAutoresizingMaskIntoConstraints = false
        return placeholderTextView
    }

    private func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }
}
