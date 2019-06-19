//
//  FormTextViewTableViewCell.swift
//  Pods
//
//  Created by Samuel Gallet on 07/07/16.
//
//

import UIKit

class FormTextViewTableViewCell : FormBaseTableViewCell, UITextViewDelegate, FormTextInputTableViewCell {

    private lazy var textView: UITextView = self.createTextView()
    private lazy var titleLabel: UILabel = self.createTitleLabel()

    // MARK: - FormBaseTableViewCell

    override var defaultContentInset: UIEdgeInsets {
        return UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
    }

    //MARK: - UITableViewCell

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    //MARK: - UIView

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    //MARK: - UITextViewDelegate

    func textViewDidBeginEditing(_ textView: UITextView) {
        if hideRightViewWhenEditing { rightView?.isHidden = true }
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
        titleLabel.isHidden = configuration.title.isEmpty

        rightView = configuration.rightView
        leftView = configuration.leftView

        textView.font = configuration.textFont
        textView.textColor = configuration.textColor
        textView.tintColor = configuration.tintColor
        textView.text = configuration.text
        textView.accessibilityIdentifier = configuration.textInputAccessibilityIdentifier
        hideRightViewWhenEditing = configuration.hideRightViewWhenEditing
        if let placeholderTextView = textView as? PlaceholderTextView {
            placeholderTextView.placeholder = configuration.placeholder
        }
        textView.isEditable = configuration.enabled
        textView.isSelectable = configuration.enabled
        if let separatorInset = configuration.separatorInset {
            self.separatorInset = separatorInset
        }
        if let contentInset = configuration.contentInset {
            updateStackViewConstraints(with: contentInset)
        }
    }

    //MARK: - Private

    private func setup() {
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8.0
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(textView)
        insertSubviewInStackView(verticalStackView)
    }

    private func createTextView() -> UITextView {
        let placeholderTextView = PlaceholderTextView()
        placeholderTextView.textContainerInset = UIEdgeInsets.zero
        placeholderTextView.textContainer.lineFragmentPadding = 0
        placeholderTextView.translatesAutoresizingMaskIntoConstraints = false
        placeholderTextView.delegate = self
        return placeholderTextView
    }

    private func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }
}
