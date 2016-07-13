//
//  SimpleFormPickerDataSource.swift
//  Pods
//
//  Created by Samuel Gallet on 05/07/16.
//
//

import Foundation

@objc public class SimpleFormPickerDataSource: NSObject, FormPickerDataSource {
    private var options: [String]

    public required init(options: [String]) {
        self.options = options
    }

    // MARK: FormPickerDataSource
    public let numberOfComponents: Int = 1

    public func componentOptions(component: Int) -> [String] {
        return options
    }

    public func stringFromSelectedIndexes(indexes: [Int]) -> String {
        guard let lastValue = indexes.last else {
            return ""
        }
        return options[options.startIndex.advancedBy(lastValue)]
    }

    public func selectedIndexesFromString(string: String) -> [Int] {
        guard let index = options.indexOf(string) else {
            return [0]
        }
        return [index]
    }

}
