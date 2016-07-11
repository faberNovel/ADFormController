//
//  FormConfiguration.swift
//  FormDemo
//
//  Created by Samuel Gallet on 04/07/16.
//
//

import UIKit
import ADFormController

protocol RowConfigurable {
    var title: String { get }

    func formCellConfiguration(showTitle: Bool, model: FormModel, prefilled: Bool, accessoryView: UIView, passwordVisible: Bool) -> FormCellConfiguration?
}

enum RowType: Int {
    case RowTypeGender = 0
    case RowTypeName
    case RowTypeEmail
    case RowTypePhoneNumber
    case RowTypeLongText
    case RowTypeDate
    case RowTypeSwitch
    case RowTypeNoInputAccessory

    static var count: Int { return RowType.RowTypeNoInputAccessory.hashValue + 1}
}

extension RowType: RowConfigurable {
    var title: String {
        return "Profile"
    }

    var rowHeight: Float {
        switch self {
        case .RowTypeLongText:
            return 100.0
        default:
            return 44.0
        }
    }

    func formCellConfiguration(showTitle: Bool, model: FormModel, prefilled: Bool, accessoryView: UIView, passwordVisible: Bool) -> FormCellConfiguration? {
        switch self {
        case RowTypeGender:
            let configuration = FormCellTextConfiguration();
            configuration.placeholder = "Gender"
            configuration.cellType = .Picker
            configuration.formPickerDataSource = SimpleFormPickerDataSource(options: ["Male", "Female"])
            configuration.text = model.gender;
            if showTitle {
                configuration.title = "Gender"
            }
            return configuration
        case RowTypeName:
            let configuration = FormCellTextConfiguration();
            configuration.placeholder = "Name"
            configuration.cellType = .Name
            configuration.text = model.name;
            if showTitle {
                configuration.title = "Name"
            }
            return configuration
        case RowTypeEmail:
            let configuration = FormCellTextConfiguration();
            configuration.placeholder = "Email"
            configuration.cellType = .Email
            configuration.text = model.email;
            if showTitle {
                configuration.title = "Email"
            }
            return configuration
        case RowTypePhoneNumber:
            let configuration = FormCellTextConfiguration();
            configuration.placeholder = "Phone"
            configuration.cellType = .Phone
            configuration.text = model.phone;
            if showTitle {
                configuration.title = "Phone"
            }
            return configuration
        case RowTypeLongText:
            let configuration = FormCellTextConfiguration();
            configuration.placeholder = "Long text"
            configuration.cellType = .LongText
            configuration.text = model.summary;
            if showTitle {
                configuration.title = "Long text"
            }
            return configuration
        case RowTypeDate:
            let configuration = FormCellTextConfiguration();
            configuration.placeholder = "Date"
            configuration.cellType = .Date
            configuration.dateFormatter = TestFormViewController.dateFormatter
            if let text = model.birthDate.map({TestFormViewController.dateFormatter.stringFromDate($0)}) {
                configuration.text = text
            }
            if showTitle {
                configuration.title = "Date"
            }
            return configuration
        case RowTypeSwitch:
            let configuration = FormCellBoolConfiguration();
            configuration.title = "Maried"
            configuration.onTintColor = UIColor.greenColor()
            configuration.tintColor = UIColor.redColor()
            configuration.switchZoom = 0.65;
            configuration.boolValue = model.married
            if showTitle {
                configuration.title = "Maried"
            }
            return configuration
        case RowTypeNoInputAccessory:
            let configuration = FormCellTextConfiguration();
            configuration.placeholder = "Useless row with no input accessory"
            configuration.cellType = .Name
            if showTitle {
                configuration.title = "No accessory here"
            }
            return configuration
        }
    }
}

enum CreditCardRowType: Int {
    case CreditCardRowTypeNumber = 0
    case CreditCardRowTypeExpirationDate

    static var count: Int { return CreditCardRowType.CreditCardRowTypeExpirationDate.hashValue + 1}
}

extension CreditCardRowType: RowConfigurable {
    var title: String {
        return "Credit card"
    }

    func formCellConfiguration(showTitle: Bool, model: FormModel, prefilled: Bool, accessoryView: UIView, passwordVisible: Bool) -> FormCellConfiguration? {
        switch self {
        case CreditCardRowTypeNumber:
            let configuration = FormCellTextConfiguration();
            configuration.placeholder = "Credit card"
            configuration.cellType = .Number
            configuration.textFieldFormatter = CreditCardTextFieldFormatter()
            configuration.text = model.creditCard;
            if showTitle {
                configuration.title = "Credit card"
            }
            return configuration
        case CreditCardRowTypeExpirationDate:
            let configuration = FormCellTextConfiguration();
            configuration.placeholder = "Expiration Date"
            configuration.cellType = .Picker
            configuration.formPickerDataSource = ExpirationDatePickerDataSource()
            configuration.text = model.expiration;
            if showTitle {
                configuration.title = "Expiration Date"
            }
            return configuration
        }
    }
}

enum PasswordRowType: Int {
    case PasswordRowTypeNewPassword
    case PasswordRowTypeNewPasswordConfirmation

    static var count: Int { return PasswordRowType.PasswordRowTypeNewPasswordConfirmation.hashValue + 1}
}

extension PasswordRowType: RowConfigurable {
    var title: String {
        return "Password"
    }

    func formCellConfiguration(showTitle: Bool, model: FormModel, prefilled: Bool, accessoryView: UIView, passwordVisible: Bool) -> FormCellConfiguration? {
        switch self {
        case PasswordRowTypeNewPassword:
            let configuration = FormCellTextConfiguration();
            configuration.placeholder = "New password"
            if !passwordVisible {
                configuration.cellType = .Password
            }
            if showTitle {
                configuration.title = "New password"
            }
            if prefilled {
                configuration.text = "abcdef"
            }
            configuration.rightView = accessoryView
            return configuration
        case PasswordRowTypeNewPasswordConfirmation:
            let configuration = FormCellTextConfiguration();
            configuration.placeholder = "Confirmation"
            configuration.cellType = .Password
            if showTitle {
                configuration.title = "Confirmation"
            }
            if prefilled {
                configuration.text = "abcdef"
            }
            return configuration
        }
    }
}