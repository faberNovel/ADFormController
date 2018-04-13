//
//  FormCellConfiguration.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

@objcMembers open class FormCellConfiguration: NSObject {
    open var title: String = ""
    open var titleFont: UIFont? = UIFont(name: "HelveticaNeue-Light", size: 14.0)
    open var titleColor: UIColor = UIColor.black
    open var tintColor: UIColor?
    open var rightView: UIView?
    open var enabled: Bool = true
    open var textAlignment: NSTextAlignment = .left
    open var separatorInset: UIEdgeInsets? = nil
    open var contentInset: UIEdgeInsets? = nil

    open func visit(_ configurable: FormCellConfigurable, at indexPath: IndexPath) -> UITableViewCell {
        fatalError("Should be overriden")
    }
}
