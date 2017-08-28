//
//  FormDirectionManagerTests.swift
//  FormDemo
//
//  Created by Samuel Gallet on 12/07/16.
//
//

import XCTest
import ADFormController


class FormDirectionManagerTests: XCTestCase, FormDirectionManagerDelegate {

    private let tableView = StubTableView(frame: CGRect.zero)

    private lazy var directionManager: FormDirectionManager = {
        let directionManager = FormDirectionManager(tableView: self.tableView)
        directionManager.delegate = self
        return directionManager
    }()

    private var disableDelegateOnce: Bool = false

    override func setUp() {
        super.setUp()
        directionManager.delegate = self
        disableDelegateOnce = false
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSimpleNext() {
        let indexPath = directionManager.indexPathForDirection(.next, andBaseIndexPath: IndexPath(row: 0, section: StubTableViewSection.first.rawValue))
        let expectedIndexPath = IndexPath(row: 1, section: StubTableViewSection.first.rawValue)
        XCTAssert(indexPath == expectedIndexPath)
    }

    func testSimplePrev() {
        let indexPath = directionManager.indexPathForDirection(.previous, andBaseIndexPath: IndexPath(row: 4, section: StubTableViewSection.third.rawValue))
        let expectedIndexPath = IndexPath(row: 3, section: StubTableViewSection.third.rawValue)
        XCTAssert(indexPath == expectedIndexPath)
    }

    func testNextBetweenSection() {
        let indexPath = directionManager.indexPathForDirection(.next, andBaseIndexPath: IndexPath(row: StubTableViewSection.first.lastRow, section: StubTableViewSection.first.rawValue))
        let expectedIndexPath = IndexPath(row: 0, section: StubTableViewSection.second.rawValue)
        XCTAssert(indexPath == expectedIndexPath)
    }

    func testPreviousBetweenSection() {
        let indexPath = directionManager.indexPathForDirection(.previous, andBaseIndexPath: IndexPath(row: 0, section: StubTableViewSection.third.rawValue))
        let expectedIndexPath = IndexPath(row: StubTableViewSection.second.lastRow, section: StubTableViewSection.second.rawValue)
        XCTAssert(indexPath == expectedIndexPath)
    }

    func testNextWithEmptySection() {
        let indexPath = directionManager.indexPathForDirection(.next, andBaseIndexPath: IndexPath(row: StubTableViewSection.third.lastRow, section: StubTableViewSection.third.rawValue))
        let expectedIndexPath = IndexPath(row: 0, section: StubTableViewSection.fifth.rawValue)
        XCTAssert(indexPath == expectedIndexPath)
    }

    func testPreviousWithEmptySection() {
        let indexPath = directionManager.indexPathForDirection(.previous, andBaseIndexPath: IndexPath(row: 0, section: StubTableViewSection.fifth.rawValue))
        let expectedIndexPath = IndexPath(row: StubTableViewSection.third.lastRow, section: StubTableViewSection.third.rawValue)
        XCTAssert(indexPath == expectedIndexPath)
    }

    func testNextOutOftableView() {
        let indexPath = directionManager.indexPathForDirection(.next, andBaseIndexPath: IndexPath(row: StubTableViewSection.fifth.lastRow, section: StubTableViewSection.fifth.rawValue))
        XCTAssert(indexPath == nil)
    }

    func testPreviousOutOftableView() {
        let indexPath = directionManager.indexPathForDirection(.previous, andBaseIndexPath: IndexPath(row: 0, section: StubTableViewSection.first.rawValue))
        XCTAssert(indexPath == nil)
    }

    func testNextIndexPathWithoutDelegate() {
        directionManager.delegate = nil
        let indexPath = directionManager.indexPathForDirection(.next, andBaseIndexPath: IndexPath(row: 0, section: StubTableViewSection.first.rawValue))
        let expectedIndexPath = IndexPath(row: 1, section: StubTableViewSection.first.rawValue)
        XCTAssert(indexPath == expectedIndexPath)
    }

    func testPreviousIndexPathWithoutDelegate() {
        directionManager.delegate = nil
        let indexPath = directionManager.indexPathForDirection(.previous, andBaseIndexPath: IndexPath(row: 1, section: StubTableViewSection.first.rawValue))
        let expectedIndexPath = IndexPath(row: 0, section: StubTableViewSection.first.rawValue)
        XCTAssert(indexPath == expectedIndexPath)
    }

    func testNextWithNextCellNotEditable() {
        disableDelegateOnce = true
        let indexPath = directionManager.indexPathForDirection(.next, andBaseIndexPath: IndexPath(row: 0, section: StubTableViewSection.first.rawValue))
        let expectedIndexPath = IndexPath(row: 2, section: StubTableViewSection.first.rawValue)
        XCTAssert(indexPath == expectedIndexPath)
    }

    func testPreviousWithNextCellNotEditable() {
        disableDelegateOnce = true
        let indexPath = directionManager.indexPathForDirection(.previous, andBaseIndexPath: IndexPath(row: 2, section: StubTableViewSection.first.rawValue))
        let expectedIndexPath = IndexPath(row: 0, section: StubTableViewSection.first.rawValue)
        XCTAssert(indexPath == expectedIndexPath)
    }

    // MARK: FormDirectionManagerDelegate

    func formDirectionManager(_ formDirectionManager: FormDirectionManager, canEditCellAtIndexPath indexPath: IndexPath) -> Bool {
        if disableDelegateOnce {
            disableDelegateOnce = false
            return false
        }
        return true
    }

}

private enum StubTableViewSection: Int {
    case first = 0
    case second
    case third
    case firstEmpty
    case fifth
    case lastEmpty

    var numberOfRows: Int {
        switch self {
        case .first:
            return 4
        case .second:
            return 3
        case .third:
            return 6
        case .firstEmpty:
            return 0
        case .fifth:
            return 7
        case .lastEmpty:
            return 0
        }
    }

    var lastRow: Int {
        return self.numberOfRows - 1
    }
}

private class StubTableView: UITableView {
    override var numberOfSections: Int {
        return 6
    }

    override func numberOfRows(inSection section: Int) -> Int {
        guard let tableViewSection = StubTableViewSection(rawValue: section) else {
            return 0
        }
        return tableViewSection.numberOfRows
    }
}
