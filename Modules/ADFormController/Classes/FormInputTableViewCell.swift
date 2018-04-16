//
//  FormInputTableViewCell.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

protocol FormTextInputTableViewCell {
    var delegate: FormTextInputTableViewCellDelegate? { get set } // must be weak !
    var inputAccessoryView: UIView? { get set }
    var returnKeyType: UIReturnKeyType { get set }
    var textContent: String? { get set }

    func beginEditing()
    func apply(configuration: FormCellTextConfiguration)
}

protocol FormTextInputTableViewCellDelegate: class {
    func textInputTableViewCellDidBeginEditing(_ cell: FormTextInputTableViewCell)
    func textInputTableViewCellShouldReturn(_ cell: FormTextInputTableViewCell) -> Bool
    func textInputTableViewCellValueChanged(_ cell: FormTextInputTableViewCell)
}


protocol FormBoolInputTableViewCell {
    var delegate: FormBoolInputTableViewCellDelegate? { get set }  // must be weak !
    var boolContent: Bool { get set }

    func apply(configuration: FormCellBoolConfiguration)
}

protocol FormBoolInputTableViewCellDelegate: class {
    func boolInputTableViewCellDidChangeValue(_ cell: FormBoolInputTableViewCell)
}
