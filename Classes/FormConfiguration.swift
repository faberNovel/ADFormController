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

    func formCellConfiguration(showTitle: Bool, model: FormModel, prefilled: Bool, accessoryView: UIView) -> ADFormCellConfiguration?
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

    func formCellConfiguration(showTitle: Bool, model: FormModel, prefilled: Bool, accessoryView: UIView) -> ADFormCellConfiguration? {
        switch self {
        case RowTypeGender:
            let configuration = ADFormCellTextConfiguration();
            configuration.placeholder = "Gender"
            configuration.cellType = .Picker
            configuration.formPickerDataSource = ADSimpleFormPickerDataSource(options: ["Male", "Female"])
            configuration.text = model.gender;
            if showTitle {
                configuration.title = "Gender"
            }
            return configuration
        case RowTypeName:
            let configuration = ADFormCellTextConfiguration();
            configuration.placeholder = "Name"
            configuration.cellType = .Name
            configuration.text = model.name;
            if showTitle {
                configuration.title = "Name"
            }
            return configuration
        case RowTypeEmail:
            let configuration = ADFormCellTextConfiguration();
            configuration.placeholder = "Email"
            configuration.cellType = .Email
            configuration.text = model.email;
            if showTitle {
                configuration.title = "Email"
            }
            return configuration
        case RowTypePhoneNumber:
            let configuration = ADFormCellTextConfiguration();
            configuration.placeholder = "Phone"
            configuration.cellType = .Phone
            configuration.text = model.phone;
            if showTitle {
                configuration.title = "Phone"
            }
            return configuration
        case RowTypeLongText:
            let configuration = ADFormCellTextConfiguration();
            configuration.placeholder = "Long text"
            configuration.cellType = .LongText
            configuration.text = model.summary;
            if showTitle {
                configuration.title = "Long text"
            }
            return configuration
        case RowTypeDate:
            let configuration = ADFormCellTextConfiguration();
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
            let configuration = ADFormCellBoolConfiguration();
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
            let configuration = ADFormCellTextConfiguration();
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

    func formCellConfiguration(showTitle: Bool, model: FormModel, prefilled: Bool, accessoryView: UIView) -> ADFormCellConfiguration? {
        switch self {
        case CreditCardRowTypeNumber:
            let configuration = ADFormCellTextConfiguration();
            configuration.placeholder = "Credit card"
            configuration.cellType = .Number
            //TODO: (Samuel Gallet) 04/07/2016 Set formatter
            configuration.text = model.creditCard;
            if showTitle {
                configuration.title = "Credit card"
            }
            return configuration
        case CreditCardRowTypeExpirationDate:
            let configuration = ADFormCellTextConfiguration();
            configuration.placeholder = "Expiration Date"
            configuration.cellType = .Picker
            //TODO: (Samuel Gallet) 04/07/2016 Set picker
            configuration.text = model.expiration;
            if showTitle {
                configuration.title = "Expiration Date"
            }
            return configuration
        }
    }
}

enum PassworkRowType: Int {
    case PasswordRowTypeNewPassword
    case PasswordRowTypeNewPasswordConfirmation

    static var count: Int { return PassworkRowType.PasswordRowTypeNewPasswordConfirmation.hashValue + 1}
}

extension PassworkRowType: RowConfigurable {
    var title: String {
        return "Password"
    }

    func formCellConfiguration(showTitle: Bool, model: FormModel, prefilled: Bool, accessoryView: UIView) -> ADFormCellConfiguration? {
        switch self {
        case PasswordRowTypeNewPassword:
            let configuration = ADFormCellTextConfiguration();
            configuration.placeholder = "New password"
            configuration.cellType = .Number
            if showTitle {
                configuration.title = "New password"
            }
            if prefilled {
                configuration.text = "abcdef"
            }
            configuration.rightView = accessoryView
            return configuration
        case PasswordRowTypeNewPasswordConfirmation:
            let configuration = ADFormCellTextConfiguration();
            configuration.placeholder = "Confirmation"
            configuration.cellType = .Number
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