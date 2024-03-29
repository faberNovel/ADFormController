//
//  FormTextFieldTableViewCell.swift
//  Pods
//
//  Created by Samuel Gallet on 07/07/16.
//
//

import UIKit

class FormTextFieldTableViewCell : FormBaseTableViewCell, UITextFieldDelegate, FormTextInputTableViewCell {

    private(set) lazy var textField: FormTextField = self.createTextField()
    private lazy var leftLabel: UILabel = self.createLeftLabel()
    private lazy var datePickerBinding: DatePickerTextFieldBinding = self.createDatePickerBinding()
    private lazy var pickerViewBinding: PickerViewTextFieldBinding = self.createPickerViewBinding()
    private var textFieldFormatter: TextFieldFormatter?

    private var cellType: FormTextCellType = .email {
        didSet {
            textField.isSecureTextEntry = false
            textField.inputView = nil
            switch self.cellType {
            case .email:
                textField.keyboardType = .emailAddress
                textField.autocapitalizationType = .none
            case .password:
                textField.isSecureTextEntry = true
            case .passwordNumber:
                textField.keyboardType = .numberPad
                textField.isSecureTextEntry = true
            case .name:
                textField.keyboardType = .default
                textField.autocapitalizationType = .words
            case .phone:
                textField.keyboardType = .phonePad
            case .text:
                textField.keyboardType = .default
                textField.autocapitalizationType = .sentences
            case .number:
                textField.keyboardType = .numberPad
            case .decimal:
                textField.keyboardType = .decimalPad
            case .date:
                datePickerBinding.datePickerMode = .date
                textField.inputView = datePickerBinding.inputView
                textField.disablePasteAction = true
            case .time:
                datePickerBinding.datePickerMode = .time
                textField.inputView = datePickerBinding.inputView
                textField.disablePasteAction = true
            case .picker:
                textField.inputView = pickerViewBinding.pickerView
                textField.disablePasteAction = true
            default:
                break
            }
        }
    }

    //MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    //MARK: - UITextfieldDelegate

    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch cellType {
        case .date:
            datePickerBinding.startEditing()
        case .picker:
            pickerViewBinding.startEditing()
        default:
            break
        }
        delegate?.textInputTableViewCellDidBeginEditing(self)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let formatter = textFieldFormatter else {
            return true
        }
        return formatter.textField(textField, shouldChangeCharactersInRange: range, replacementString: string)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let delegate = delegate else {
            return true
        }
        return delegate.textInputTableViewCellShouldReturn(self)
    }

    //MARK: - FormTextInputTableViewCell

    weak var delegate: FormTextInputTableViewCellDelegate?
    private var _inputAccessoryView: UIView?
    // The FormTextInputTableViewCell require inputAccessoryView to be read write.
    // However inputAccessoryView is read only in UITableViewCell
    // So we need to pass through an other var to make it read writeu

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
            return textField.returnKeyType
        }
        set {
            textField.returnKeyType = newValue
        }
    }

    var textContent: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }

    func beginEditing() {
        textField.becomeFirstResponder()
    }

    func apply(configuration: FormCellTextConfiguration) {
        // ?!!! (Samuel Gallet) 09/11/20 Order matters here. We should set textField.font before assiging
        // attributedPlaceholder. Otherwise the texteField's font override the placeholder's font
        textField.font = configuration.textFont
        if let attributedPlaceholder = configuration.attributedPlaceholder {
            textField.placeholder = nil
            textField.attributedPlaceholder = attributedPlaceholder
        } else {
            textField.attributedPlaceholder = nil
            textField.placeholder = configuration.placeholder
        }
        leftLabel.text = configuration.title
        leftLabel.isHidden = configuration.title.isEmpty
        textField.textAlignment = leftLabel.text?.count == 0 ? .right : .left
        cellType = configuration.cellType
        rightView = configuration.rightView
        leftView = configuration.leftView

        textField.textColor = configuration.textColor
        textField.tintColor = configuration.tintColor
        leftLabel.font = configuration.titleFont
        leftLabel.textColor = configuration.titleColor

        textField.text = configuration.text
        textFieldFormatter = configuration.textFieldFormatter
        textFieldFormatter?.textFieldValueChanged(textField)
        datePickerBinding.dateFormatter = configuration.dateFormatter
        datePickerBinding.apply(configuration.datePickerConfiguration)
        pickerViewBinding.formPickerDataSource = configuration.formPickerDataSource
        textField.isEnabled = configuration.enabled
        textField.textAlignment = configuration.textAlignment
        textField.accessibilityIdentifier = configuration.textInputAccessibilityIdentifier
        textField.clearButtonMode = configuration.clearButtonMode
        hideRightViewWhenEditing = configuration.hideRightViewWhenEditing
        textField.autocorrectionType = configuration.autocorrectionType

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
        insertSubviewInStackView(textField)
    }

    private func createTextField() -> FormTextField {
        let textField = FormTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.addTarget(self, action: #selector(FormTextFieldTableViewCell.textChanged(_:)), for: .allEditingEvents)
        return textField
    }

    private func createLeftLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }

    private func createDatePickerBinding() -> DatePickerTextFieldBinding {
        return DatePickerTextFieldBinding(textField: textField)
    }

    private func createPickerViewBinding() -> PickerViewTextFieldBinding {
        return PickerViewTextFieldBinding(textField: textField)
    }

    @objc private func textChanged(_ sender: UITextField) {
        if hideRightViewWhenEditing { rightView?.isHidden = true }
        textFieldFormatter?.textFieldValueChanged(sender)
        delegate?.textInputTableViewCellValueChanged(self)
    }
}
