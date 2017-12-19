//
//  CreateUsernameViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 18/12/2017.
//  Copyright © 2017 BenShih. All rights reserved.
//

import UIKit

class CreateUsernameViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func NextTapped(_ sender: Any)
    {
        performSegue(withIdentifier: "createUsernameSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let username = usernameTextField.text
        {
            if let EmailVC = segue.destination as? CreateEmailViewController
            {
                EmailVC.username = username
            }
        }
    }
}
