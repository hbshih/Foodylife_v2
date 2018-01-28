//
//  LogInPageViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 26/01/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInPageViewController: UIViewController {
    
    @IBOutlet weak var passwordTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextfield: SkyFloatingLabelTextField!
    
    var readyToSignUp = [false,false]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInTapped(_ sender: Any)
    {
        validate(field: emailTextfield)
        validate(field: passwordTextfield)
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
            Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!, completion: { (user, error) in
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
                }else
                {
                    print("Log up Success")
                    self.performSegue(withIdentifier: "logInSegue", sender: nil)
                }
            })
            
        }
    }
    
    @IBAction func endEditing(_ sender: AnyObject)
    {
        switch sender.tag
        {
        case 1:
            validate(field: emailTextfield)
        case 2:
            validate(field: passwordTextfield)
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
        case passwordTextfield:
            if passwordTextfield.text!.count < 6
            {
                errorNoError(textfield: passwordTextfield, error: true, message: "MUST BE AT LEAST 6 CHARACTERS")
                readyToSignUp[1] = false
            }else
            {
                errorNoError(textfield: passwordTextfield, error: false, message: "")
                readyToSignUp[1] = true
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
