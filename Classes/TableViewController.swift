//
//  TableViewController.swift
//  FormDemo
//
//  Created by Samuel Gallet on 04/07/16.
//
//

import UIKit
import ADKeyboardManager

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    private var keyboardManager : ADKeyboardManager!

    class var tableViewStyle : UITableViewStyle {
        return .Grouped
    }

    func smoothlyDeselectRows() {
        guard let selectedIndexPaths = tableView.indexPathsForVisibleRows, let parentController = parentViewController else {
            return
        }

        func deselectRows(animated: Bool) {
            for indexPath in selectedIndexPaths {
                tableView.deselectRowAtIndexPath(indexPath, animated: animated)
            }
        }

        guard let coordinator = transitionCoordinator() else {
            deselectRows(false)
            return
        }

        coordinator.animateAlongsideTransitionInView(parentController.view, animation: { (context: UIViewControllerTransitionCoordinatorContext) in
            deselectRows(true)
        }) { (context : UIViewControllerTransitionCoordinatorContext) in
            guard context.isCancelled() else {
                return
            }
            for indexPath in selectedIndexPaths {
                self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            }
        }
    }

    // MARK: UIViewController
    override func loadView() {
        super.loadView()
        tableView = UITableView(frame: CGRectZero, style: self.dynamicType.tableViewStyle)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.alwaysBounceVertical = true
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        let views = ["tableView" : tableView]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|", options: .AlignAllLeft, metrics: nil, views: views));
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: .AlignAllLeft, metrics: nil, views: views));

        keyboardManager = ADKeyboardManager(scrollView: tableView)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        smoothlyDeselectRows();
        keyboardManager.startObservingKeyboard()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        keyboardManager.endObservingKeyboard();
    }

    // MARK: UITableViewDataSource

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0;
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        assert(false, "Should be overriden")
    }
}
