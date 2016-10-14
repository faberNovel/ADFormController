//
//  ViewTransverse.swift
//  Pods
//
//  Created by Samuel Gallet on 06/07/16.
//
//

import UIKit

extension UIView {
    func superViewFromClass<T: UIView>() -> T? {
        let view: UIView = self
        guard let castedView = view as? T else {
            return view.superview.flatMap {
                return $0.superViewFromClass()
            }
        }
        return castedView
    }

    func findFirstResponder() -> UIView? {
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
