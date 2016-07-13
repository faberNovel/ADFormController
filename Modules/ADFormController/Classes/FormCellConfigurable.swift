//
//  FormCellConfigurable.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

@objc public protocol FormCellConfigurable {
    func boolInputCellWithConfiguration(configuration: FormCellBoolConfiguration, atIndexPath indexPath: NSIndexPath) -> UITableViewCell
    func textInputCellWithConfiguration(configuration: FormCellTextConfiguration, atIndexPath indexPath: NSIndexPath) -> UITableViewCell
}
