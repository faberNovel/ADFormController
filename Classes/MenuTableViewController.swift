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
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let  cell : UITableViewCell = tableView.dequeueCellAtIndexPath(indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Empty"
        default:
            break
        }
        return cell

    }

    // MARK: UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //TODO: (Samuel Gallet) 04/07/2016 Push form
        let testFormViewController = TestFormViewController()
        testFormViewController.title = "Empty"
        navigationController?.pushViewController(testFormViewController, animated: true)
    }
}
