//
//  MenuTableViewController.swift
//  FormDemo
//
//  Created by Samuel Gallet on 04/07/16.
//
//

import UIKit
import ADUtils

class MenuTableViewController: TableViewController {

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cell: .class(UITableViewCell.self))
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell : UITableViewCell = tableView.dequeueCell(at: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Empty"
        case 1:
            cell.textLabel?.text = "Filled"
        case 2:
            cell.textLabel?.text = "With Title"
        case 3:
            cell.textLabel?.text = "Custom default input accessory"
        case 4:
            cell.textLabel?.text = "Disabled inputs"
        case 5:
            cell.textLabel?.text = "With alignment"
        default:
            break
        }
        return cell

    }

    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let testFormViewController = TestFormViewController()
        switch indexPath.row {
        case 0:
            testFormViewController.title = "Empty"
        case 1:
            testFormViewController.title = "Filled"
            testFormViewController.prefilled = true
        case 2:
            testFormViewController.title = "With title"
            testFormViewController.showTitles = true
        case 3:
            testFormViewController.title = "Custom default input accessory"
            testFormViewController.shouldSetCustomAccessoryView = true
        case 4:
            testFormViewController.title = "Disabled inputs"
            testFormViewController.enabledInputs = false
        case 5:
            testFormViewController.title = "With alignment"
            testFormViewController.showTitles = true
            testFormViewController.alignment = .right
        default:
            break
        }
        navigationController?.pushViewController(testFormViewController, animated: true)
    }
}
