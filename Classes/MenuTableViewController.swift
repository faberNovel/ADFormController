//
//  MenuTableViewController.swift
//  FormDemo
//
//  Created by Samuel Gallet on 04/07/16.
//
//

import UIKit

class MenuTableViewController: TableViewController {

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCells([RegisterableView.Class(UITableViewCell)])
    }

    // MARK: UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let  cell : UITableViewCell = tableView.dequeueCellAtIndexPath(indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Empty"
        case 1:
            cell.textLabel?.text = "Filled"
        case 2:
            cell.textLabel?.text = "With Title"
        case 3:
            cell.textLabel?.text = "Custom default input accessory"
        default:
            break
        }
        return cell

    }

    // MARK: UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
        default:
            break
        }
        navigationController?.pushViewController(testFormViewController, animated: true)
    }
}
