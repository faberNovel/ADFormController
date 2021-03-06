//
//  TextInputAccessoryView.swift
//  Pods
//
//  Created by Samuel Gallet on 05/07/16.
//
//

import UIKit

@objc public protocol NavigableButtons {
    var nextBarButtonItem : UIBarButtonItem { get }
    var previousBarButtonItem : UIBarButtonItem { get }
}

@objc public protocol NavigableView : NavigableButtons {
    var view: UIView { get }
}

class TextInputAccessoryView: UIToolbar, NavigableView {

    //MARK: - NavigableButtons

    private(set) var nextBarButtonItem = UIBarButtonItem(
        image: UIImage.bundleImage("FDNextIcon"),
        style: .plain,
        target: nil,
        action: nil
    )

    private(set) var previousBarButtonItem = UIBarButtonItem(
        image: UIImage.bundleImage("FDPreviousIcon"),
        style: .plain,
        target: nil,
        action: nil
    )

    //MARK: - NavigableView

    var view: UIView {
        return self
    }

    //MARK: - UIView

    override init(frame: CGRect) {
        super.init(frame: frame)
        initComponents()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initComponents()
    }

    //MARK: - Private

    private func initComponents() {
        nextBarButtonItem.width = 44.0
        previousBarButtonItem.width = 44.0
        tintColor = UIColor.black
        let flexibleItem = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        items = [
            previousBarButtonItem,
            flexibleItem,
            nextBarButtonItem
        ]
    }
}
