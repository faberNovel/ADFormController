//
//  FormTextField.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

class FormTextField : UITextField {

    var disablePasteAction = false

    // MARK: UITextField
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UITextField.paste(_:)) && disablePasteAction {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
