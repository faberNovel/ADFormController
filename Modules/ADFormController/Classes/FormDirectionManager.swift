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
    case Previous
    case Next
}

protocol FormDirectionManagerDelegate: class {
    func formDirectionManager(formDirectionManager: FormDirectionManager, canEditCellAtIndexPath indexPath: NSIndexPath) -> Bool
}

class FormDirectionManager : NSObject {
    weak var delegate: FormDirectionManagerDelegate?
    private unowned var tableView: UITableView
    private var lastTableViewIndexPath: NSIndexPath? {
        let lastSection = tableView.numberOfSections - 1
        guard lastSection >= 0 else {
            return nil
        }
        return lastIndexPathStartingFromSection(lastSection)
    }
    private var firstTableViewIndexPath: NSIndexPath? {
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
    func indexPathForDirection(direction: AccessoryViewDirection, andBaseIndexPath baseIndexPath: NSIndexPath?) -> NSIndexPath? {
        return baseIndexPath.flatMap {
            return nextIndexPathForDirection(direction, fromIndexPath: $0)
        }
    }

    func canMoveToDirection(direction: AccessoryViewDirection, fromIndexPath indexPath: NSIndexPath) -> Bool {
        return nextIndexPathForDirection(direction, fromIndexPath: indexPath) != nil
    }

    // MARK: Private
    private func nextIndexPathForDirection(direction: AccessoryViewDirection, fromIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        var newIndexPath: NSIndexPath?
        switch direction {
        case .Next:
            newIndexPath = indexPath.nextIndexPathInTableView(tableView)
        case .Previous:
            newIndexPath = indexPath.prevIndexPathInTableView(tableView)
        }

        guard let unwrappedIndexPath = newIndexPath else {
            return nil
        }
        guard let unwrappedDelegate = delegate where unwrappedDelegate.formDirectionManager(self, canEditCellAtIndexPath: unwrappedIndexPath) else {
            if delegate == nil {
                return unwrappedIndexPath
            }
            return nextIndexPathForDirection(direction, fromIndexPath: unwrappedIndexPath)
        }
        return unwrappedIndexPath
    }

    private func lastIndexPathStartingFromSection(section: Int) -> NSIndexPath? {
        let lastRowInSection = (tableView.numberOfRowsInSection(section) - 1)
        guard lastRowInSection > 0 else {
            return (section > 0) ? lastIndexPathStartingFromSection(section - 1) : nil
        }
        return NSIndexPath(forRow: lastRowInSection, inSection: section)
    }

    private func firstIndexPathStartingFromSection(section: Int) -> NSIndexPath? {
        let numberOfSection = tableView.numberOfSections
        guard tableView.numberOfRowsInSection(section) > 0 else {
            return section < numberOfSection ? firstIndexPathStartingFromSection(section + 1) : nil
        }
        return NSIndexPath(forRow: 0, inSection: section)
    }
}

private extension NSIndexPath {
    func nextIndexPathInTableView(tableView: UITableView) -> NSIndexPath? {
        let nextRowIndex = row + 1
        guard nextRowIndex < tableView.numberOfRowsInSection(section) else {
            var newSection = section + 1
            while  newSection < tableView.numberOfSections && tableView.numberOfRowsInSection(newSection) == 0 {
                newSection += 1
            }
            guard newSection < tableView.numberOfSections else {
                return nil
            }
            return NSIndexPath(forRow: 0, inSection: newSection)
        }
        return NSIndexPath(forRow: nextRowIndex, inSection: section)
    }

    func prevIndexPathInTableView(tableView: UITableView) -> NSIndexPath? {
        let prevRowIndex = row - 1
        guard prevRowIndex >= 0 else {
            var newSection = section - 1
            while  newSection >= 0 && tableView.numberOfRowsInSection(newSection) == 0 {
                newSection -= 1
            }
            guard newSection >= 0 else {
                return nil
            }
            return NSIndexPath(forRow: tableView.numberOfRowsInSection(newSection) - 1, inSection: newSection)
        }
        return NSIndexPath(forRow: prevRowIndex, inSection: section)
    }
}
