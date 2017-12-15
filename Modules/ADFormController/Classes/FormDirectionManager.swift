//
//  FormDirectionManager.swift
//  Pods
//
//  Created by Samuel Gallet on 08/07/16.
//
//

import UIKit

//TODO: (Samuel Gallet) 08/07/2016 Associate indexPath to enum
enum AccessoryViewDirection: Int {
    case previous
    case next
}

protocol FormDirectionManagerDelegate: class {
    func formDirectionManager(_ formDirectionManager: FormDirectionManager, canEditCellAt indexPath: IndexPath) -> Bool
}

class FormDirectionManager : NSObject {

    weak var delegate: FormDirectionManagerDelegate?
    private weak var tableView: UITableView?

    //MARK: - Computed var

    private var lastTableViewIndexPath: IndexPath? {
        guard let tableView = tableView else { return nil }
        let lastSection = tableView.numberOfSections - 1
        guard lastSection >= 0 else { return nil }
        return lastIndexPath(startingFromSection: lastSection)
    }

    private var firstTableViewIndexPath: IndexPath? {
        guard let tableView = tableView else { return nil }
        guard tableView.numberOfSections > 0 else { return nil }
        return firstIndexPath(startingFromSection: 0)
    }

    //MARK: - Life cycle

    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
    }

    //MARK: - FormDirectionManager

    func indexPath(for direction: AccessoryViewDirection, baseIndexPath: IndexPath?) -> IndexPath? {
        return baseIndexPath.flatMap {
            return nextIndexPath(for: direction, from: $0)
        }
    }

    func canMove(to direction: AccessoryViewDirection, from indexPath: IndexPath) -> Bool {
        return nextIndexPath(for: direction, from: indexPath) != nil
    }

    //MARK: - Private

    private func nextIndexPath(for direction: AccessoryViewDirection, from indexPath: IndexPath) -> IndexPath? {
        guard let tableView = tableView else { return nil }
        var newIndexPath: IndexPath?
        switch direction {
        case .next:
            newIndexPath = indexPath.nextIndexPath(in: tableView)
        case .previous:
            newIndexPath = indexPath.previousIndexPath(in: tableView)
        }

        guard let unwrappedIndexPath = newIndexPath else { return nil }
        guard let unwrappedDelegate = delegate, unwrappedDelegate.formDirectionManager(self, canEditCellAt: unwrappedIndexPath) else {
            if delegate == nil {
                return unwrappedIndexPath
            }
            return nextIndexPath(for: direction, from: unwrappedIndexPath)
        }
        return unwrappedIndexPath
    }

    private func lastIndexPath(startingFromSection section: Int) -> IndexPath? {
        guard let tableView = tableView else { return nil }
        let lastRowInSection = (tableView.numberOfRows(inSection: section) - 1)
        guard lastRowInSection > 0 else {
            return (section > 0) ? lastIndexPath(startingFromSection: section - 1) : nil
        }
        return IndexPath(row: lastRowInSection, section: section)
    }

    private func firstIndexPath(startingFromSection section: Int) -> IndexPath? {
        guard let tableView = tableView else { return nil }
        let numberOfSection = tableView.numberOfSections
        guard tableView.numberOfRows(inSection: section) > 0 else {
            return section < numberOfSection ? firstIndexPath(startingFromSection: section + 1) : nil
        }
        return IndexPath(row: 0, section: section)
    }
}

private extension IndexPath {

    func nextIndexPath(in tableView: UITableView) -> IndexPath? {
        let nextRowIndex = row + 1
        guard nextRowIndex < tableView.numberOfRows(inSection: section) else {
            var newSection = section + 1
            while newSection < tableView.numberOfSections && tableView.numberOfRows(inSection: newSection) == 0 {
                newSection += 1
            }
            guard newSection < tableView.numberOfSections else {
                return nil
            }
            return IndexPath(row: 0, section: newSection)
        }
        return IndexPath(row: nextRowIndex, section: section)
    }

    func previousIndexPath(in tableView: UITableView) -> IndexPath? {
        let prevRowIndex = row - 1
        guard prevRowIndex >= 0 else {
            var newSection = section - 1
            while  newSection >= 0 && tableView.numberOfRows(inSection: newSection) == 0 {
                newSection -= 1
            }
            guard newSection >= 0 else {
                return nil
            }
            return IndexPath(row: tableView.numberOfRows(inSection: newSection) - 1, section: newSection)
        }
        return IndexPath(row: prevRowIndex, section: section)
    }
}
