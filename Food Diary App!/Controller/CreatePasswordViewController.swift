//
//  CreatePasswordViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 18/12/2017.
//  Copyright © 2017 BenShih. All rights reserved.
//

import UIKit
//import SkyFloatingLabelTextField
import FirebaseAuth
import FirebaseDatabase

class CreatePasswordViewController: UIViewController {
    
    var username = ""
    var email = ""
    
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneTapped(_ sender: Any)
    {
        if let password = passwordTextField.text
        {
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if error != nil
                {
                    print(error.debugDescription)
                }else
                {
                    print("Sign up succesfully")
                  //  Database.database().reference().child("email").setValue(self.email)
                    let uid = Auth.auth().currentUser?.uid
                Database.database().reference().child("Users").child(uid!).setValue(["username":self.username,"email":self.email])
                    
                }
            }
        }
    }
    
}
