//
//  PickerViewTextFieldBinding.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

class PickerViewTextFieldBinding : NSObject, UIPickerViewDataSource, UIPickerViewDelegate {

    private(set) lazy var pickerView: UIPickerView = self.createPickerView()
    var formPickerDataSource: FormPickerDataSource?

    private let textField: UITextField

    init(textField: UITextField) {
        self.textField = textField
        super.init()
    }

    func startEditing() {
        guard let text = textField.text else {
            return
        }
        if text.isEmpty {
            for index in 0..<pickerView.numberOfComponents {
                pickerView(pickerView, didSelectRow: 0, inComponent: index)
            }
        } else {
            guard let selectedIndexes = formPickerDataSource?.selectedIndexes(from: text) else {
                return
            }
            for index in 0..<selectedIndexes.count {
                pickerView.selectRow(selectedIndexes[index], inComponent:index, animated: false)
            }
        }
    }

    //MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        guard let dataSource = formPickerDataSource else {
            return 0
        }
        return dataSource.numberOfComponents
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let dataSource = formPickerDataSource else {
            return 0
        }
        return dataSource.componentOptions(component).count
    }

    //MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let dataSource = formPickerDataSource else {
            return ""
        }
        return dataSource.componentOptions(component)[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let dataSource = formPickerDataSource else {
            return
        }
        let range = 0..<pickerView.numberOfComponents
        let selectedIndexes = range.map { pickerView.selectedRow(inComponent: $0) }
        let value = dataSource.string(from: selectedIndexes)
        textField.text = nil
        textField.insertText(value)
    }

    //MARK: - Private

    func createPickerView() -> UIPickerView {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }
}
