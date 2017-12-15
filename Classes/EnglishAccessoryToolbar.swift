//
//  EnglishAccessoryToolbar.swift
//  FormDemo
//
//  Created by Samuel Gallet on 05/07/16.
//
//

import UIKit
import ADFormController

class EnglishAccessoryToolbar: UIToolbar, NavigableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initComponents()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initComponents()
    }

    //MARK: - NavigableView

    var view: UIView {
        return self
    }

    //MARK: - NavigableButtons

    private(set) var nextBarButtonItem = UIBarButtonItem(
        title: "next",
        style: .plain,
        target: nil,
        action: nil
    )

    private(set) var previousBarButtonItem = UIBarButtonItem(
        title: "prev",
        style: .plain,
        target: nil,
        action: nil
    )

    //MARK: - Private

    private func initComponents() {
        self.tintColor = UIColor.black
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
