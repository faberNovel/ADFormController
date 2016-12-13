//
//  FormCellBoolConfiguration.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

@objc open class FormCellBoolConfiguration : FormCellConfiguration {
    open var boolValue: Bool = false
    open var onTintColor: UIColor?
    open var switchZoom: Float = 1.0

    override open func visit(_ configurable: FormCellConfigurable, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        return configurable.boolInputCellWithConfiguration(self, atIndexPath: indexPath)
    }
}
