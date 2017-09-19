//
//  DatePickerTextFieldBinding.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

class DatePickerTextFieldBinding: NSObject {
    var dateFormatter: DateFormatter?
    var inputView: UIView { return datePicker }
    var datePickerMode: UIDatePickerMode {
        get { return datePicker.datePickerMode }
        set { datePicker.datePickerMode = newValue }
    }
    private var textField : UITextField
    private let datePicker = UIDatePicker()

    init(textField: UITextField) {
        self.textField = textField
        super.init()
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
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
