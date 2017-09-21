//
//  CreditCardTextFieldFormatter.swift
//  FormDemo
//
//  Created by Samuel Gallet on 04/07/16.
//
//

import UIKit
import ADFormController

class CreditCardTextFieldFormatter: NSObject, TextFieldFormatter {
    private var previousTextFieldContent: String?
    private var previousSelectionRange: UITextRange?

    //MARK: - ADTextFieldFormatter

    @objc func textFieldValueChanged(_ textField: UITextField) {
        reformAsCardNumber(textField)
    }

    @objc func textField(_ textField: UITextField!,
                         shouldChangeCharactersInRange range: NSRange,
                         replacementString string: String!) -> Bool {
        previousSelectionRange = textField.selectedTextRange
        previousTextFieldContent = textField.text
        return true
    }

    //MARK: - Private

    private func reformAsCardNumber(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }

        var targetCursorPosition: Int
        if let selectedTextRange = textField.selectedTextRange {
            targetCursorPosition = textField.offset(
                from: textField.beginningOfDocument,
                to: selectedTextRange.start
            )
        } else {
            targetCursorPosition = (textField.text ?? "").characters.count
        }

        let cardNumberWithoutSpacing = removeNonDigitsAndPreserveCursorPosition(
            text,
            cursorPosition: &targetCursorPosition
        )
        if cardNumberWithoutSpacing.characters.count > 16 {
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelectionRange
            return
        }
        let cardNumberWithSpacing = insertSpacesEveryFourDigitsAndPreserveCursorPosition(
            cardNumberWithoutSpacing,
            cursorPosition: &targetCursorPosition
        )
        textField.text = cardNumberWithSpacing
        let targetPosition = textField.position(
            from: textField.beginningOfDocument,
            offset: targetCursorPosition
        )
        textField.selectedTextRange = targetPosition.flatMap({ textField.textRange(from: $0, to: $0) })
    }

    private func removeNonDigitsAndPreserveCursorPosition(_ string: String,
                                                          cursorPosition: inout Int) -> String {
        let originalCursorPosition = cursorPosition
        let newCharacters = string.characters.filter { (character : Character) -> Bool in
            let scalars = String(character).unicodeScalars
            return CharacterSet.decimalDigits.contains(UnicodeScalar(scalars[scalars.startIndex].value)!)
        }
        cursorPosition = originalCursorPosition - (string.characters.count - newCharacters.count)
        return String(newCharacters)
    }

    private func insertSpacesEveryFourDigitsAndPreserveCursorPosition(_ originalString: String,
                                                                      cursorPosition: inout Int) -> String {
        let originalCursorPosition = cursorPosition
        var newString = ""
        for index in 0..<originalString.characters.count {
            if index > 0 && index % 4 == 0 {
                newString += " "
                if index < originalCursorPosition {
                    cursorPosition += 1
                }
            }
            newString.append(originalString[originalString.characters.index(originalString.startIndex, offsetBy: index)])
        }
        return newString
    }
}
