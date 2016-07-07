//
//  FormInputTableViewCell.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

@objc public protocol FormTextInputTableViewCell {
    weak var delegate: FormTextInputTableViewCellDelegate? { get set }
    var inputAccessoryView: UIView? { get set }
    var returnKeyType: UIReturnKeyType { get set }
    var textContent: String? { get set }

    func beginEditing()
    func applyConfiguration(configuration: ADFormCellTextConfiguration)
}

@objc public protocol FormTextInputTableViewCellDelegate {
    func textInputTableViewCellDidBeginEditing(cell: FormTextInputTableViewCell)
    func textInputTableViewCellShouldReturn(cell: FormTextInputTableViewCell) -> Bool
    func textInputTableViewCellValueChanged(cell: FormTextInputTableViewCell)
}


@objc public protocol FormBoolInputTableViewCell {
    weak var delegate: FormBoolInputTableViewCellDelegate? { get set }
    var boolContent: Bool { get set }

    func applyConfiguration(configuration: ADFormCellBoolConfiguration)
}

@objc public protocol FormBoolInputTableViewCellDelegate {
    func boolInputTableViewCellDidChangeValue(cell: FormBoolInputTableViewCell)
}