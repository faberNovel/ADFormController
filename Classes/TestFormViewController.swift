//
//  TestFormViewController.swift
//  FormDemo
//
//  Created by Samuel Gallet on 04/07/16.
//
//

import UIKit
import ADFormController

class TestFormViewController : TableViewController, FormControllerDelegate {
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
    var enabledInputs = true

    static let dateFormatter : NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return dateFormatter;
    }()

    private var formModel = FormModel()
    lazy private var formController : FormController = {
        let formController = FormController(tableView: self.tableView)
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
            formController.defaultAccessoryView = EnglishAccessoryToolbar(frame: CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 64.0))
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
            return PasswordRowType.count
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

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            guard let rowType = RowType(rawValue: indexPath.row) else {
                return 44.0
            }
            return CGFloat(rowType.rowHeight)
        default:
            return 44.0
        }

    }

    // MARK: FormControllerDelegate

    func configurationForFormController(formController: FormController, atIndexPath indexPath: NSIndexPath) -> FormCellConfiguration? {
        return rowConfigurableAtIndexPath(indexPath)?.formCellConfiguration(showTitles, model: formModel, prefilled: prefilled, accessoryView: passwordButton, passwordVisible: passwordVisible, enabled: enabledInputs)
    }

    func formController(formController: FormController, inputAccessoryViewForIndexPath indexPath: NSIndexPath) -> UIView {
        switch indexPath {
        case let confirmationIndexPath where (confirmationIndexPath.section == 2 && confirmationIndexPath.row == PasswordRowType.PasswordRowTypeNewPasswordConfirmation.rawValue):
            let toolBar = UIToolbar(frame: CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 44.0))
            let barButton = UIBarButtonItem(title: "Check passwork", style: .Plain, target: self, action: #selector(TestFormViewController.checkPasswork(_:)))
            toolBar.items = [barButton]
            return toolBar
        case let noInputIndexPath where (noInputIndexPath.section == 0 && noInputIndexPath.row == RowType.RowTypeNoInputAccessory.rawValue):
            return UIView() //TODO: (Samuel Gallet) 07/07/2016 Change the return type of this function to allow nil return
        default:
            return formController.defaultAccessoryView.view
        }
    }

    func formController(formController: FormController, valueChangedForIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            guard let rowType = RowType(rawValue: indexPath.row) else {
                return
            }
            switch (rowType) {
            case .RowTypeGender:
                formModel.gender = formController.stringValueForIndexPath(indexPath)
            case .RowTypeName:
                formModel.name = formController.stringValueForIndexPath(indexPath)
            case .RowTypeEmail:
                formModel.email = formController.stringValueForIndexPath(indexPath)
            case .RowTypePhoneNumber:
                formModel.phone = formController.stringValueForIndexPath(indexPath)
            case .RowTypeLongText:
                formModel.summary = formController.stringValueForIndexPath(indexPath)
            case .RowTypeDate:
                self.formModel.birthDate = formController.dateValueForIndexPath(indexPath)
            case .RowTypeSwitch:
                self.formModel.married = formController.boolValueForIndexPath(indexPath)
            default:
                break;
            }
        case 1:
            guard let rowType = CreditCardRowType(rawValue: indexPath.row) else {
                return
            }
            switch (rowType) {
            case .CreditCardRowTypeNumber:
                formModel.creditCard = formController.stringValueForIndexPath(indexPath)
            case .CreditCardRowTypeExpirationDate:
                formModel.expiration = formController.stringValueForIndexPath(indexPath)
            }
        default:
            return
        }
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

        let indexPath = NSIndexPath(forRow: PasswordRowType.PasswordRowTypeNewPassword.rawValue, inSection: 2)
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
    }

    func rowConfigurableAtIndexPath(indexPath: NSIndexPath) -> RowConfigurable? {
        switch indexPath.section {
        case 0:
            return RowType(rawValue: indexPath.row)
        case 1:
            return CreditCardRowType(rawValue: indexPath.row)
        case 2:
            return PasswordRowType(rawValue: indexPath.row)
        default:
            return nil;
        }
    }

    @objc private func checkPasswork(sender: UIToolbar) {
        let newPassword = formController.stringValueForIndexPath(NSIndexPath(forRow: PasswordRowType.PasswordRowTypeNewPassword.rawValue, inSection: 2))
        let confirmation = formController.stringValueForIndexPath(NSIndexPath(forRow: PasswordRowType.PasswordRowTypeNewPasswordConfirmation.rawValue, inSection: 2))
        if newPassword == confirmation {
            print("Same password \\o/")
        } else {
            print("/!\\ Password error")
        }
    }
}
