//
//  FormTextViewTableViewCell.swift
//  Pods
//
//  Created by Samuel Gallet on 07/07/16.
//
//

import UIKit

class FormTextViewTableViewCell : UITableViewCell, UITextViewDelegate, FormTextInputTableViewCell {

    private lazy var textView: UITextView = self.createTextView()
    private lazy var titleLabel: UILabel = self.createTitleLabel()
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

    //MARK: - UIView

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
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
        titleLabel.isHidden = configuration.title.isEmpty

        rightView = configuration.rightView
        leftView = configuration.leftView

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
        if let contentInset = configuration.contentInset {
            updateStackViewConstraints(with: contentInset)
        }
    }

    //MARK: - Private

    private func setup() {
        selectionStyle = .none
        layoutMargins = UIEdgeInsets.zero
        separatorInset = UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 0)
        updateStackViewConstraints(with: UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0))
        stackView.addArrangedSubview(leftContainerView)
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8.0
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(textView)
        stackView.addArrangedSubview(verticalStackView)
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

    private func createStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8.0
        return stackView
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

    private func createAccessoryContainerView() -> UIView {
        let view = UIView()
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        return view
    }
}
