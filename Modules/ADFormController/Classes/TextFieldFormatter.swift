//
//  TextFieldFormatter.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

@objc public protocol TextFieldFormatter {
    func textFieldValueChanged(_ textField: UITextField)
    func textField(_ textField: UITextField!,
                   shouldChangeCharactersInRange range: NSRange,
                   replacementString string: String!) -> Bool
}
