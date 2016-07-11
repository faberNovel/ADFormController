//
//  DatePickerTextFieldBinding.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

class DatePickerTextFieldBinging: NSObject {
    let datePicker : UIDatePicker = UIDatePicker()
    var dateFormatter : NSDateFormatter?
    private var textField : UITextField

    init(textField: UITextField) {
        self.textField = textField
        super.init()
        datePicker.datePickerMode = .Date
        datePicker.addTarget(self, action: #selector(DatePickerTextFieldBinging.dateChanged(_:)), forControlEvents: .ValueChanged)
    }

    func startEditing() {
        if textField.text?.characters.count == 0 {
            dateChanged(datePicker)
            return
        }
        guard let date = dateFormatter.flatMap({ (dateFormatter : NSDateFormatter) -> NSDate? in
            return textField.text.flatMap({dateFormatter.dateFromString($0)})
        }) else {
            return
        }
        datePicker.date = date
    }

    // MARK: Private
    @objc private func dateChanged(sender: UIDatePicker) {
        textField.text = ""
        guard let dateFormatter = dateFormatter else {
            return
        }
        textField.insertText(dateFormatter.stringFromDate(sender.date))
    }
}
