//
//  RegistrableView.swift
//  FormDemo
//
//  Created by Samuel Gallet on 05/07/16.
//
//

import UIKit

protocol ClassIdentifiable {
    static func identifier() -> String
}

extension NSObject: ClassIdentifiable {
    static func identifier() -> String {
        return String(self)
    }
}

enum RegisterableView {
    case Nib(AnyClass)
    case Class(AnyClass)
}

extension RegisterableView {
    var nib: UINib? {
        switch self {
        case let .Nib(cellClass): return UINib(nibName: String(cellClass), bundle: nil)
        default: return nil
        }
    }

    var identifier: String {
        switch self {
        case let .Nib(cellClass): return cellClass.identifier()
        case let .Class(cellClass): return cellClass.identifier()
        }
    }

    var cellClass: AnyClass? {
        switch self {
        case let .Class(cellClass): return cellClass
        default: return nil
        }
    }
}

protocol CollectionView {
    func registerCell(cell: RegisterableView)
    func registerHeader(header: RegisterableView)
    func registerFooter(footer: RegisterableView)
}

extension CollectionView {
    func registerCells(cells: [RegisterableView]) {
        cells.forEach(registerCell)
    }

    func registerHeaders(headers: [RegisterableView]) {
        headers.forEach(registerHeader)
    }

    func registerFooters(footers: [RegisterableView]) {
        footers.forEach(registerFooter)
    }
}

extension UITableView: CollectionView {
    func registerCell(cell: RegisterableView) {
        switch cell {
        case .Nib:
            registerNib(cell.nib, forCellReuseIdentifier: cell.identifier)
        case .Class:
            registerClass(cell.cellClass, forCellReuseIdentifier: cell.identifier)
        }
    }

    func registerHeader(header: RegisterableView) {
        switch header {
        case .Nib:
            registerNib(header.nib, forHeaderFooterViewReuseIdentifier: header.identifier)
        case .Class:
            registerClass(header.cellClass, forHeaderFooterViewReuseIdentifier: header.identifier)
        }
    }

    func registerFooter(footer: RegisterableView) {
        registerHeader(footer)
    }
}

extension UICollectionView: CollectionView {
    func registerCell(cell: RegisterableView) {
        switch cell {
        case .Nib:
            registerNib(cell.nib, forCellWithReuseIdentifier: cell.identifier)
        case .Class:
            registerClass(cell.cellClass, forCellWithReuseIdentifier: cell.identifier)
        }
    }

    func registerHeader(header: RegisterableView) {
        registerSupplementaryView(header, kind: UICollectionElementKindSectionHeader)
    }

    func registerFooter(footer: RegisterableView) {
        registerSupplementaryView(footer, kind: UICollectionElementKindSectionFooter)
    }

    private func registerSupplementaryView(view: RegisterableView, kind: String) {
        switch view {
        case .Nib:
            registerNib(view.nib, forSupplementaryViewOfKind:kind , withReuseIdentifier: view.identifier)
        case .Class:
            registerClass(view.cellClass, forSupplementaryViewOfKind:kind , withReuseIdentifier: view.identifier)
        }
    }
}

extension UITableView {
    func dequeueCellAtIndexPath<U: ClassIdentifiable>(indexPath: NSIndexPath) -> U {
        return dequeueReusableCellWithIdentifier(U.identifier(), forIndexPath: indexPath) as! U
    }
}

