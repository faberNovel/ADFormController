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
    case expirationDateComponentMonth
    case expiractionDateComponentYear

    static let count = {
        return ExpirationDateComponent.expiractionDateComponentYear.hashValue + 1
    }()

    func componentoptions() -> [String] {
        switch self {
        case .expirationDateComponentMonth:
            return ExpirationDateComponent.months
        case .expiractionDateComponentYear:
            return ExpirationDateComponent.years
        }
    }

    static let months : [String] = {
        let dateFormatter = DateFormatter()
        return dateFormatter.monthSymbols
    }()

    static let years : [String] = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let currentYearString = dateFormatter.string(from: Date())
        guard let currentYear = Int(currentYearString) else {
            return []
        }
        var result: [String] = []
        for i in currentYear..<(currentYear + 30) {
            result.append(String(i))
        }
        return result
    }()
}

class ExpirationDatePickerDataSource: NSObject, FormPickerDataSource {

    // MARK: ADFormPickerDataSource
    let numberOfComponents: Int = ExpirationDateComponent.count

    func componentOptions(_ component: Int) -> [String] {
        guard let options = ExpirationDateComponent(rawValue: component)?.componentoptions() else {
            return []
        }
        return options
    }

    func string(from indexes: [Int]) -> String {
        let yearIndex = indexes[ExpirationDateComponent.expiractionDateComponentYear.rawValue]
        let monthIndex = indexes[ExpirationDateComponent.expirationDateComponentMonth.rawValue]
        let yearString = ExpirationDateComponent.years[yearIndex]
        let monthFormatedString = String.init(format: "%02d", (monthIndex + 1))
        return monthFormatedString + "/\(yearString.substring(from: yearString.characters.index(yearString.startIndex, offsetBy: 2)))"
    }

    func selectedIndexes(from string: String) -> [Int] {
        let monthString = string.substring(to: string.characters.index(string.startIndex, offsetBy: 2))
        guard let monthIndex = Int(monthString) else {
            return []
        }
        let yearString = string.substring(from: string.characters.index(string.startIndex, offsetBy: 3))
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
