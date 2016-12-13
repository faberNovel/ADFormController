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
        return String(describing: self)
    }
}

enum RegisterableView {
    case Nib(AnyClass)
    case `class`(AnyClass)
}

extension RegisterableView {
    var nib: UINib? {
        switch self {
        case let .Nib(cellClass): return UINib(nibName: String(describing: cellClass), bundle: nil)
        default: return nil
        }
    }

    var identifier: String {
        switch self {
        case let .Nib(cellClass): return cellClass.identifier()
        case let .class(cellClass): return cellClass.identifier()
        }
    }

    var cellClass: AnyClass? {
        switch self {
        case let .class(cellClass): return cellClass
        default: return nil
        }
    }
}

protocol CollectionView {
    func registerCell(_ cell: RegisterableView)
    func registerHeader(_ header: RegisterableView)
    func registerFooter(_ footer: RegisterableView)
}

extension CollectionView {
    func registerCells(_ cells: [RegisterableView]) {
        cells.forEach(registerCell)
    }

    func registerHeaders(_ headers: [RegisterableView]) {
        headers.forEach(registerHeader)
    }

    func registerFooters(_ footers: [RegisterableView]) {
        footers.forEach(registerFooter)
    }
}

extension UITableView: CollectionView {
    func registerCell(_ cell: RegisterableView) {
        switch cell {
        case .Nib:
            register(cell.nib, forCellReuseIdentifier: cell.identifier)
        case .class:
            register(cell.cellClass, forCellReuseIdentifier: cell.identifier)
        }
    }

    func registerHeader(_ header: RegisterableView) {
        switch header {
        case .Nib:
            register(header.nib, forHeaderFooterViewReuseIdentifier: header.identifier)
        case .class:
            register(header.cellClass, forHeaderFooterViewReuseIdentifier: header.identifier)
        }
    }

    func registerFooter(_ footer: RegisterableView) {
        registerHeader(footer)
    }
}

extension UICollectionView: CollectionView {
    func registerCell(_ cell: RegisterableView) {
        switch cell {
        case .Nib:
            register(cell.nib, forCellWithReuseIdentifier: cell.identifier)
        case .class:
            register(cell.cellClass, forCellWithReuseIdentifier: cell.identifier)
        }
    }

    func registerHeader(_ header: RegisterableView) {
        registerSupplementaryView(header, kind: UICollectionElementKindSectionHeader)
    }

    func registerFooter(_ footer: RegisterableView) {
        registerSupplementaryView(footer, kind: UICollectionElementKindSectionFooter)
    }

    private func registerSupplementaryView(_ view: RegisterableView, kind: String) {
        switch view {
        case .Nib:
            register(view.nib, forSupplementaryViewOfKind:kind , withReuseIdentifier: view.identifier)
        case .class:
            register(view.cellClass, forSupplementaryViewOfKind:kind , withReuseIdentifier: view.identifier)
        }
    }
}

extension UITableView {
    func dequeueCellAtIndexPath<U: ClassIdentifiable>(_ indexPath: IndexPath) -> U {
        return dequeueReusableCell(withIdentifier: U.identifier(), for: indexPath) as! U
    }
}

