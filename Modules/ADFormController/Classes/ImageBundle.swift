//
//  ImageBundle.swift
//  Pods
//
//  Created by Samuel Gallet on 05/07/16.
//
//

import Foundation

extension Bundle {
    @nonobjc static let formControllerBundle : Bundle = {
        let podBundle = Bundle(for: FormController.classForCoder())
        guard let ressourceBundle = podBundle.url(forResource: "ADFormController", withExtension: "bundle").flatMap({ Bundle(url: $0) }) else {
            return podBundle
        }
        return ressourceBundle
    } ()
}

extension UIImage {
    static func bundleImage(_ name : String) -> UIImage? {
        return UIImage.init(named: name, in: Bundle.formControllerBundle, compatibleWith: nil)
    }
}
