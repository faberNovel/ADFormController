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

    func formCellConfiguration(showTitle: Bool,
                               model: FormModel,
                               accessoryView: UIView,
                               passwordVisible: Bool,
                               enabled: Bool,
                               useCustomReturnAction: Bool,
                               alignment: NSTextAlignment,
                               separatorInset: UIEdgeInsets?) -> FormCellConfiguration?
}

enum RowType: Int, CaseIterable {
    case gender = 0
    case name
    case email
    case phoneNumber
    case longText
    case disabled
    case date
    case time
    case `switch`
    case noInputAccessory
}

extension RowType: RowConfigurable {
    var title: String {
        return "Profile"
    }

    var rowHeight: Float {
        switch self {
        case .longText:
            return 100.0
        default:
            return 44.0
        }
    }

    func formCellConfiguration(showTitle: Bool,
                               model: FormModel,
                               accessoryView: UIView,
                               passwordVisible: Bool,
                               enabled: Bool,
                               useCustomReturnAction: Bool,
                               alignment: NSTextAlignment,
                               separatorInset: UIEdgeInsets?) -> FormCellConfiguration? {
        switch self {
        case .gender:
            let configuration = FormCellTextConfiguration()
            configuration.placeholder = "Gender"
            configuration.cellType = .picker
            configuration.formPickerDataSource = SimpleFormPickerDataSource(options: ["Male", "Female"])
            configuration.text = model.gender
            if showTitle {
                configuration.title = "Gender"
            }
            configuration.enabled = enabled
            configuration.textAlignment = alignment
            configuration.separatorInset = separatorInset
            return configuration
        case .name:
            let configuration = FormCellTextConfiguration()
            configuration.attributedPlaceholder = NSAttributedString(
                string: "Name",
                attributes: [
                    .font: UIFont.boldSystemFont(ofSize: 14.0)
                ]
            )
            configuration.cellType = .name
            configuration.text = model.name
            if showTitle {
                configuration.title = "Name"
            }
            configuration.enabled = enabled
            configuration.textAlignment = alignment
            configuration.separatorInset = separatorInset
            if useCustomReturnAction {
                configuration.returnKeyType = .search
                configuration.returnAction = {
                    DDLogInfo("Custom action => SEARCH")
                    return true
                }
            }
            return configuration
        case .email:
            let configuration = FormCellTextConfiguration()
            configuration.placeholder = "Email"
            configuration.cellType = .email
            configuration.text = model.email
            if showTitle {
                configuration.title = "Email"
            }
            configuration.enabled = enabled
            configuration.textAlignment = alignment
            configuration.separatorInset = separatorInset
            return configuration
        case .phoneNumber:
            let configuration = FormCellTextConfiguration()
            configuration.placeholder = "Phone"
            configuration.cellType = .phone
            configuration.text = model.phone
            if showTitle {
                configuration.title = "Phone"
            }
            configuration.enabled = enabled
            configuration.textAlignment = alignment
            configuration.separatorInset = separatorInset
            return configuration
        case .longText:
            let configuration = FormCellTextConfiguration()
            configuration.placeholder = "Long text"
            configuration.cellType = .longText
            configuration.text = model.summary
            if showTitle {
                configuration.title = "Long text"
            }
            configuration.enabled = enabled
            configuration.textAlignment = alignment
            configuration.separatorInset = separatorInset
            return configuration
        case .disabled:
            let configuration = FormCellTextConfiguration()
            configuration.placeholder = "Disabled"
            configuration.cellType = .text
            if showTitle {
                configuration.title = "Disabled"
            }
            configuration.enabled = false
            configuration.textAlignment = alignment
            configuration.separatorInset = separatorInset
            return configuration
        case .date:
            let configuration = FormCellTextConfiguration()
            configuration.placeholder = "Date"
            configuration.cellType = .date
            configuration.dateFormatter = TestFormViewController.dateFormatter
            if let text = model.birthDate.map({TestFormViewController.dateFormatter.string(from: $0)}) {
                configuration.text = text
            }
            if showTitle {
                configuration.title = "Date"
            }
            configuration.enabled = enabled
            configuration.textAlignment = alignment
            configuration.separatorInset = separatorInset
            configuration.datePickerConfiguration = { datePicker in
                datePicker.maximumDate = Date()
            }
            return configuration
        case .time:
            let configuration = FormCellTextConfiguration()
            configuration.placeholder = "Time"
            configuration.cellType = .time
            configuration.dateFormatter = TestFormViewController.timeFormatter
            if let text = model.birthDate.map({TestFormViewController.timeFormatter.string(from: $0)}) {
                configuration.text = text
            }
            if showTitle {
                configuration.title = "Time"
            }
            configuration.enabled = enabled
            configuration.textAlignment = alignment
            configuration.separatorInset = separatorInset
            return configuration
        case .switch:
            let configuration = FormCellBoolConfiguration()
            configuration.title = "Maried"
            configuration.onTintColor = UIColor.green
            configuration.tintColor = UIColor.red
            configuration.switchZoom = 0.65
            configuration.boolValue = model.married
            if showTitle {
                configuration.title = "Maried"
            }
            configuration.enabled = enabled
            configuration.textAlignment = alignment
            configuration.separatorInset = separatorInset
            return configuration
        case .noInputAccessory:
            let configuration = FormCellTextConfiguration()
            configuration.placeholder = "Useless row with no input accessory"
            configuration.cellType = .name
            if showTitle {
                configuration.title = "No accessory here"
            }
            configuration.enabled = enabled
            configuration.textAlignment = alignment
            configuration.separatorInset = separatorInset
            return configuration
        }
    }
}

enum CreditCardRowType: Int, CaseIterable {
    case number = 0
    case expirationDate
}

extension CreditCardRowType: RowConfigurable {
    var title: String {
        return "Credit card"
    }

    func formCellConfiguration(showTitle: Bool,
                               model: FormModel,
                               accessoryView: UIView,
                               passwordVisible: Bool,
                               enabled: Bool,
                               useCustomReturnAction: Bool,
                               alignment: NSTextAlignment,
                               separatorInset: UIEdgeInsets?) -> FormCellConfiguration? {
        switch self {
        case .number:
            let configuration = FormCellTextConfiguration()
            configuration.placeholder = "Credit card"
            configuration.cellType = .number
            configuration.textFieldFormatter = CreditCardTextFieldFormatter()
            configuration.text = model.creditCard
            if showTitle {
                configuration.title = "Credit card"
            }
            configuration.enabled = enabled
            configuration.textAlignment = alignment
            configuration.separatorInset = separatorInset
            return configuration
        case .expirationDate:
            let configuration = FormCellTextConfiguration()
            configuration.placeholder = "Expiration Date"
            configuration.cellType = .picker
            configuration.formPickerDataSource = ExpirationDatePickerDataSource()
            configuration.rightView = FormPickerRightAccessoryView()
            configuration.text = model.expiration
            if showTitle {
                configuration.title = "Expiration Date"
            }
            configuration.enabled = enabled
            configuration.textAlignment = alignment
            configuration.separatorInset = separatorInset
            return configuration
        }
    }
}

enum PasswordRowType: Int, CaseIterable {
    case newPassword
    case newPasswordConfirmation
}

extension PasswordRowType: RowConfigurable {
    var title: String {
        return "Password"
    }

    func formCellConfiguration(showTitle: Bool,
                               model: FormModel,
                               accessoryView: UIView,
                               passwordVisible: Bool,
                               enabled: Bool,
                               useCustomReturnAction: Bool,
                               alignment: NSTextAlignment,
                               separatorInset: UIEdgeInsets?) -> FormCellConfiguration? {
        switch self {
        case .newPassword:
            let configuration = FormCellTextConfiguration()
            configuration.placeholder = "New password"
            if !passwordVisible {
                configuration.cellType = .password
            }
            if showTitle {
                configuration.title = "New password"
            }
            configuration.text = model.password
            configuration.rightView = accessoryView
            configuration.enabled = enabled
            configuration.textAlignment = alignment
            configuration.separatorInset = separatorInset
            return configuration
        case .newPasswordConfirmation:
            let configuration = FormCellTextConfiguration()
            configuration.placeholder = "Confirmation"
            configuration.cellType = .password
            if showTitle {
                configuration.title = "Confirmation"
            }
            configuration.text = model.passwordConfirmation
            configuration.enabled = enabled
            configuration.textAlignment = alignment
            configuration.separatorInset = separatorInset
            return configuration
        }
    }
}
