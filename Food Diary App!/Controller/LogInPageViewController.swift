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
    
    // Outlets
    @IBOutlet weak var passwordTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextfield: SkyFloatingLabelTextField!
    // Varibles for validation
    var readyToLogIn = [false,false]
    let validationCheck = validate.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //When sign in is tapped
    @IBAction func signInTapped(_ sender: Any)
    {
        print("sign in tapped")
        // Last check for all fields
        if validationCheck.check(field: emailTextfield, toCheck: "email")
        {
            if validationCheck.check(field: passwordTextfield, toCheck: "password")
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
    }
    
    // Check when everytime the user finish typing something
    @IBAction func endEditing(_ sender: AnyObject)
    {
        switch sender.tag
        {
        case 1:
            readyToLogIn [0] = validationCheck.check(field: emailTextfield, toCheck: "email")
        case 2:
            readyToLogIn [1] = validationCheck.check(field: passwordTextfield, toCheck: "password")
        default:
            print("")
        }
    }
}
