//
//  FormTextFieldTableViewCell.swift
//  Pods
//
//  Created by Samuel Gallet on 07/07/16.
//
//

import UIKit

private struct Constants {
    static let leftLabelKeyPath: String = "leftLabel.text"
}

class FormTextFieldTableViewCell : UITableViewCell, UITextFieldDelegate, FormTextInputTableViewCell {
    let textField: FormTextField = {
        let textField = FormTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    } ()
    let leftLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        return label
    } ()
    var rightView: UIView? {
        willSet {
            guard let rightView = self.rightView else {
                return
            }
            rightView.removeFromSuperview()
        }
        didSet {
            guard let rightView = self.rightView else {
                return
            }
            rightView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(rightView)
            setNeedsUpdateConstraints()
        }
    }
    var textFieldFormatter: TextFieldFormatter?
    lazy private var datePickerBinding: DatePickerTextFieldBinding = {
        return DatePickerTextFieldBinding(textField: self.textField)
    } ()
    lazy private var pickerViewBinding: PickerViewTextFieldBinding = {
        return PickerViewTextFieldBinding(textField: self.textField)
    } ()
    private var dynamicConstraints: [NSLayoutConstraint] = []
    private var cellType: FormTextCellType = .email {
        didSet {
            textField.isSecureTextEntry = false
            switch self.cellType {
            case .email:
                textField.keyboardType = .emailAddress;
                textField.autocapitalizationType = .none;
                textField.autocorrectionType = .no;
            case .password:
                textField.isSecureTextEntry = true
            case .passwordNumber:
                textField.keyboardType = .numberPad;
                textField.isSecureTextEntry = true
            case .name:
                textField.keyboardType = .asciiCapable;
                textField.autocapitalizationType = .words;
                textField.autocorrectionType = .no;
            case .phone:
                textField.keyboardType = .phonePad;
            case .text:
                textField.keyboardType = .asciiCapable;
                textField.autocapitalizationType = .sentences;
                textField.autocorrectionType = .default;
            case .number:
                textField.keyboardType = .numberPad;
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

    // MARK: UIView
    override func updateConstraints() {
        self.contentView.removeConstraints(dynamicConstraints)
        dynamicConstraints.removeAll()
        var views = [
            "textField" : textField,
            "leftLabel" : leftLabel
        ]
        if let rightView = rightView {
            let metrics = [
                "rightViewWidth" : rightView.bounds.width,
                "rightViewHeight" : rightView.bounds.height
            ]
            views["rightView"] = rightView
            dynamicConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:[textField]-[rightView(rightViewWidth)]|",
                options: .alignAllCenterY,
                metrics: metrics,
                views: views))
            dynamicConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:[rightView(rightViewHeight)]",
                options: .alignAllLeft,
                metrics: metrics,
                views: views))
        } else {
            dynamicConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:[textField]-15-|",
                options: .alignAllCenterY,
                metrics: nil,
                views: views))
        }

        if let count = leftLabel.text?.characters.count, count > 0 {
            dynamicConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[leftLabel]-[textField]",
                options: .alignAllCenterY,
                metrics: nil,
                views: views))
            dynamicConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[leftLabel]|",
                options: .alignAllLeft,
                metrics: nil,
                views: views))
        } else {
            dynamicConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[textField]",
                options: .alignAllCenterY,
                metrics: nil,
                views: views))
        }
        contentView.addConstraints(dynamicConstraints)
        super.updateConstraints()
    }

    // MARK: UITableViewCell

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        textField.delegate = self
        textField.addTarget(self, action: #selector(FormTextFieldTableViewCell.textChanged(_:)), for: .allEditingEvents)
        contentView.addSubview(textField)
        contentView.addSubview(leftLabel)
        addObserver(self, forKeyPath: Constants.leftLabelKeyPath, options: .new, context: nil)
        layoutMargins = UIEdgeInsets.zero
        separatorInset = UIEdgeInsetsMake(0, 15.0, 0, 0)
        let views = [
            "textField" : textField
        ]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[textField]|", options: .alignAllLeft, metrics: nil, views: views))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    // MARK: NSObject
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == Constants.leftLabelKeyPath {
            textField.textAlignment = textLabel?.text?.characters.count == 0 ? .right : .left
            setNeedsUpdateConstraints()
        }
    }

    deinit {
        removeObserver(self, forKeyPath: Constants.leftLabelKeyPath)
    }

    // MARK: UITextfieldDelegate
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

    // MARK: FormTextInputTableViewCell
    weak var delegate: FormTextInputTableViewCellDelegate?
    private var _inputAccessoryView: UIView?
    // The FormTextInputTableViewCell require inputAccessoryView to be read write. However inputAccessoryView is read only in UITableViewCell
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
        textField.placeholder = configuration.placeholder
        leftLabel.text = configuration.title
        cellType = configuration.cellType
        rightView = configuration.rightView

        textField.font = configuration.textFont
        textField.textColor = configuration.textColor
        textField.tintColor = configuration.tintColor
        leftLabel.font = configuration.titleFont
        leftLabel.textColor = configuration.titleColor

        textField.text = configuration.text
        textFieldFormatter = configuration.textFieldFormatter
        textFieldFormatter?.textFieldValueChanged(textField)
        datePickerBinding.dateFormatter = configuration.dateFormatter
        pickerViewBinding.formPickerDataSource = configuration.formPickerDataSource
        textField.isEnabled = configuration.enabled
        textField.textAlignment = configuration.textAlignment

        if let separatorInset = configuration.separatorInset {
            self.separatorInset = separatorInset
        }
    }

    // MARK: Private
    @objc private func textChanged(_ sender: UITextField) {
        textFieldFormatter?.textFieldValueChanged(sender)
        delegate?.textInputTableViewCellValueChanged(self)
    }
}
