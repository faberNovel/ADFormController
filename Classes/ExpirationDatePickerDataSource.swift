//
//  ExpirationDatePickerDataSource.swift
//  FormDemo
//
//  Created by Samuel Gallet on 05/07/16.
//
//

import Foundation
import ADFormController

private enum ExpirationDateComponent: Int {
    case ExpirationDateComponentMonth
    case ExpiractionDateComponentYear

    static let count = {
        return ExpirationDateComponent.ExpiractionDateComponentYear.hashValue + 1
    }()

    func componentoptions() -> [String] {
        switch self {
        case .ExpirationDateComponentMonth:
            return ExpirationDateComponent.months
        case .ExpiractionDateComponentYear:
            return ExpirationDateComponent.years
        }
    }

    static let months : [String] = {
        let dateFormatter = NSDateFormatter()
        return dateFormatter.monthSymbols
    }()

    static let years : [String] = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let currentYearString = dateFormatter.stringFromDate(NSDate())
        guard let currentYear = Int(currentYearString) else {
            return []
        }
        let range : Range = currentYear..<(currentYear + 30)
        return range.map { String($0) }
    }()
}

class ExpirationDatePickerDataSource: NSObject, FormPickerDataSource {

    // MARK: ADFormPickerDataSource
    let numberOfComponents: Int = ExpirationDateComponent.count

    func componentOptions(component: Int) -> [String] {
        guard let options = ExpirationDateComponent(rawValue: component)?.componentoptions() else {
            return []
        }
        return options
    }

    func stringFromSelectedIndexes(indexes: [Int]) -> String {
        let yearIndex = indexes[ExpirationDateComponent.ExpiractionDateComponentYear.rawValue]
        let monthIndex = indexes[ExpirationDateComponent.ExpirationDateComponentMonth.rawValue]
        let yearString = ExpirationDateComponent.years[yearIndex]
        let monthFormatedString = String.init(format: "%02d", (monthIndex + 1))
        return monthFormatedString + "/\(yearString.substringFromIndex(yearString.startIndex.advancedBy(2)))"
    }

    func selectedIndexesFromString(string: String) -> [Int] {
        let monthString = string.substringToIndex(string.startIndex.advancedBy(2))
        guard let monthIndex = Int(monthString) else {
            return []
        }
        let yearString = string.substringFromIndex(string.startIndex.advancedBy(3))
        var yearIndex = 0
        for index in 0..<ExpirationDateComponent.years.count {
            let year = ExpirationDateComponent.years[index]
            if year.hasSuffix(yearString) {
                yearIndex = index
                break
            }
        }
        return [monthIndex - 1, yearIndex]
    }

}