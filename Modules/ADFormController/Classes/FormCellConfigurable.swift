//
//  FormCellConfigurable.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

@objc public protocol FormCellConfigurable {
    func boolInputCellWithConfiguration(_ configuration: FormCellBoolConfiguration, atIndexPath indexPath: IndexPath) -> UITableViewCell
    func textInputCellWithConfiguration(_ configuration: FormCellTextConfiguration, atIndexPath indexPath: IndexPath) -> UITableViewCell
}
