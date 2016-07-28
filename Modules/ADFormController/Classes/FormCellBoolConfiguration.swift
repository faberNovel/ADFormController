//
//  FormCellBoolConfiguration.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

@objc public class FormCellBoolConfiguration : FormCellConfiguration {
    public var boolValue: Bool = false
    public var onTintColor: UIColor?
    public var switchZoom: Float = 1.0

    override public func visit(configurable: FormCellConfigurable, atIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return configurable.boolInputCellWithConfiguration(self, atIndexPath: indexPath)
    }
}
