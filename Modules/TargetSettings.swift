//
//  TargetSettings.swift
//  FormDemo
//
//  Created by Pierre Felgines on 22/09/16.
//
//

import Foundation

class TargetSettings : NSObject {

    // Config
    @objc private(set) var logLevel: DDLogLevel = .all
    @objc private(set) var hockeyAppId: String = ""
    @objc private(set) var useWatchdog: Bool = false
    @objc private(set) var useFileLogger: Bool = false
    // Colors
    @objc private(set) var applidium_blue1: String = ""
    @objc private(set) var applidium_blue2: String = ""
    @objc private(set) var applidium_blue3: String = ""
    @objc private(set) var applidium_blue4: String = ""

    static let shared = TargetSettings()

    //MARK: - NSObject

    override init() {
        super.init()
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
            let dictionary = NSDictionary(contentsOfFile: path) as? [String : Any] else {
                fatalError("Cannot find Info.plist")
        }
        extract(from: dictionary)
    }

    //MARK: - Private

    private func extract(from dictionary: [String: Any]) {
        for (key, value) in dictionary {

            if key == "logLevel", let value = value as? Int {
                setLogLevelFromPlist(value)
                continue
            }

            let capitalizedKey = key.firstLetterCapitalized()
            let valueIsString = value is String
            if responds(to: NSSelectorFromString("set\(capitalizedKey):")) &&
                (!valueIsString || (valueIsString && !(value as! String).isEmpty)) {
                setValue(value, forKey: key)
            } else if let subDictionary = dictionary[key] as? [String: Any] {
                extract(from: subDictionary)
            }
        }
    }

    private func setLogLevelFromPlist(_ logLevel: Int) {
        let logLevels: [DDLogLevel] = [.off, .error, .warning, .info, .debug, .verbose, .all]
        guard logLevel >= 0 && logLevel < logLevels.count else {
            return
        }
        self.logLevel = logLevels[logLevel]
    }
}

private extension String {
    func firstLetterCapitalized() -> String {
        guard !isEmpty else { return "" }
        let index = characters.index(startIndex, offsetBy: 1)
        return substring(to: index).capitalized + substring(from: index)
    }
}
