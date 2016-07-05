//
//  EnglishAccessoryToolbar.swift
//  FormDemo
//
//  Created by Samuel Gallet on 05/07/16.
//
//

import UIKit
import ADFormController

class EnglishAccessoryToolbar: UIToolbar, NavigableButtons {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initComponents()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initComponents()
    }

    // MARK: ADnavigableButtons
    private(set) var nextBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: "next", style: .Plain, target: nil, action: nil)
    private(set) var previousBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: "prev", style: .Plain, target: nil, action: nil)

    //TODO: (Samuel Gallet) 05/07/2016 Private
    private func initComponents() {
        self.tintColor = UIColor.blackColor()
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        self.items = [previousBarButtonItem, flexibleItem, nextBarButtonItem]
    }
}
