//
//  validate.swift
//  Food Diary App!
//
//  Created by Ben Shih on 28/01/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import Foundation
import UIKit

struct validate
{
    // Check for field's error, return true if no error is found in that field
    func check(field: SkyFloatingLabelTextField, toCheck: String) -> Bool
    {
        switch toCheck {
        case "email":
            if field.text == ""
            {
                errorNoError(textfield: field, error: true, message: "PLEASE ENTER YOUR EMAIL ADDRESS")
                return false
            }else
            {
                if isValidEmail(testStr: field.text!)
                {
                    errorNoError(textfield: field, error: false, message: "")
                    return true
                }else
                {
                    errorNoError(textfield: field, error: true, message: "INVALID EMAIL ADDRESS")
                    return false
                }
            }
        case "username" :
            if field.text == ""
            {
                errorNoError(textfield: field, error: true, message: "PLEASE TELL US YOUR NAME")
                return false
            }else
            {
                errorNoError(textfield: field, error: false, message: "")
                return true
            }
        case "password":
            if field.text!.count < 6
            {
                errorNoError(textfield: field, error: true, message: "MUST BE AT LEAST 6 CHARACTERS")
                return false
            }else
            {
                errorNoError(textfield: field, error: false, message: "")
                return true
            }
        case "confirmPassword":
            if field.text!.count < 6
            {
                errorNoError(textfield: field, error: true, message: "MUST BE AT LEAST 6 CHARACTERS")
                return false
            }else
            {
                errorNoError(textfield: field, error: false, message: "")
                return true
            }
        default:
            print("nothing")
            return false
        }
    }
    
    // to check if the password entered by the user and the confirmation password is match
    func passwordMatch(password: SkyFloatingLabelTextField, confirmPassword: SkyFloatingLabelTextField) -> Bool
    {
        let pw = password.text
        let confirm = confirmPassword.text
        if pw != confirm
        {
            errorNoError(textfield: confirmPassword, error: true, message: "PASSWORD DOES NOT MATCH")
            return false
        }
        errorNoError(textfield: confirmPassword, error: false, message: "")
        return true
    }
    
    //Show error message to the user if an error is found
    func errorNoError(textfield: SkyFloatingLabelTextField, error: Bool, message: String)
    {
        if error
        {
            textfield.errorColor = UIColor.colorFromHex(hexString:
                "#F9E4AE")
            textfield.errorMessage = message
        }else
        {
            textfield.errorColor = UIColor.colorFromHex(hexString: "#FFFFFF")
            textfield.errorMessage = ""
        }
    }
    
    // Check if it's a valid email
    func isValidEmail(testStr:String) -> Bool
    {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}


