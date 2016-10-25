//
//  PickerViewTextFieldBinding.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

class PickerViewTextFieldBinding : NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    let pickerView : UIPickerView = UIPickerView()
    var formPickerDataSource : FormPickerDataSource?
    private var textField : UITextField

    init(textField: UITextField) {
        self.textField = textField
        super.init()
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    func startEditing() {
        guard let text = textField.text else {
            return
        }
        if text.characters.count == 0 {
            for index in 0..<pickerView.numberOfComponents {
                pickerView(pickerView, didSelectRow: 0, inComponent: index)
            }
        } else {
            guard let selectedIndexes = formPickerDataSource?.selectedIndexesFromString(text) else {
                return
            }
            for index in 0..<selectedIndexes.count {
                pickerView.selectRow(selectedIndexes[index], inComponent:index, animated: false)
            }
        }
    }

    // MARK: UIPickerViewDataSource

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        guard let dataSource = formPickerDataSource else {
            return 0
        }
        return dataSource.numberOfComponents
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let dataSource = formPickerDataSource else {
            return 0
        }
        return dataSource.componentOptions(component).count
    }

    // MARK: UIPickerViewDelegate

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let dataSource = formPickerDataSource else {
            return ""
        }
        return dataSource.componentOptions(component)[row]
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let dataSource = formPickerDataSource else {
            return
        }
        let range = 0..<pickerView.numberOfComponents
        let indexes = range.map { pickerView.selectedRowInComponent($0) }
        let value = dataSource.stringFromSelectedIndexes(indexes)
        textField.text = nil
        textField.insertText(value)

    }
}