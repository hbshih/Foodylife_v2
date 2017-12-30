//
//  CreateEmailViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 18/12/2017.
//  Copyright © 2017 BenShih. All rights reserved.
//

import UIKit
//import SkyFloatingLabelTextField

class CreateEmailViewController: UIViewController {
    
    var username = ""

    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextTapped(_ sender: Any)
    {
        //emailTextField.errorMessage = "Wrong email format"
        if emailTextField.text != ""
        {
            performSegue(withIdentifier: "createEmailSegue", sender: self)
        }else
        {
            //emailTextField.errorMessage = "Wrong email format"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let PWVC = segue.destination as? CreatePasswordViewController
        {

                PWVC.email = emailTextField.text!
                PWVC.username = username
        }
    }
    

}
