//
//  FormController.swift
//  Pods
//
//  Created by Samuel Gallet on 08/07/16.
//
//

import UIKit
import ADKeyboardManager

private enum FormInput {
    case Bool(ADFormCellBoolConfiguration)
    case ShortText(ADFormCellTextConfiguration)
    case LongText(ADFormCellTextConfiguration)
}

private extension FormInput {
    func buildCell(cell: UITableViewCell?, accessoryView: UIView, returnKeyType: UIReturnKeyType, formController: FormController) -> UITableViewCell {
        switch self {
        case let .Bool(boolConfiguration):
            var cellToReturn: FormSwitchTableViewCell
            if let unwrappedCell = cell.flatMap({ $0 as? FormSwitchTableViewCell }) {
                cellToReturn = unwrappedCell
            } else {
                cellToReturn = FormSwitchTableViewCell(style: .Default, reuseIdentifier: nil)
            }
            cellToReturn.applyConfiguration(boolConfiguration)
            cellToReturn.delegate = formController
            return cellToReturn
        case let .ShortText(textConfiguration):
            var cellToReturn: FormTextFieldTableViewCell
            if let unwrappedCell = cell.flatMap({ $0 as? FormTextFieldTableViewCell }) {
                cellToReturn = unwrappedCell
            } else {
                cellToReturn = FormTextFieldTableViewCell(style: .Default, reuseIdentifier: nil)
            }
            cellToReturn.applyConfiguration(textConfiguration)
            cellToReturn.inputAccessoryView = accessoryView
            cellToReturn.returnKeyType = returnKeyType
            cellToReturn.delegate = formController
            return cellToReturn
        case let .LongText(textConfiguration):
            var cellToReturn: FormTextViewTableViewCell
            if let unwrappedCell = cell.flatMap({ $0 as? FormTextViewTableViewCell }) {
                cellToReturn = unwrappedCell
            } else {
                cellToReturn = FormTextViewTableViewCell(style: .Default, reuseIdentifier: nil)
            }
            cellToReturn.applyConfiguration(textConfiguration)
            cellToReturn.inputAccessoryView = accessoryView
            cellToReturn.returnKeyType = returnKeyType
            cellToReturn.delegate = formController
            return cellToReturn
        }
    }
}

@objc public protocol FormControllerDelegate {
    func configurationForFormController(formController: FormController, atIndexPath indexPath: NSIndexPath) -> ADFormCellConfiguration?
    optional func formController(formController: FormController, inputAccessoryViewAtIndexPath indexPath: NSIndexPath) -> UIView
    optional func formController(formController: FormController, valueChangedForIndexPath indexPath: NSIndexPath)
    optional func formControllerAction(formController: FormController)
}

@objc public class FormController: NSObject , FormBoolInputTableViewCellDelegate, FormTextInputTableViewCellDelegate, FormDirectionManagerDelegate, FormCellConfigurable {
    public weak var delegate: FormControllerDelegate?
    public var defaultAccessoryView: NavigableView {
        didSet {
            setAccessoryViewActions()
        }
    }

    private unowned let tableView: UITableView
    private let formDirectionManager: FormDirectionManager
    private var cells: [NSIndexPath: UITableViewCell] = [:]

    // MARK: Methods
    public init(tableView: UITableView) {
        self.tableView = tableView
        formDirectionManager = FormDirectionManager(tableView: tableView)
        defaultAccessoryView = TextInputAccessoryView(frame: CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 44.0))
        super.init()
        formDirectionManager.delegate = self
        setAccessoryViewActions()
    }

    // MARK: Methods
    public func stringValueForIndexPath(indexPath: NSIndexPath) -> String {
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? FormTextInputTableViewCell else {
            return ""
        }
        guard let textToReturn = cell.textContent else {
            return ""
        }
        return textToReturn
    }

    public func boolValueForIndexPath(indexPath: NSIndexPath) -> Bool {
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? FormBoolInputTableViewCell else {
            return false
        }
        return cell.boolContent
    }

    public func dateValueForIndexPath(indexPath: NSIndexPath) -> NSDate? {
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? FormTextFieldTableViewCell else {
            return nil
        }
        guard let configuration = delegate?.configurationForFormController(self, atIndexPath: indexPath) as? ADFormCellTextConfiguration else {
            return nil
        }
        return cell.textField.text.flatMap {
            configuration.dateFormatter?.dateFromString($0)
        }
    }

    public func cellForRowAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        guard let configuration = delegate?.configurationForFormController(self, atIndexPath: indexPath) else {
            return UITableViewCell()
        }
        return configuration.visit(self, atIndexPath: indexPath)
    }

    // MARK: FormCellConfigurable
    public func boolInputCellWithConfiguration(configuration: ADFormCellBoolConfiguration, atIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        return FormInput.Bool(configuration).buildCell(cells[indexPath],
                                                       accessoryView: defaultAccessoryView.view,
                                                       returnKeyType: returnKeyTypeAtIndexPath(indexPath),
                                                       formController: self)
    }

    public func textInputCellWithConfiguration(configuration: ADFormCellTextConfiguration, atIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        var accessoryView = delegate?.formController?(self, inputAccessoryViewAtIndexPath: indexPath)
        if accessoryView == nil {
            accessoryView = defaultAccessoryView.view
        }
        let input = (configuration.cellType == .LongText) ? FormInput.LongText(configuration) : FormInput.ShortText(configuration)
        return input.buildCell(cells[indexPath],
                               accessoryView: accessoryView!,
                               returnKeyType: returnKeyTypeAtIndexPath(indexPath),
                               formController: self)
    }

    // MARK: FormBoolInputTableViewCellDelegate

    public func boolInputTableViewCellDidChangeValue(cell: FormBoolInputTableViewCell) {
        guard let indexPath = tableView.indexPathForCell(cell as! UITableViewCell) else {
            return
        }
        delegate?.formController?(self, valueChangedForIndexPath: indexPath)
    }

    // MARK: FormTextInputTableViewCellDelegate

    public func textInputTableViewCellValueChanged(cell: FormTextInputTableViewCell) {
        guard let indexPath = tableView.indexPathForCell(cell as! UITableViewCell) else {
            return
        }
        delegate?.formController?(self, valueChangedForIndexPath: indexPath)
    }

    public func textInputTableViewCellDidBeginEditing(cell: FormTextInputTableViewCell) {
        updateInputAccessoryView()
    }

    public func textInputTableViewCellShouldReturn(cell: FormTextInputTableViewCell) -> Bool {
        guard let indexPath = tableView.indexPathForCell(cell as! UITableViewCell) else {
            return false
        }
        if formDirectionManager.canMoveToDirection(.Next, fromIndexPath: indexPath) {
            moveToDirection(.Next, fromIndexPath: indexPath)
            return false
        }
        delegate?.formControllerAction?(self)
        return true
    }

    // MARK: FormDirectionManagerDelegate

    public func formDirectionManager(formDirectionManager: FormDirectionManager, canEditCellAtIndexPath indexPath: NSIndexPath) -> Bool {
        return tableView.cellForRowAtIndexPath(indexPath) is FormTextFieldTableViewCell
    }

    // MARK: Private
    @objc private func next(sender: UIBarButtonItem) {
        moveToDirection(.Next)
    }

    @objc private func previous(sender: UIBarButtonItem) {
        moveToDirection(.Previous)
    }

    private func indexPathForFirstResponder() -> NSIndexPath? {
        return tableView.findFirstResponder().flatMap {
            guard $0 is UITextInput else {
                return nil
            }
            guard let cell: UITableViewCell = $0.superViewFromClass() else {
                return nil
            }
            return tableView.indexPathForCell(cell)
        }
    }

    private func moveToDirection(direction: AccessoryViewDirection) {
        guard let indexPath = indexPathForFirstResponder() else {
            return
        }
        moveToDirection(direction, fromIndexPath: indexPath)
    }

    private func moveToDirection(direction: AccessoryViewDirection, fromIndexPath indexPath: NSIndexPath) {
        guard let nextIndexPath = formDirectionManager.indexPathForDirection(direction, andBaseIndexPath: indexPath) else {
            return
        }
        guard let cell = tableView.cellForRowAtIndexPath(nextIndexPath) as? FormTextInputTableViewCell else {
            return
        }
        cell.beginEditing()
    }

    private func updateInputAccessoryView() {
        guard let indexPath = indexPathForFirstResponder() else {
            return
        }
        defaultAccessoryView.nextBarButtonItem.enabled = formDirectionManager.canMoveToDirection(.Next, fromIndexPath: indexPath)
        defaultAccessoryView.previousBarButtonItem.enabled = formDirectionManager.canMoveToDirection(.Previous, fromIndexPath: indexPath)
    }

    private func returnKeyTypeAtIndexPath(indexPath: NSIndexPath) -> UIReturnKeyType {
        let lastSection = tableView.numberOfSections - 1
        guard lastSection > 0 else {
            return .Default
        }
        let isLastSection = indexPath.section == lastSection
        let isLastRow = indexPath.row == tableView.numberOfRowsInSection(lastSection) - 1
        return (isLastRow && isLastSection) ? .Go : .Next
    }

    private func textInputTableViewCellAtIndexPath<T: FormTextInputTableViewCell>(indexPath: NSIndexPath) -> T? {
        return tableView.cellForRowAtIndexPath(indexPath) as? T
    }

    private func setAccessoryViewActions() {
        defaultAccessoryView.nextBarButtonItem.target = self;
        defaultAccessoryView.nextBarButtonItem.action = #selector(FormController.next(_:));

        defaultAccessoryView.previousBarButtonItem.target = self;
        defaultAccessoryView.previousBarButtonItem.action = #selector(FormController.previous(_:));
    }
}
