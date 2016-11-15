//
//  FormCellTextConfiguration.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

@objc public enum FormTextCellType : Int {
    case Email
    case Password
    case Name
    case Phone
    case Text
    case Number
    case Decimal
    case Date
    case Picker
    case LongText
    case PasswordNumber

    var requiredCell : UITableViewCell {
        switch self {
        case .LongText:
            return FormTextViewTableViewCell(style: .Default, reuseIdentifier: nil)
        default:
            return FormTextFieldTableViewCell(style: .Default, reuseIdentifier: nil)
        }
    }

}

@objc public class FormCellTextConfiguration :FormCellConfiguration {
    public var text: String = ""
    public var textFont: UIFont? = UIFont.init(name: "HelveticaNeue-Light", size: 14.0)
    public var textColor: UIColor = UIColor.blackColor()
    public var placeholder: String = ""
    public var dateFormatter: NSDateFormatter?
    public var textFieldFormatter: TextFieldFormatter?
    public var formPickerDataSource: FormPickerDataSource?
    public var cellType: FormTextCellType = .Email

    override public init() {
        super.init()
        tintColor = UIColor.blackColor()
    }

    override public func visit(configurable: FormCellConfigurable, atIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = configurable.textInputCellWithConfiguration(self, atIndexPath: indexPath)
        return cell
    }
}
