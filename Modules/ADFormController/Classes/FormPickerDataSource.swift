//
//  FormPickerDataSource.swift
//  Pods
//
//  Created by Samuel Gallet on 05/07/16.
//
//

import Foundation

@objc public protocol FormPickerDataSource {
    var numberOfComponents : Int { get }
    func componentOptions(component: Int) -> [String]
    func stringFromSelectedIndexes(indexes: [Int]) -> String
    func selectedIndexesFromString(string: String) -> [Int]
}