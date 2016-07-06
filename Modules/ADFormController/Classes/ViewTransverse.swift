//
//  ViewTransverse.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

public extension UIView {
    public func superView<T: UIView>() -> T? {
        var view: UIView = self
        guard let castedView = view as? T else {
            return view.superview.flatMap {
                return $0.superView()
            }
        }
        return castedView
    }
}
