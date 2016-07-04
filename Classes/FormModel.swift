//
//  FormModel.swift
//  FormDemo
//
//  Created by Samuel Gallet on 04/07/16.
//
//

import Foundation

class FormModel {
    var gender : String = ""
    var name : String = ""
    var email : String = ""
    var phone : String = ""
    var summary : String = ""
    var birthDate : NSDate?
    var married : Bool = false
    var creditCard : String = ""
    var expiration : String = ""

    func setStubValues() {
        gender = "Male"
        name = "Georges"
        email = "toto.titi@gmail.com"
        phone = "0612131415"
        summary = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras sed sapien quam. Sed dapibus est id enim facilisis, at posuere turpis adipiscing. Quisque sit amet dui dui."
        married = false
        birthDate = NSDate()
        creditCard = "5131423412231223"
        expiration = "04/25"
    }

    func resetValues() {
        gender = ""
        name = ""
        email = ""
        phone = ""
        summary = ""
        married = false
        birthDate = nil
        creditCard = ""
        expiration = ""
    }
}