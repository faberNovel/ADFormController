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
        return .grouped
    }

    func smoothlyDeselectRows() {
        guard let selectedIndexPaths = tableView.indexPathsForVisibleRows, let parentController = parent else {
            return
        }

        func deselectRows(_ animated: Bool) {
            for indexPath in selectedIndexPaths {
                tableView.deselectRow(at: indexPath, animated: animated)
            }
        }

        guard let coordinator = transitionCoordinator else {
            deselectRows(false)
            return
        }

        coordinator.animateAlongsideTransition(in: parentController.view, animation: { (context: UIViewControllerTransitionCoordinatorContext) in
            deselectRows(true)
        }) { (context : UIViewControllerTransitionCoordinatorContext) in
            guard context.isCancelled else {
                return
            }
            for indexPath in selectedIndexPaths {
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
    }

    // MARK: UIViewController
    override func loadView() {
        super.loadView()
        tableView = UITableView(frame: CGRect.zero, style: type(of: self).tableViewStyle)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.alwaysBounceVertical = true
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        let views = ["tableView" : tableView]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: .alignAllLeft, metrics: nil, views: views));
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: .alignAllLeft, metrics: nil, views: views));

        keyboardManager = ADKeyboardManager(scrollView: tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        smoothlyDeselectRows();
        keyboardManager.startObservingKeyboard()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        keyboardManager.endObservingKeyboard();
    }

    // MARK: UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 0;
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        assert(false, "Should be overriden")
    }
}
