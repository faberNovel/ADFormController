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
    var datePickerMode: UIDatePicker.Mode {
        get { return datePicker.datePickerMode }
        set { datePicker.datePickerMode = newValue }
    }

    private let textField: UITextField
    private lazy var datePicker: UIDatePicker = self.createDatePicker()

    init(textField: UITextField) {
        self.textField = textField
        super.init()
    }

    func startEditing() {
        if textField.text?.count == 0 {
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

    func apply(_ datePickerConfiguration: ((UIDatePicker) -> Void)?) {
        datePickerConfiguration?(datePicker)
    }

    //MARK: - Private

    private func createDatePicker() -> UIDatePicker {
        let picker = UIDatePicker()
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        return picker
    }

    @objc private func dateChanged(_ sender: UIDatePicker) {
        textField.text = ""
        guard let dateFormatter = dateFormatter else {
            return
        }
        textField.insertText(dateFormatter.string(from: sender.date))
    }
}
