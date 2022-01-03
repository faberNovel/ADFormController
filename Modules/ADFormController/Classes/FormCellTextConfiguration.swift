//
//  FormCellTextConfiguration.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

@objc public enum FormTextCellType : Int {
    case email
    case password
    case name
    case phone
    case text
    case number
    case decimal
    case date
    case time
    case picker
    case longText
    case passwordNumber

    var requiredCell : UITableViewCell {
        switch self {
        case .longText:
            return FormTextViewTableViewCell(style: .default, reuseIdentifier: nil)
        default:
            return FormTextFieldTableViewCell(style: .default, reuseIdentifier: nil)
        }
    }

}

@objcMembers open class FormCellTextConfiguration : FormCellConfiguration {
    open var text: String = ""
    open var textFont: UIFont? = UIFont(name: "HelveticaNeue-Light", size: 14.0)
    open var textColor: UIColor = UIColor.black
    open var placeholder: String = ""
    open var attributedPlaceholder: NSAttributedString?
    open var dateFormatter: DateFormatter?
    open var textFieldFormatter: TextFieldFormatter?
    open var formPickerDataSource: FormPickerDataSource?
    open var cellType: FormTextCellType = .email
    open var inputAccessoryView: UIView? = nil
    open var datePickerConfiguration: ((UIDatePicker) -> Void)?
    open var returnKeyType: UIReturnKeyType?
    /// Return true if the text field should implement its default behavior for the return button; otherwise, false.
    open var returnAction: (() -> Bool)?
    open var textInputAccessibilityIdentifier: String?
    open var clearButtonMode: UITextField.ViewMode = .never
    open lazy var autocorrectionType: UITextAutocorrectionType = createDefaultAutoCorrectionType()

    override public init() {
        super.init()
        tintColor = UIColor.black
    }

    override open func visit(_ configurable: FormCellConfigurable, at indexPath: IndexPath) -> UITableViewCell {
        let cell = configurable.textInputCell(with: self, at: indexPath)
        return cell
    }

    // MARK: - Private

    private func createDefaultAutoCorrectionType() -> UITextAutocorrectionType {
        switch cellType {
        case .email, .password, .name, .phone, .date, .time, .picker, .passwordNumber:
            return .no
        case .text, .number, .decimal, .longText:
            return .default
        }
    }
}
