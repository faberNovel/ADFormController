//
//  TableViewController.swift
//  FormDemo
//
//  Created by Samuel Gallet on 04/07/16.
//
//

import UIKit
import ADKeyboardManager
import ADUtils

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    private var keyboardManager : KeyboardManager!

    class var tableViewStyle : UITableView.Style {
        return .grouped
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
        let views: [String: Any] = ["tableView" : tableView]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: .alignAllLeft, metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: .alignAllLeft, metrics: nil, views: views))

        keyboardManager = KeyboardManager(scrollView: tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.ad_smoothlyDeselectItems(in: transitionCoordinator)
        keyboardManager.startObservingKeyboard()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        keyboardManager.stopObservingKeyboard()
    }

    // MARK: UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        assert(false, "Should be overriden")
    }
}
