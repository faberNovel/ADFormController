//
//  ImageBundle.swift
//  Pods
//
//  Created by Samuel Gallet on 05/07/16.
//
//

import Foundation

extension NSBundle {
    //TODO: (Samuel Gallet) 05/07/2016 remove nonobjc
    @nonobjc static let formControllerBundle : NSBundle = {
        let podBundle = NSBundle(forClass: FormController.classForCoder())
        guard let ressourceBundle = podBundle.URLForResource("ADFormController", withExtension: "bundle").flatMap({ NSBundle(URL: $0) }) else {
            return podBundle
        }
        return ressourceBundle
    } ()
}

extension UIImage {
    static func bundleImage(name : String) -> UIImage? {
        return UIImage.init(named: name, inBundle: NSBundle.formControllerBundle, compatibleWithTraitCollection: nil)
    }
}