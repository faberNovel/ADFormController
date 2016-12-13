//
//  DatePickerTextFieldBinding.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

class DatePickerTextFieldBinging: NSObject {
    let datePicker = UIDatePicker()
    var dateFormatter: DateFormatter?
    private var textField : UITextField

    init(textField: UITextField) {
        self.textField = textField
        super.init()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(DatePickerTextFieldBinging.dateChanged(_:)), for: .valueChanged)
    }

    func startEditing() {
        if textField.text?.characters.count == 0 {
            dateChanged(datePicker)
            return
        }
        guard let date = dateFormatter.flatMap({ (dateFormatter : DateFormatter) -> Date? in
            return textField.text.flatMap({dateFormatter.date(from: $0)})
        }) else {
            return
        }
        datePicker.date = date
    }

    // MARK: Private
    @objc private func dateChanged(_ sender: UIDatePicker) {
        textField.text = ""
        guard let dateFormatter = dateFormatter else {
            return
        }
        textField.insertText(dateFormatter.string(from: sender.date))
    }
}
