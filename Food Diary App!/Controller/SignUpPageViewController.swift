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
    
    @IBOutlet weak var confirmPasswordTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var usernameTextfield: SkyFloatingLabelTextField!
    var readyToSignUp = [false,false,false,false]
    override func viewDidLoad() {
        super.viewDidLoad()
        // emailTextfield.placeholderFont = UIFont(name: "<#T##String#>", size: <#T##CGFloat#>)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccountTapped(_ sender: Any)
    {
        validate(field: emailTextfield)
        validate(field: usernameTextfield)
        validate(field: passwordTextfield)
        validate(field: confirmPasswordTextfield)
        var ready = true
        for i in 0 ..< readyToSignUp.count
        {
            if !readyToSignUp[i]
            {
                ready = false
            }
        }
        if ready
        {
            
            Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
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
                    //  Database.database().reference().child("email").setValue(self.email)
                    let uid = Auth.auth().currentUser?.uid
                    Database.database().reference().child("Users").child(uid!).setValue(["username":self.usernameTextfield.text ,"email":self.emailTextfield.text])
                    self.performSegue(withIdentifier: "signUpSuccesfulSegue", sender: nil)
                }
            }
            
            print("Sign up completed")
        }
    }
    
    @IBAction func endEditing(_ sender: AnyObject)
    {
        switch sender.tag
        {
        case 1:
            validate(field: emailTextfield)
        case 2:
            validate(field: usernameTextfield)
        case 3:
            validate(field: passwordTextfield)
        case 4:
            validate(field: confirmPasswordTextfield)
        default:
            print("")
        }
    }
    
    
    func validate(field: UITextField)
    {
        switch field {
        case emailTextfield:
            if emailTextfield.text == ""
            {
                errorNoError(textfield: emailTextfield, error: true, message: "PLEASE ENTER YOUR EMAIL ADDRESS")
                readyToSignUp[0] = false
            }else
            {
                if isValidEmail(testStr: emailTextfield.text!)
                {
                    errorNoError(textfield: emailTextfield, error: false, message: "")
                    readyToSignUp[0] = true
                }else
                {
                    errorNoError(textfield: emailTextfield, error: true, message: "INVALID EMAIL ADDRESS")
                    readyToSignUp[0] = false
                }
            }
        case usernameTextfield:
            if usernameTextfield.text == ""
            {
                errorNoError(textfield: usernameTextfield, error: true, message: "PLEASE TELL US YOUR NAME")
                readyToSignUp[1] = false
            }else
            {
                errorNoError(textfield: usernameTextfield, error: false, message: "")
                readyToSignUp[1] = true
            }
        case passwordTextfield:
            if passwordTextfield.text!.count < 6
            {
                errorNoError(textfield: passwordTextfield, error: true, message: "MUST BE AT LEAST 6 CHARACTERS")
                readyToSignUp[2] = false
            }else
            {
                errorNoError(textfield: passwordTextfield, error: false, message: "")
                readyToSignUp[2] = true
            }
        case confirmPasswordTextfield:
            if confirmPasswordTextfield.text!.count < 6
            {
                errorNoError(textfield: confirmPasswordTextfield, error: true, message: "MUST BE AT LEAST 6 CHARACTERS")
                readyToSignUp[3] = false
            }else
            {
                if confirmPasswordTextfield.text != passwordTextfield.text
                {
                    errorNoError(textfield: confirmPasswordTextfield, error: true, message: "PASSWORD DOES NOT MATCH")
                    readyToSignUp[3] = false
                }else
                {
                    errorNoError(textfield: confirmPasswordTextfield, error: false, message: "")
                    readyToSignUp[3] = true
                }
            }
        default:
            print("nothing")
            
        }
    }
    
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
    
    func isValidEmail(testStr:String) -> Bool
    {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
