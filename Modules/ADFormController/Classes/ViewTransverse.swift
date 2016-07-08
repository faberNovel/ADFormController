//
//  ViewTransverse.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

public extension UIView {
    public func superViewFromClass<T: UIView>() -> T? {
        var view: UIView = self
        guard let castedView = view as? T else {
            return view.superview.flatMap {
                return $0.superViewFromClass()
            }
        }
        return castedView
    }

    public func findFirstResponder() -> UIView? {
        if isFirstResponder() {
            return self
        }
        for subview in subviews {
            if let firstResponser = subview.findFirstResponder() {
                return firstResponser
            }
        }
        return nil
    }
}
