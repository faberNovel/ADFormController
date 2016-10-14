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
        label.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
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
    lazy private var datePickerBinding: DatePickerTextFieldBinging = {
        return DatePickerTextFieldBinging(textField: self.textField)
    } ()
    lazy private var pickerViewBinding: PickerViewTextFieldBinding = {
        return PickerViewTextFieldBinding(textField: self.textField)
    } ()
    private var dynamicConstraints: [NSLayoutConstraint] = []
    private var cellType: FormTextCellType = .Email {
        didSet {
            textField.secureTextEntry = false
            switch self.cellType {
            case .Email:
                textField.keyboardType = .EmailAddress;
                textField.autocapitalizationType = .None;
                textField.autocorrectionType = .No;
            case .Password:
                textField.secureTextEntry = true
            case .PasswordNumber:
                textField.keyboardType = .NumberPad;
                textField.secureTextEntry = true
            case .Name:
                textField.keyboardType = .ASCIICapable;
                textField.autocapitalizationType = .Words;
                textField.autocorrectionType = .No;
            case .Phone:
                textField.keyboardType = .PhonePad;
            case .Text:
                textField.keyboardType = .ASCIICapable;
                textField.autocapitalizationType = .Sentences;
                textField.autocorrectionType = .Default;
            case .Number:
                textField.keyboardType = .NumberPad;
            case .Date:
                textField.inputView = datePickerBinding.datePicker
                textField.disablePasteAction = true
            case .Picker:
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
                "rightViewWidth" : CGRectGetWidth(rightView.bounds),
                "rightViewHeight" : CGRectGetHeight(rightView.bounds)
            ]
            views["rightView"] = rightView
            dynamicConstraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("H:[textField]-[rightView(rightViewWidth)]|",
                options: .AlignAllCenterY,
                metrics: metrics,
                views: views))
            dynamicConstraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("V:[rightView(rightViewHeight)]",
                options: .AlignAllLeft,
                metrics: metrics,
                views: views))
        } else {
            dynamicConstraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("H:[textField]-15-|",
                options: .AlignAllCenterY,
                metrics: nil,
                views: views))
        }

        if leftLabel.text?.characters.count > 0 {
            dynamicConstraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[leftLabel]-[textField]",
                options: .AlignAllCenterY,
                metrics: nil,
                views: views))
            dynamicConstraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("V:|[leftLabel]|",
                options: .AlignAllLeft,
                metrics: nil,
                views: views))
        } else {
            dynamicConstraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[textField]",
                options: .AlignAllCenterY,
                metrics: nil,
                views: views))
        }
        contentView.addConstraints(dynamicConstraints)
        super.updateConstraints()
    }

    // MARK: UITableViewCell

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        textField.delegate = self
        textField.addTarget(self, action: #selector(FormTextFieldTableViewCell.textChanged(_:)), forControlEvents: .AllEditingEvents)
        contentView.addSubview(textField)
        contentView.addSubview(leftLabel)
        addObserver(self, forKeyPath: Constants.leftLabelKeyPath, options: .New, context: nil)
        layoutMargins = UIEdgeInsetsZero
        separatorInset = UIEdgeInsetsMake(0, 15.0, 0, 0)
        let views = [
            "textField" : textField
        ]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[textField]|", options: .AlignAllLeft, metrics: nil, views: views))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    // MARK: NSObject
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == Constants.leftLabelKeyPath {
            textField.textAlignment = textLabel?.text?.characters.count == 0 ? .Right : .Left
            setNeedsUpdateConstraints()
        }
    }

    deinit {
        removeObserver(self, forKeyPath: Constants.leftLabelKeyPath)
    }

    // MARK: UITextfieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        switch cellType {
        case .Date:
            datePickerBinding.startEditing()
        case .Picker:
            pickerViewBinding.startEditing()
        default:
            break
        }
        delegate?.textInputTableViewCellDidBeginEditing(self)
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let formatter = textFieldFormatter else {
            return true
        }
        return formatter.textField(textField, shouldChangeCharactersInRange: range, replacementString: string)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
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

    func applyConfiguration(configuration: FormCellTextConfiguration) {
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
        textField.enabled = configuration.enabled
    }

    // MARK: Private
    @objc private func textChanged(sender: UITextField) {
        textFieldFormatter?.textFieldValueChanged(sender)
        delegate?.textInputTableViewCellValueChanged(self)
    }
}
