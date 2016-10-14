//
//  FormCellConfiguration.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

@objc public class FormCellConfiguration: NSObject {
    public var title: String = ""
    public var titleFont: UIFont? = UIFont.init(name: "HelveticaNeue-Light", size: 14.0)
    public var titleColor: UIColor = UIColor.blackColor()
    public var tintColor: UIColor?
    public var rightView: UIView?
    public var enabled: Bool = true

    public func visit(configurable: FormCellConfigurable, atIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        fatalError("Should be overriden")
    }
}
