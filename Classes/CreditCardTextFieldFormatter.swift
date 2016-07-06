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

    // MARK: ADTextFieldFormatter
    @objc func textFieldValueChanged(textField: UITextField) {
        reformAsCardNumber(textField)
    }

    @objc func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        previousSelectionRange = textField.selectedTextRange
        previousTextFieldContent = textField.text
        return true
    }

    // MARK: Private
    private func reformAsCardNumber(textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        guard var targetCursorPosition = textField.selectedTextRange.map({
            return textField.offsetFromPosition(textField.beginningOfDocument, toPosition: $0.start)
        }) else {
            return
        }
        let cardNumberWithoutSpacing = removeNonDigitsAndPreserveCursorPosition(text, cursorPosition: &targetCursorPosition)
        if cardNumberWithoutSpacing.characters.count > 16 {
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelectionRange
            return
        }
        let cardNumberWithSpacing = self.insertSpacesEveryFourDigitsAndPreserveCursorPosition(cardNumberWithoutSpacing, cursorPosition: &targetCursorPosition)
        textField.text = cardNumberWithSpacing
        let targetPosition = textField.positionFromPosition(textField.beginningOfDocument, offset: targetCursorPosition)
        textField.selectedTextRange = targetPosition.flatMap({textField.textRangeFromPosition($0, toPosition: $0)})
    }

    private func removeNonDigitsAndPreserveCursorPosition(string: String, inout cursorPosition: Int) -> String {
        let originalCursorPosition = cursorPosition
        let newCharacters = string.characters.filter { (character : Character) -> Bool in
            let scalars = String(character).unicodeScalars
            return NSCharacterSet.decimalDigitCharacterSet().longCharacterIsMember(scalars[scalars.startIndex].value)
        }
        cursorPosition = originalCursorPosition - (string.characters.count - newCharacters.count)
        return String(newCharacters)
    }

    private func insertSpacesEveryFourDigitsAndPreserveCursorPosition(originalString: String, inout cursorPosition: Int) -> String {
        let originalCursorPosition = cursorPosition
        var newString : String = String()
        for index in 0..<originalString.characters.count {
            if index > 0 && index % 4 == 0 {
                newString += " "
                if index < originalCursorPosition {
                    cursorPosition += 1
                }
            }
            newString.append(originalString[originalString.startIndex.advancedBy(index)])
        }
        return newString
    }
}
