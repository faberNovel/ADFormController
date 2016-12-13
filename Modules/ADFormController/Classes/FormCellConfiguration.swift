//
//  FormCellConfiguration.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

@objc open class FormCellConfiguration: NSObject {
    open var title: String = ""
    open var titleFont: UIFont? = UIFont.init(name: "HelveticaNeue-Light", size: 14.0)
    open var titleColor: UIColor = UIColor.black
    open var tintColor: UIColor?
    open var rightView: UIView?
    open var enabled: Bool = true
    open var textAlignment: NSTextAlignment = .left

    open func visit(_ configurable: FormCellConfigurable, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        fatalError("Should be overriden")
    }
}
