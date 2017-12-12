//
//  ViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 12/12/2017.
//  Copyright © 2017 BenShih. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
  
    }
    
    @IBAction func logInTapped(_ sender: Any)
    {
        if emailTextField.text != nil && passwordTextField.text != nil
        {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if error != nil
                {
                    self.displayAlert(title: "Error", message: error!.localizedDescription)
                }else
                {
                    print("Log on success")
                }
            })
        }
    }
    @IBAction func SignUpTapped(_ sender: Any)
    {
        if emailTextField.text != nil && passwordTextField.text != nil
        {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil
                {
                    self.displayAlert(title: "Error", message: error!.localizedDescription)
                }else
                {
                    print("Sign up Successful")
                }
            }
        }else
        {
            displayAlert(title: "You haven't typed anything", message: "Please provide your email and password for validation")
        }
    }
    
    func displayAlert(title: String, message: String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

