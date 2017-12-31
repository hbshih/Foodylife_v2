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
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    @IBAction func logInTapped(_ sender: Any)
    {
        if emailTextField.text != nil && passwordTextField.text != nil
        {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if error != nil
                {
                    //self.displayAlert(title: "Error", message: error!.localizedDescription)
                    let alertMessage = AlertMessage()
                    alertMessage.displayAlert(title: "Error", message:  error!.localizedDescription, VC: self)
                    
                }else
                {
                    print("Log on success")
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            })
        }
    }
    
    func displayAlert(title: String, message: String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true;
    }
    
    
    
}

