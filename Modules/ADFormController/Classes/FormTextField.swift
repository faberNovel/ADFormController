//
//  FormTextField.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

class FormTextField : UITextField {
    public var disablePasteAction : Bool = false

    // MARK: UITextField
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == #selector(UITextField.paste(_:)) && disablePasteAction {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}