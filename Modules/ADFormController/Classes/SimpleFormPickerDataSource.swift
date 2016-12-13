//
//  SimpleFormPickerDataSource.swift
//  Pods
//
//  Created by Samuel Gallet on 05/07/16.
//
//

import Foundation

@objc open class SimpleFormPickerDataSource: NSObject, FormPickerDataSource {
    private var options: [String]

    public required init(options: [String]) {
        self.options = options
    }

    // MARK: FormPickerDataSource
    open let numberOfComponents: Int = 1

    open func componentOptions(_ component: Int) -> [String] {
        return options
    }

    open func stringFromSelectedIndexes(_ indexes: [Int]) -> String {
        guard let lastValue = indexes.last else {
            return ""
        }
        return options[options.startIndex.advanced(by: lastValue)]
    }

    open func selectedIndexesFromString(_ string: String) -> [Int] {
        guard let index = options.index(of: string) else {
            return [0]
        }
        return [index]
    }

}
