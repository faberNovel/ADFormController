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
    case bool(FormCellBoolConfiguration)
    case shortText(FormCellTextConfiguration)
    case longText(FormCellTextConfiguration)
}

private extension FormInput {

    func buildCell(_ cell: UITableViewCell?, accessoryView: UIView, returnKeyType: UIReturnKeyType, formController: FormController) -> UITableViewCell {
        let baseCell: FormBaseTableViewCell
        switch self {
        case let .bool(boolConfiguration):
            var cellToReturn: FormSwitchTableViewCell
            if let unwrappedCell = cell.flatMap({ $0 as? FormSwitchTableViewCell }) {
                cellToReturn = unwrappedCell
            } else {
                cellToReturn = FormSwitchTableViewCell(style: .default, reuseIdentifier: nil)
            }
            cellToReturn.apply(configuration: boolConfiguration)
            cellToReturn.delegate = formController
            baseCell = cellToReturn
        case let .shortText(textConfiguration):
            var cellToReturn: FormTextFieldTableViewCell
            if let unwrappedCell = cell.flatMap({ $0 as? FormTextFieldTableViewCell }) {
                cellToReturn = unwrappedCell
            } else {
                cellToReturn = FormTextFieldTableViewCell(style: .default, reuseIdentifier: nil)
            }
            cellToReturn.apply(configuration: textConfiguration)
            cellToReturn.inputAccessoryView = textConfiguration.inputAccessoryView ?? accessoryView
            cellToReturn.returnKeyType = returnKeyType
            cellToReturn.delegate = formController
            baseCell = cellToReturn
        case let .longText(textConfiguration):
            var cellToReturn: FormTextViewTableViewCell
            if let unwrappedCell = cell.flatMap({ $0 as? FormTextViewTableViewCell }) {
                cellToReturn = unwrappedCell
            } else {
                cellToReturn = FormTextViewTableViewCell(style: .default, reuseIdentifier: nil)
            }
            cellToReturn.apply(configuration: textConfiguration)
            cellToReturn.inputAccessoryView = textConfiguration.inputAccessoryView ?? accessoryView
            cellToReturn.returnKeyType = returnKeyType
            cellToReturn.delegate = formController
            baseCell = cellToReturn
        }
        baseCell.actionHandler = formController
        return baseCell
    }
}

@objc public enum FormControllerAction: Int {
    case leftViewTap
    case rightViewTap
}

@objc public protocol FormControllerDelegate {
    @objc(configurationForFormController:atIndexPath:)
    func configurationForFormController(_ formController: FormController, at indexPath: IndexPath) -> FormCellConfiguration?
    @objc(formController:inputAccessoryViewAtIndexPath:)
    optional func formController(_ formController: FormController, inputAccessoryViewAt indexPath: IndexPath) -> UIView
    @objc(formController:valueChangedForIndexPath:)
    optional func formController(_ formController: FormController, valueChangedFor indexPath: IndexPath)
    @objc optional func formControllerAction(_ formController: FormController)
    @objc(formController:didPerform:atIndexPath:)
    optional func formController(_ formController: FormController,
                                 didPerform action: FormControllerAction,
                                 at indexPath: IndexPath)
}

@objcMembers open class FormController: NSObject,
    FormBoolInputTableViewCellDelegate,
    FormTextInputTableViewCellDelegate,
    FormDirectionManagerDelegate,
    FormCellConfigurable,
    FormTableViewCellActionHandler {

    open weak var delegate: FormControllerDelegate?
    open var defaultAccessoryView: NavigableView {
        didSet {
            setAccessoryViewActions()
        }
    }

    private weak var tableView: UITableView?
    private let formDirectionManager: FormDirectionManager
    private var cells: [IndexPath: UITableViewCell] = [:]

    //MARK: - Init

    public init(tableView: UITableView) {
        self.tableView = tableView
        formDirectionManager = FormDirectionManager(tableView: tableView)
        defaultAccessoryView = TextInputAccessoryView(
            frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44.0)
        )
        super.init()
        formDirectionManager.delegate = self
        setAccessoryViewActions()
    }

    //MARK: - Methods

    @objc(stringValueAtIndexPath:)
    open func stringValue(at indexPath: IndexPath) -> String {
        guard let cell = tableView?.cellForRow(at: indexPath) as? FormTextInputTableViewCell else {
            return ""
        }
        guard let textToReturn = cell.textContent else {
            return ""
        }
        return textToReturn
    }

    @objc(boolValueAtIndexPath:)
    open func boolValue(at indexPath: IndexPath) -> Bool {
        guard let cell = tableView?.cellForRow(at: indexPath) as? FormBoolInputTableViewCell else {
            return false
        }
        return cell.boolContent
    }

    @objc(dateValueAtIndexPath:)
    open func dateValue(at indexPath: IndexPath) -> Date? {
        guard let cell = tableView?.cellForRow(at: indexPath) as? FormTextFieldTableViewCell else {
            return nil
        }
        guard let configuration = delegate?.configurationForFormController(self, at: indexPath) as? FormCellTextConfiguration else {
            return nil
        }
        return cell.textField.text.flatMap {
            configuration.dateFormatter?.date(from: $0)
        }
    }

    @objc(cellForRowAtIndexPath:)
    open func cellForRow(at indexPath: IndexPath) -> UITableViewCell {
        guard let configuration = delegate?.configurationForFormController(self, at: indexPath) else {
            return UITableViewCell()
        }
        return configuration.visit(self, at: indexPath)
    }

    @objc(beginEditingAtIndexPath:)
    open func beginEditing(at indexPath: IndexPath) {
        let targetCell = tableView?.cellForRow(at: indexPath) as? FormTextInputTableViewCell
        targetCell?.beginEditing()
    }

    //MARK: - FormCellConfigurable

    open func boolInputCell(with configuration: FormCellBoolConfiguration, at indexPath:IndexPath) -> UITableViewCell {
        return FormInput.bool(configuration).buildCell(
            cells[indexPath],
            accessoryView: defaultAccessoryView.view,
            returnKeyType: returnKeyType(at: indexPath),
            formController: self
        )
    }

    open func textInputCell(with configuration: FormCellTextConfiguration, at indexPath:IndexPath) -> UITableViewCell {
        let accessoryView = delegate?.formController?(self, inputAccessoryViewAt: indexPath) ?? defaultAccessoryView.view
        let input = (configuration.cellType == .longText) ? FormInput.longText(configuration) : FormInput.shortText(configuration)
        return input.buildCell(
            cells[indexPath],
            accessoryView: accessoryView,
            returnKeyType: returnKeyType(at: indexPath),
            formController: self
        )
    }

    // MARK: - FormTableViewCellActionHandler

    func handleLeftViewAction(from cell: FormBaseTableViewCell) {
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        delegate?.formController?(self, didPerform: .leftViewTap, at: indexPath)
    }

    func handleRightViewAction(from cell: FormBaseTableViewCell) {
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        delegate?.formController?(self, didPerform: .rightViewTap, at: indexPath)
    }

    //MARK: - FormBoolInputTableViewCellDelegate

    func boolInputTableViewCellDidChangeValue(_ cell: FormBoolInputTableViewCell) {
        guard
            let tableViewCell = cell as? UITableViewCell,
            let indexPath = tableView?.indexPath(for: tableViewCell) else {
                return
        }
        delegate?.formController?(self, valueChangedFor: indexPath)
    }

    //MARK: - FormTextInputTableViewCellDelegate

    func textInputTableViewCellValueChanged(_ cell: FormTextInputTableViewCell) {
        guard
            let tableViewCell = cell as? UITableViewCell,
            let indexPath = tableView?.indexPath(for: tableViewCell) else {
                return
        }
        delegate?.formController?(self, valueChangedFor: indexPath)
    }

    func textInputTableViewCellDidBeginEditing(_ cell: FormTextInputTableViewCell) {
        updateInputAccessoryView()
    }

    func textInputTableViewCellShouldReturn(_ cell: FormTextInputTableViewCell) -> Bool {
        guard
            let tableViewCell = cell as? UITableViewCell,
            let indexPath = tableView?.indexPath(for: tableViewCell) else {
                return false
        }
        // Use custom returnAction if any
        if let configuration = validConfigurationForReturnAction(at: indexPath),
            let returnAction = configuration.returnAction {
            return returnAction()
        }
        if formDirectionManager.canMove(to: .next, from: indexPath) {
            move(to: .next, from: indexPath)
            return false
        }
        delegate?.formControllerAction?(self)
        return true
    }

    //MARK: - FormDirectionManagerDelegate

    func formDirectionManager(_ formDirectionManager: FormDirectionManager, canEditCellAt indexPath: IndexPath) -> Bool {
        guard
            let tableView = tableView,
            let configuration = delegate?.configurationForFormController(self, at: indexPath) else {
                return false
        }
        let cell = tableView.cellForRow(at: indexPath) ?? tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath)
        return cell is FormTextInputTableViewCell
            && configuration.enabled
    }

    //MARK: - Private

    @objc private func next(_ sender: UIBarButtonItem) {
        move(to: .next)
    }

    @objc private func previous(_ sender: UIBarButtonItem) {
        move(to: .previous)
    }

    private func indexPathForFirstResponder() -> IndexPath? {
        guard let tableView = tableView else { return nil }
        return tableView.findFirstResponder().flatMap {
            guard $0 is UITextInput else {
                return nil
            }
            guard let cell: UITableViewCell = $0.superViewFromClass() else {
                return nil
            }
            return tableView.indexPath(for: cell)
        }
    }

    private func move(to direction: AccessoryViewDirection) {
        guard let indexPath = indexPathForFirstResponder() else {
            return
        }
        move(to: direction, from: indexPath)
    }

    private func move(to direction: AccessoryViewDirection, from indexPath: IndexPath) {
        guard let nextIndexPath = formDirectionManager.indexPath(for: direction, baseIndexPath: indexPath) else {
            return
        }
        // In order to correctly assignFirstResponder to the nextCell we need for it to be loaded
        // in the view hierarchy, to do so there is currently no other way than making the tableView
        // load it by scrolling to it.
        // Unfortunatly it's impossible to scroll with a completion so we have to perform the scroll
        // without animation to make sure that the cell is loaded into the view hierarchy when we call
        // cell.beginEditing()
        if tableView?.cellForRow(at: nextIndexPath) == nil {
            tableView?.scrollToRow(at: nextIndexPath, at: .none, animated: false)
        }
        guard let cell = tableView?.cellForRow(at: nextIndexPath) as? FormTextInputTableViewCell else {
            return
        }
        cell.beginEditing()
    }

    private func updateInputAccessoryView() {
        guard let indexPath = indexPathForFirstResponder() else {
            return
        }
        defaultAccessoryView.nextBarButtonItem.isEnabled = formDirectionManager.canMove(to: .next, from: indexPath)
        defaultAccessoryView.previousBarButtonItem.isEnabled = formDirectionManager.canMove(to: .previous, from: indexPath)
    }

    private func returnKeyType(at indexPath: IndexPath) -> UIReturnKeyType {
        // Use custom returnKeyType if any
        if let configuration = validConfigurationForReturnAction(at: indexPath),
            let returnKeyType = configuration.returnKeyType {
            return returnKeyType
        }
        // Default implementation
        guard let tableView = tableView else { return .default }
        let lastSection = tableView.numberOfSections - 1
        guard lastSection > 0 else { return .default }
        let isLastSection = indexPath.section == lastSection
        let isLastRow = indexPath.row == tableView.numberOfRows(inSection: lastSection) - 1
        return (isLastRow && isLastSection) ? .go : .next
    }

    private func textInputTableViewCell<T: FormTextInputTableViewCell>(at indexPath: IndexPath) -> T? {
        return tableView?.cellForRow(at: indexPath) as? T
    }

    private func setAccessoryViewActions() {
        defaultAccessoryView.nextBarButtonItem.target = self
        defaultAccessoryView.nextBarButtonItem.action = #selector(FormController.next(_:))

        defaultAccessoryView.previousBarButtonItem.target = self
        defaultAccessoryView.previousBarButtonItem.action = #selector(FormController.previous(_:))
    }

    private func validConfigurationForReturnAction(at indexPath: IndexPath) -> FormCellTextConfiguration? {
        guard
            let configuration = delegate?.configurationForFormController(self, at: indexPath) as? FormCellTextConfiguration,
            configuration.returnKeyType != nil,
            configuration.returnAction != nil else {
                return nil
        }
        return configuration
    }
}
