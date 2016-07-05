//
//  TestFormViewController.swift
//  FormDemo
//
//  Created by Samuel Gallet on 04/07/16.
//
//

import UIKit
import ADFormController

class TestFormViewController : TableViewController, ADFormControllerDelegate {
    var prefilled = false {
        didSet {
            if prefilled {
                formModel.setStubValues()
            } else {
                formModel.resetValues()
            }
        }
    }
    var showTitles = false
    var shouldSetCustomAccessoryView = false

    static let dateFormatter : NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return dateFormatter;
    }()

    private var formModel = FormModel()
    lazy private var formController : ADFormController = {
        let formController = ADFormController(tableView: self.tableView)
        formController.delegate = self
        return formController
    }()
    private var passwordVisible = false
    lazy private var passwordButton :UIButton = {
        let button = UIButton(type: .Custom)
        button.setTitle("Show", forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.italicSystemFontOfSize(10.0)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
        button.sizeToFit()
        return button
    }()

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .OnDrag

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Print", style: .Plain, target: self, action: #selector(TestFormViewController.printValue))

        passwordButton.addTarget(self, action: #selector(TestFormViewController.togglePassword), forControlEvents: .TouchUpInside)
        if shouldSetCustomAccessoryView {
            formController.defaultInputAccessoryView = EnglishAccessoryToolbar(frame: CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 64.0))
        }
    }

    // MARK: UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return RowType.count
        case 1:
            return CreditCardRowType.count
        case 2:
            return PassworkRowType.count
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return formController.cellForRowAtIndexPath(indexPath)
    }

    // MARK: UITableViewDelegate

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0;
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return rowConfigurableAtIndexPath(NSIndexPath(forRow: 0, inSection: section))?.title
    }

    // MARK: ADFormControllerDelegate

    func configurationForFormController(formController: ADFormController, atIndexPath indexPath: NSIndexPath) -> ADFormCellConfiguration? {
        return rowConfigurableAtIndexPath(indexPath)?.formCellConfiguration(showTitles, model: formModel, prefilled: prefilled, accessoryView: passwordButton)
    }

    // MARK: Private
    @objc private func printValue () {
        let isMarried = formController.boolValueForIndexPath(NSIndexPath(forRow: 0, inSection: 0));
        DDLogInfo("Married =  \(isMarried)");
    }

    @objc private func togglePassword () {
        passwordVisible = !passwordVisible;
        let title = passwordVisible ? "Hide" : "Show"
        passwordButton.setTitle(title, forState: .Normal)

        let indexPath = NSIndexPath(forRow: PassworkRowType.PasswordRowTypeNewPassword.rawValue, inSection: 2)
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
    }

    func rowConfigurableAtIndexPath(indexPath: NSIndexPath) -> RowConfigurable? {
        switch indexPath.section {
        case 0:
            return RowType(rawValue: indexPath.row)
        case 1:
            return CreditCardRowType(rawValue: indexPath.row)
        case 2:
            return PassworkRowType(rawValue: indexPath.row)
        default:
            return nil;
        }
    }
}
