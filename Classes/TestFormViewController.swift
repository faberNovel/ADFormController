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

    static let dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()

    static let timeFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()

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
    var forceEnableFirstAndLastInput = false
    var alignment: NSTextAlignment = .left
    var separatorInset: UIEdgeInsets? = nil
    var useCustomReturnAction = false
    private var formModel = FormModel()
    private var passwordVisible = false
    private lazy var formController : FormController = self.createFormController()
    private lazy var passwordButton: UIButton = self.createPasswordButton()

    //MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .onDrag
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Print",
            style: .plain,
            target: self,
            action: #selector(TestFormViewController.printValue)
        )
        passwordButton.addTarget(
            self,
            action: #selector(TestFormViewController.togglePassword),
            for: .touchUpInside
        )
        if shouldSetCustomAccessoryView {
            formController.defaultAccessoryView = EnglishAccessoryToolbar(
                frame: CGRect(x: 0, y: 0, width: (tableView.bounds).width, height: 64.0)
            )
        }
    }

    //MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return RowType.allCases.count
        case 1:
            return CreditCardRowType.allCases.count
        case 2:
            return PasswordRowType.allCases.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return formController.cellForRow(at: indexPath)
    }

    //MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return rowConfigurable(at: IndexPath(row: 0, section: section))?.title
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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

    //MARK: - FormControllerDelegate

    func configurationForFormController(_ formController: FormController, at indexPath: IndexPath) -> FormCellConfiguration? {
        return rowConfigurable(at: indexPath)?.formCellConfiguration(
            showTitle: showTitles,
            model: formModel,
            accessoryView: passwordButton,
            passwordVisible: passwordVisible,
            enabled: enableInput(at: indexPath),
            useCustomReturnAction: useCustomReturnAction,
            alignment: alignment,
            separatorInset: separatorInset
        )
    }

    func formController(_ formController: FormController, inputAccessoryViewAt indexPath: IndexPath) -> UIView {
        switch indexPath {
        case let confirmationIndexPath where (confirmationIndexPath.section == 2 && confirmationIndexPath.row == PasswordRowType.newPasswordConfirmation.rawValue):
            let toolBar = UIToolbar(
                frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44.0)
            )
            let barButton = UIBarButtonItem(
                title: "Check passwork",
                style: .plain,
                target: self,
                action: #selector(TestFormViewController.checkPasswork(_:))
            )
            toolBar.items = [barButton]
            return toolBar
        case let noInputIndexPath where (noInputIndexPath.section == 0 && noInputIndexPath.row == RowType.noInputAccessory.rawValue):
            return UIView() //TODO: (Samuel Gallet) 07/07/2016 Change the return type of this function to allow nil return
        default:
            return formController.defaultAccessoryView.view
        }
    }

    func formController(_ formController: FormController, valueChangedFor indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            guard let rowType = RowType(rawValue: indexPath.row) else {
                return
            }
            switch rowType {
            case .gender:
                formModel.gender = formController.stringValue(at: indexPath)
            case .name:
                formModel.name = formController.stringValue(at: indexPath)
            case .email:
                formModel.email = formController.stringValue(at: indexPath)
            case .phoneNumber:
                formModel.phone = formController.stringValue(at: indexPath)
            case .longText:
                formModel.summary = formController.stringValue(at: indexPath)
            case .date:
                self.formModel.birthDate = formController.dateValue(at: indexPath)
            case .time:
                self.formModel.birthDate = formController.dateValue(at: indexPath)
            case .switch:
                self.formModel.married = formController.boolValue(at: indexPath)
            default:
                break
            }
        case 1:
            guard let rowType = CreditCardRowType(rawValue: indexPath.row) else {
                return
            }
            switch rowType {
            case .number:
                formModel.creditCard = formController.stringValue(at: indexPath)
            case .expirationDate:
                formModel.expiration = formController.stringValue(at: indexPath)
            }
        case 2:
            guard let rowType = PasswordRowType(rawValue: indexPath.row) else {
                return
            }
            switch rowType {
            case .newPassword:
                formModel.password = formController.stringValue(at: indexPath)
            case .newPasswordConfirmation:
                formModel.passwordConfirmation = formController.stringValue(at: indexPath)
            }
        default:
            break
        }
    }

    func formController(_ formController: FormController,
                        didPerform action: FormControllerAction,
                        at indexPath: IndexPath) {
        switch action {
        case .leftViewTap:
            break
        case .rightViewTap:
            formController.beginEditing(at: indexPath)
        }
    }

    //MARK: - Private

    private func createFormController() -> FormController {
        let formController = FormController(tableView: self.tableView)
        formController.delegate = self
        return formController
    }

    private func createPasswordButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle("Show", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.italicSystemFont(ofSize: 10.0)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }

    @objc private func printValue () {
        let indexPath = IndexPath(row: RowType.switch.rawValue, section: 0)
        let isMarried = formController.boolValue(at: indexPath)
        DDLogInfo("Married = \(isMarried)")
    }

    @objc private func togglePassword () {
        passwordVisible = !passwordVisible
        let title = passwordVisible ? "Hide" : "Show"
        passwordButton.setTitle(title, for: .normal)

        let indexPath = IndexPath(row: PasswordRowType.newPassword.rawValue, section: 2)
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    func rowConfigurable(at indexPath: IndexPath) -> RowConfigurable? {
        switch indexPath.section {
        case 0:
            return RowType(rawValue: indexPath.row)
        case 1:
            return CreditCardRowType(rawValue: indexPath.row)
        case 2:
            return PasswordRowType(rawValue: indexPath.row)
        default:
            return nil
        }
    }

    @objc private func checkPasswork(_ sender: UIToolbar) {
        let passwordIndexPath = IndexPath(row: PasswordRowType.newPassword.rawValue, section: 2)
        let passwordConfirmationIndexPath = IndexPath(row: PasswordRowType.newPasswordConfirmation.rawValue, section: 2)
        let newPassword = formController.stringValue(at: passwordIndexPath)
        let confirmation = formController.stringValue(at: passwordConfirmationIndexPath)
        if newPassword == confirmation {
            print("Same password \\o/")
        } else {
            print("/!\\ Password error")
        }
    }

    private func enableInput(at indexPath: IndexPath) -> Bool {
        guard forceEnableFirstAndLastInput && !enabledInputs else {
            return enabledInputs
        }
        return isFirstOrLastCell(indexPath)
    }

    private func isFirstOrLastCell(_ indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 && indexPath.section == 0 {
            return true
        }
        let lastSection = numberOfSections(in: tableView) - 1
        let lastRowsInLastSection = tableView(tableView, numberOfRowsInSection: lastSection) - 1
        return indexPath.section == lastSection && indexPath.row == lastRowsInLastSection
    }
}
