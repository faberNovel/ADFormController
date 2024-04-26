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

protocol FormDirectionManagerDelegate: AnyObject {
    func formDirectionManager(_ formDirectionManager: FormDirectionManager, canEditCellAtIndexPath indexPath: IndexPath) -> Bool
}

class FormDirectionManager : NSObject {
    weak var delegate: FormDirectionManagerDelegate?
    private unowned var tableView: UITableView
    private var lastTableViewIndexPath: IndexPath? {
        let lastSection = tableView.numberOfSections - 1
        guard lastSection >= 0 else {
            return nil
        }
        return lastIndexPathStartingFromSection(lastSection)
    }
    private var firstTableViewIndexPath: IndexPath? {
        guard tableView.numberOfSections > 0 else {
            return nil
        }
        return firstIndexPathStartingFromSection(0)
    }

    // MARK: LifeCycle
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
    }

    // MARK: FormDirectionManager
    func indexPathForDirection(_ direction: AccessoryViewDirection, andBaseIndexPath baseIndexPath: IndexPath?) -> IndexPath? {
        return baseIndexPath.flatMap {
            return nextIndexPathForDirection(direction, fromIndexPath: $0)
        }
    }

    func canMoveToDirection(_ direction: AccessoryViewDirection, fromIndexPath indexPath: IndexPath) -> Bool {
        return nextIndexPathForDirection(direction, fromIndexPath: indexPath) != nil
    }

    // MARK: Private
    private func nextIndexPathForDirection(_ direction: AccessoryViewDirection, fromIndexPath indexPath: IndexPath) -> IndexPath? {
        var newIndexPath: IndexPath?
        switch direction {
        case .next:
            newIndexPath = indexPath.nextIndexPathInTableView(tableView)
        case .previous:
            newIndexPath = indexPath.prevIndexPathInTableView(tableView)
        }

        guard let unwrappedIndexPath = newIndexPath else {
            return nil
        }
        guard let unwrappedDelegate = delegate, unwrappedDelegate.formDirectionManager(self, canEditCellAtIndexPath: unwrappedIndexPath) else {
            if delegate == nil {
                return unwrappedIndexPath
            }
            return nextIndexPathForDirection(direction, fromIndexPath: unwrappedIndexPath)
        }
        return unwrappedIndexPath
    }

    private func lastIndexPathStartingFromSection(_ section: Int) -> IndexPath? {
        let lastRowInSection = (tableView.numberOfRows(inSection: section) - 1)
        guard lastRowInSection > 0 else {
            return (section > 0) ? lastIndexPathStartingFromSection(section - 1) : nil
        }
        return IndexPath(row: lastRowInSection, section: section)
    }

    private func firstIndexPathStartingFromSection(_ section: Int) -> IndexPath? {
        let numberOfSection = tableView.numberOfSections
        guard tableView.numberOfRows(inSection: section) > 0 else {
            return section < numberOfSection ? firstIndexPathStartingFromSection(section + 1) : nil
        }
        return IndexPath(row: 0, section: section)
    }
}

private extension IndexPath {
    func nextIndexPathInTableView(_ tableView: UITableView) -> IndexPath? {
        let nextRowIndex = row + 1
        guard nextRowIndex < tableView.numberOfRows(inSection: section) else {
            var newSection = section + 1
            while  newSection < tableView.numberOfSections && tableView.numberOfRows(inSection: newSection) == 0 {
                newSection += 1
            }
            guard newSection < tableView.numberOfSections else {
                return nil
            }
            return IndexPath(row: 0, section: newSection)
        }
        return IndexPath(row: nextRowIndex, section: section)
    }

    func prevIndexPathInTableView(_ tableView: UITableView) -> IndexPath? {
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
