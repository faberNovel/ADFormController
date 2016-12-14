//
//  Color.swift
//  FormDemo
//
//  Created by Edouard Siegel on 03/03/16.
//
//

import UIKit

extension UIColor {

    // Note: we prefix colors to avoid colisions with existing names
    // (e.g. ad_lightGray)

    class var ad_mainApplidiumColor: UIColor {
        return UIColor(hexColor: TargetSettings.shared.applidium_blue1)
    }
}

extension UIColor {

    /**
     Init a color from an hexadecimal string

     - Parameter hexColor: String with format "12AA34" or "#12AA34"
     */
    fileprivate convenience init(hexColor: String) {
        var color: CUnsignedInt = 0
        let scanner = Scanner(string: hexColor.replacingOccurrences(of: "#", with: ""))
        scanner.scanHexInt32(&color)
        let divider: Float = 255
        self.init(
            red: CGFloat(((Float)((color & 0xFF0000) >> 16)) / divider),
            green: CGFloat(((Float)((color & 0xFF00) >> 8)) / divider),
            blue: CGFloat(((Float)((color & 0xFF))) / divider),
            alpha: 1.0
        )
    }
}
