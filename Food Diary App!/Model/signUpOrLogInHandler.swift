//
//  signUpOrLogInHandler.swift
//  Food Diary App!
//
//  Created by Ben Shih on 28/01/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import UIKit
/*
struct signUpOrLoginHandler
{
    let emailTextfield: UITextField?
    let usernameTextfield: UITextField?
    let passwordTextfield: UITextField?
    
    func signUpUser(Completion block: @escaping ((NSArray) -> ())) -> Bool
    {
        Auth.auth().createUser(withEmail: emailTextfield!.text!, password: passwordTextfield!.text!) { (user, error) in
            if error != nil
            {
                print(error.debugDescription)
                var errorMessage = "Please try again later"
                if let newError = error as NSError?
                {
                    if let detailError = newError.userInfo["NSLocalizedDescription"] as? String
                    {
                        errorMessage = detailError
                        SCLAlertMessage(title: "Error", message: errorMessage).showMessage()
                    }
                }
                return false
            }else
            {
                let uid = Auth.auth().currentUser?.uid
                Database.database().reference().child("Users").child(uid!).setValue(["username":self.usernameTextfield!.text! ,"email":self.emailTextfield!.text!])
                return true
            }
        }
        return false
    }
    
    func logInUser() -> Bool
    {
        var logInSuccess = false
        Auth.auth().signIn(withEmail: emailTextfield!.text!, password: passwordTextfield!.text!, completion: { (user, error) in
            // Log in error
            if error != nil
            {
                print(error.debugDescription)
                var errorMessage = "Please try again later"
                if let newError = error as NSError?
                {
                    if let detailError = newError.userInfo["NSLocalizedDescription"] as? String
                    {
                        errorMessage = detailError
                        SCLAlertMessage(title: "Error", message: errorMessage).showMessage()
                    }
                }
                logInSuccess = false
            }else
            {
                print("Log up Success")
                logInSuccess = true
            }
        })
        return logInSuccess
    }
}
 */

