//
//  SignUpPageViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 26/01/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpPageViewController: UIViewController {
    
    // Outlets 
    @IBOutlet weak var confirmPasswordTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var usernameTextfield: SkyFloatingLabelTextField!
    
    // Validation check Variables
    var readyToSignUp = [false,false,false,false]
    let validationCheck = validate.init()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // When signup button is tapped
    @IBAction func createAccountTapped(_ sender: Any)
    {
        // Final check for all fields
        if validationCheck.check(field: emailTextfield, toCheck: "email")
        {
            if validationCheck.check(field: usernameTextfield, toCheck: "username")
            {
                if validationCheck.check(field: passwordTextfield, toCheck: "password")
                {
                    if validationCheck.check(field: confirmPasswordTextfield, toCheck: "confirmPassword")
                    {
                        if validationCheck.passwordMatch(password: passwordTextfield!, confirmPassword: confirmPasswordTextfield!)
                        {
                            // If no error found with the fields, then try sign up with Google Firebase
                            Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
                                // If got any error
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
                                }else
                                {
                                    print("Sign up succesfully")
                                    let uid = Auth.auth().currentUser?.uid
                                    Database.database().reference().child("Users").child(uid!).setValue(["username":self.usernameTextfield.text ,"email":self.emailTextfield.text])
                                    self.performSegue(withIdentifier: "signUpSuccesfulSegue", sender: nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Apply validation check everytime when user finish typing (Better UX)
    @IBAction func endEditing(_ sender: AnyObject)
    {
        switch sender.tag
        {
        case 1:
            readyToSignUp[0] = validationCheck.check(field: emailTextfield, toCheck: "email")
        case 2:
            readyToSignUp[1] = validationCheck.check(field: usernameTextfield, toCheck: "username")
        case 3:
            readyToSignUp[2] = validationCheck.check(field: passwordTextfield, toCheck: "password")
        case 4:
            readyToSignUp[3] = validationCheck.check(field: confirmPasswordTextfield, toCheck: "confirmPassword")
            readyToSignUp[3] = validationCheck.passwordMatch(password: passwordTextfield, confirmPassword: confirmPasswordTextfield)
        default:
            print("")
        }
    }
}
