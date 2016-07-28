//
//  TextFieldFormatter.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

@objc public protocol TextFieldFormatter {
    func textFieldValueChanged(textField: UITextField)
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool
}
