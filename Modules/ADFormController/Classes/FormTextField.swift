//
//  FormTextField.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

@objc public class FormTextField : UITextField {
    public var disablePasteAction : Bool = false

    // MARK: UITextField
    public override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == #selector(UITextField.paste(_:)) && disablePasteAction {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}