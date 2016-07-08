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

//TODO: (Samuel Gallet) 05/07/2016  remove @objc and public
@objc public class TextInputAccessoryView: UIToolbar, NavigableView {

    // MARK: NavigableButtons
    private(set) public var nextBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage.bundleImage("FDNextIcon"), style: .Plain, target: nil, action: nil)
    private(set) public var previousBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage.bundleImage("FDPreviousIcon"), style: .Plain, target: nil, action: nil)

    // MARK: NavigableView
    public var view: UIView {
        return self
    }

    // MARK: UIView
    override init(frame: CGRect) {
        super.init(frame: frame)
        initComponents()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initComponents()
    }

    // MARK: Private
    private func initComponents() {
        nextBarButtonItem.width = 44.0
        previousBarButtonItem.width = 44.0
        tintColor = UIColor.blackColor()
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        self.items = [previousBarButtonItem, flexibleItem, nextBarButtonItem]
    }
}
