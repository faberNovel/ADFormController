//
//  MenuTableViewController.swift
//  FormDemo
//
//  Created by Samuel Gallet on 04/07/16.
//
//

import UIKit
import ADUtils

private enum Configurations: String, EnumCollection {
    case empty = "Empty"
    case filled = "Filled"
    case withTitle = "With Title"
    case customDefaultInputAccessory = "Custom default input accessory"
    case disabledInputs = "Disabled inputs"
    case disableAllButFirstAndLastInput = "Disabled all but first and last inputs"
    case withAlignement = "With alignment"
    case withCustomSeparatorInsets = "With custom separator insets"
}

class MenuTableViewController: TableViewController {

    //MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cell: .class(UITableViewCell.self))
    }

    //MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Configurations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueCell(at: indexPath)
        guard (0...Configurations.count).contains(indexPath.row) else {
            return cell
        }
        let configuration = Configurations.allValues[indexPath.row]
        cell.textLabel?.text = configuration.rawValue
        return cell
    }

    //MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        guard (0...Configurations.count).contains(indexPath.row) else {
            return
        }
        let configuration = Configurations.allValues[indexPath.row]
        let testFormViewController = TestFormViewController()
        testFormViewController.title = configuration.rawValue
        switch configuration {
        case .empty:
            break
        case .filled:
            testFormViewController.prefilled = true
        case .withTitle:
            testFormViewController.showTitles = true
        case .customDefaultInputAccessory:
            testFormViewController.shouldSetCustomAccessoryView = true
        case .disabledInputs:
            testFormViewController.enabledInputs = false
        case .withAlignement:
            testFormViewController.showTitles = true
            testFormViewController.alignment = .right
        case .withCustomSeparatorInsets:
            testFormViewController.separatorInset = UIEdgeInsets(horizontal: 35.0, vertical: 0.0)
        case .disableAllButFirstAndLastInput:
            testFormViewController.enabledInputs = false
            testFormViewController.forceEnableFirstAndLastInput = true
        }
        navigationController?.pushViewController(testFormViewController, animated: true)
    }
}
