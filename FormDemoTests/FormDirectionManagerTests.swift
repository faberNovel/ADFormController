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
    private let tableView = StubTableView(frame: CGRectZero)
    lazy private var directionManager: FormDirectionManager = {
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
        let indexPath = directionManager.indexPathForDirection(.Next, andBaseIndexPath: NSIndexPath(forRow: 0, inSection: StubTableViewSection.First.rawValue))
        let expectedIndexPath = NSIndexPath(forRow: 1, inSection: StubTableViewSection.First.rawValue)
        XCTAssert(indexPath == expectedIndexPath)
    }

    func testSimplePrev() {
        let indexPath = directionManager.indexPathForDirection(.Previous, andBaseIndexPath: NSIndexPath(forRow: 4, inSection: StubTableViewSection.Third.rawValue))
        let expectedIndexPath = NSIndexPath(forRow: 3, inSection: StubTableViewSection.Third.rawValue)
        XCTAssert(indexPath == expectedIndexPath)
    }

    func testNextBetweenSection() {
        let indexPath = directionManager.indexPathForDirection(.Next, andBaseIndexPath: NSIndexPath(forRow: StubTableViewSection.First.lastRow, inSection: StubTableViewSection.First.rawValue))
        let expectedIndexPath = NSIndexPath(forRow: 0, inSection: StubTableViewSection.Second.rawValue)
        XCTAssert(indexPath == expectedIndexPath)
    }

    func testPreviousBetweenSection() {
        let indexPath = directionManager.indexPathForDirection(.Previous, andBaseIndexPath: NSIndexPath(forRow: 0, inSection: StubTableViewSection.Third.rawValue))
        let expectedIndexPath = NSIndexPath(forRow: StubTableViewSection.Second.lastRow, inSection: StubTableViewSection.Second.rawValue)
        XCTAssert(indexPath == expectedIndexPath)
    }

    func testNextWithEmptySection() {
        let indexPath = directionManager.indexPathForDirection(.Next, andBaseIndexPath: NSIndexPath(forRow: StubTableViewSection.Third.lastRow, inSection: StubTableViewSection.Third.rawValue))
        let expectedIndexPath = NSIndexPath(forRow: 0, inSection: StubTableViewSection.Fifth.rawValue)
        XCTAssert(indexPath == expectedIndexPath)
    }

    func testPreviousWithEmptySection() {
        let indexPath = directionManager.indexPathForDirection(.Previous, andBaseIndexPath: NSIndexPath(forRow: 0, inSection: StubTableViewSection.Fifth.rawValue))
        let expectedIndexPath = NSIndexPath(forRow: StubTableViewSection.Third.lastRow, inSection: StubTableViewSection.Third.rawValue)
        XCTAssert(indexPath == expectedIndexPath)
    }

    func testNextOutOftableView() {
        let indexPath = directionManager.indexPathForDirection(.Next, andBaseIndexPath: NSIndexPath(forRow: StubTableViewSection.Fifth.lastRow, inSection: StubTableViewSection.Fifth.rawValue))
        XCTAssert(indexPath == nil)
    }

    func testPreviousOutOftableView() {
        let indexPath = directionManager.indexPathForDirection(.Previous, andBaseIndexPath: NSIndexPath(forRow: 0, inSection: StubTableViewSection.First.rawValue))
        XCTAssert(indexPath == nil)
    }

    func testNextIndexPathWithoutDelegate() {
        directionManager.delegate = nil
        let indexPath = directionManager.indexPathForDirection(.Next, andBaseIndexPath: NSIndexPath(forRow: 0, inSection: StubTableViewSection.First.rawValue))
        let expectedIndexPath = NSIndexPath(forRow: 1, inSection: StubTableViewSection.First.rawValue)
        XCTAssert(indexPath == expectedIndexPath)
    }

    func testPreviousIndexPathWithoutDelegate() {
        directionManager.delegate = nil
        let indexPath = directionManager.indexPathForDirection(.Previous, andBaseIndexPath: NSIndexPath(forRow: 1, inSection: StubTableViewSection.First.rawValue))
        let expectedIndexPath = NSIndexPath(forRow: 0, inSection: StubTableViewSection.First.rawValue)
        XCTAssert(indexPath == expectedIndexPath)
    }

    func testNextWithNextCellNotEditable() {
        disableDelegateOnce = true
        let indexPath = directionManager.indexPathForDirection(.Next, andBaseIndexPath: NSIndexPath(forRow: 0, inSection: StubTableViewSection.First.rawValue))
        let expectedIndexPath = NSIndexPath(forRow: 2, inSection: StubTableViewSection.First.rawValue)
        XCTAssert(indexPath == expectedIndexPath)
    }

    func testPreviousWithNextCellNotEditable() {
        disableDelegateOnce = true
        let indexPath = directionManager.indexPathForDirection(.Previous, andBaseIndexPath: NSIndexPath(forRow: 2, inSection: StubTableViewSection.First.rawValue))
        let expectedIndexPath = NSIndexPath(forRow: 0, inSection: StubTableViewSection.First.rawValue)
        XCTAssert(indexPath == expectedIndexPath)
    }

    // MARK: FormDirectionManagerDelegate

    func formDirectionManager(formDirectionManager: FormDirectionManager, canEditCellAtIndexPath indexPath: NSIndexPath) -> Bool {
        if disableDelegateOnce {
            disableDelegateOnce = false
            return false
        }
        return true
    }

}

private enum StubTableViewSection: Int {
    case First = 0
    case Second
    case Third
    case FirstEmpty
    case Fifth
    case LastEmpty

    var numberOfRows: Int {
        switch self {
        case .First:
            return 4
        case .Second:
            return 3
        case .Third:
            return 6
        case .FirstEmpty:
            return 0
        case .Fifth:
            return 7
        case .LastEmpty:
            return 0
        }
    }

    var lastRow: Int {
        return self.numberOfRows - 1
    }
}

private class StubTableView: UITableView {
    private override var numberOfSections: Int {
        return 6;
    }

    private override func numberOfRowsInSection(section: Int) -> Int {
        guard let tableViewSection = StubTableViewSection(rawValue: section) else {
            return 0
        }
        return tableViewSection.numberOfRows
    }
}