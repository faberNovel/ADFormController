//
//  FormInputTableViewCell.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

protocol FormTextInputTableViewCell {
    weak var delegate: FormTextInputTableViewCellDelegate? { get set }
    var inputAccessoryView: UIView? { get set }
    var returnKeyType: UIReturnKeyType { get set }
    var textContent: String? { get set }

    func beginEditing()
    func applyConfiguration(configuration: FormCellTextConfiguration)
}

protocol FormTextInputTableViewCellDelegate: class {
    func textInputTableViewCellDidBeginEditing(cell: FormTextInputTableViewCell)
    func textInputTableViewCellShouldReturn(cell: FormTextInputTableViewCell) -> Bool
    func textInputTableViewCellValueChanged(cell: FormTextInputTableViewCell)
}


protocol FormBoolInputTableViewCell {
    weak var delegate: FormBoolInputTableViewCellDelegate? { get set }
    var boolContent: Bool { get set }

    func applyConfiguration(configuration: FormCellBoolConfiguration)
}

protocol FormBoolInputTableViewCellDelegate: class {
    func boolInputTableViewCellDidChangeValue(cell: FormBoolInputTableViewCell)
}