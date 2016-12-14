//
//  FormCellConfigurable.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

@objc public protocol FormCellConfigurable {
    func boolInputCell(with configuration: FormCellBoolConfiguration, at indexPath: IndexPath) -> UITableViewCell
    func textInputCell(with configuration: FormCellTextConfiguration, at indexPath: IndexPath) -> UITableViewCell
}
