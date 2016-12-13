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

@objc open class FormCellTextConfiguration :FormCellConfiguration {
    open var text: String = ""
    open var textFont: UIFont? = UIFont.init(name: "HelveticaNeue-Light", size: 14.0)
    open var textColor: UIColor = UIColor.black
    open var placeholder: String = ""
    open var dateFormatter: DateFormatter?
    open var textFieldFormatter: TextFieldFormatter?
    open var formPickerDataSource: FormPickerDataSource?
    open var cellType: FormTextCellType = .email

    override public init() {
        super.init()
        tintColor = UIColor.black
    }

    override open func visit(_ configurable: FormCellConfigurable, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = configurable.textInputCellWithConfiguration(self, atIndexPath: indexPath)
        return cell
    }
}
