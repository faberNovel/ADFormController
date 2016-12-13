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
    var alignment: NSTextAlignment = .left

    static let dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
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
        let button = UIButton(type: .custom)
        button.setTitle("Show", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.italicSystemFont(ofSize: 10.0)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
        button.sizeToFit()
        return button
    }()

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .onDrag

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Print", style: .plain, target: self, action: #selector(TestFormViewController.printValue))

        passwordButton.addTarget(self, action: #selector(TestFormViewController.togglePassword), for: .touchUpInside)
        if shouldSetCustomAccessoryView {
            formController.defaultAccessoryView = EnglishAccessoryToolbar(frame: CGRect(x: 0, y: 0, width: (tableView.bounds).width, height: 64.0))
        }
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return formController.cellForRowAtIndexPath(indexPath)
    }

    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0;
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return rowConfigurableAtIndexPath(IndexPath(row: 0, section: section))?.title
    }

    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
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

    public func configurationForFormController(_ formController: FormController, atIndexPath indexPath: IndexPath) -> FormCellConfiguration? {
        return rowConfigurableAtIndexPath(indexPath as IndexPath)?.formCellConfiguration(showTitle: showTitles, model: formModel, prefilled: prefilled, accessoryView: passwordButton, passwordVisible: passwordVisible, enabled: enabledInputs, alignment: alignment)
    }

    func formController(_ formController: FormController, inputAccessoryViewAtIndexPath indexPath: IndexPath) -> UIView {
        switch indexPath {
        case let confirmationIndexPath where (confirmationIndexPath.section == 2 && confirmationIndexPath.row == PasswordRowType.newPasswordConfirmation.rawValue):
            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44.0))
            let barButton = UIBarButtonItem(title: "Check passwork", style: .plain, target: self, action: #selector(TestFormViewController.checkPasswork(_:)))
            toolBar.items = [barButton]
            return toolBar
        case let noInputIndexPath where (noInputIndexPath.section == 0 && noInputIndexPath.row == RowType.noInputAccessory.rawValue):
            return UIView() //TODO: (Samuel Gallet) 07/07/2016 Change the return type of this function to allow nil return
        default:
            return formController.defaultAccessoryView.view
        }
    }

    func formController(_ formController: FormController, valueChangedForIndexPath indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            guard let rowType = RowType(rawValue: indexPath.row) else {
                return
            }
            switch rowType {
            case .gender:
                formModel.gender = formController.stringValueForIndexPath(indexPath)
            case .name:
                formModel.name = formController.stringValueForIndexPath(indexPath)
            case .email:
                formModel.email = formController.stringValueForIndexPath(indexPath)
            case .phoneNumber:
                formModel.phone = formController.stringValueForIndexPath(indexPath)
            case .longText:
                formModel.summary = formController.stringValueForIndexPath(indexPath)
            case .date:
                self.formModel.birthDate = formController.dateValueForIndexPath(indexPath)
            case .switch:
                self.formModel.married = formController.boolValueForIndexPath(indexPath)
            default:
                break;
            }
        case 1:
            guard let rowType = CreditCardRowType(rawValue: indexPath.row) else {
                return
            }
            switch (rowType) {
            case .number:
                formModel.creditCard = formController.stringValueForIndexPath(indexPath)
            case .expirationDate:
                formModel.expiration = formController.stringValueForIndexPath(indexPath)
            }
        default:
            return
        }
    }

    // MARK: Private
    @objc private func printValue () {
        let isMarried = formController.boolValueForIndexPath(IndexPath(row: 0, section: 0))
        DDLogInfo("Married =  \(isMarried)");
    }

    @objc private func togglePassword () {
        passwordVisible = !passwordVisible;
        let title = passwordVisible ? "Hide" : "Show"
        passwordButton.setTitle(title, for: .normal)

        let indexPath = IndexPath(row: PasswordRowType.newPassword.rawValue, section: 2)
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    func rowConfigurableAtIndexPath(_ indexPath: IndexPath) -> RowConfigurable? {
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

    @objc private func checkPasswork(_ sender: UIToolbar) {
        let newPassword = formController.stringValueForIndexPath(IndexPath(row: PasswordRowType.newPassword.rawValue, section: 2))
        let confirmation = formController.stringValueForIndexPath(IndexPath(row: PasswordRowType.newPasswordConfirmation.rawValue, section: 2))
        if newPassword == confirmation {
            print("Same password \\o/")
        } else {
            print("/!\\ Password error")
        }
    }
}
