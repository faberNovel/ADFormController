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
    func componentOptions(_ component: Int) -> [String]
    func stringFromSelectedIndexes(_ indexes: [Int]) -> String
    func selectedIndexesFromString(_ string: String) -> [Int]
}
