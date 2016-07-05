//
//  EnglishAccessoryToolbar.swift
//  FormDemo
//
//  Created by Samuel Gallet on 05/07/16.
//
//

import UIKit
import ADFormController

class EnglishAccessoryToolbar: UIToolbar, ADNavigableButtons {

    private var nextButton : UIBarButtonItem = UIBarButtonItem(title: "next", style: .Plain, target: nil, action: nil)
    private var backButton : UIBarButtonItem = UIBarButtonItem(title: "back", style: .Plain, target: nil, action: nil)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initComponents()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initComponents()
    }

    // MARK: ADnavigableButtons
    func nextBarButtonItem() -> UIBarButtonItem! {
        return nextButton
    }

    func previousBarButtonItem() -> UIBarButtonItem! {
        return backButton
    }

    //TODO: (Samuel Gallet) 05/07/2016 Private
    private func initComponents() {
        self.tintColor = UIColor.blackColor()
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        self.items = [backButton, flexibleItem, nextButton]
    }
}
