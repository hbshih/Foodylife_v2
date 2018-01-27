//
//  RecoverPasswordViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 26/01/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit
import FirebaseAuth

class RecoverPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextfield: SkyFloatingLabelTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func recoverTapped(_ sender: Any)
    {
        if isValidEmail(testStr: emailTextfield.text!)
        {
            if let email = emailTextfield.text {
                Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
                    if let error = error {
                        let alertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                       // UserNotification.show("Password reset e-mail sent")
                        print("PAssword reset e-mail sent")
                    }
                })
            }
        }else
        {
            emailTextfield.errorColor = UIColor.colorFromHex(hexString:
                "#F9E4AE")
            emailTextfield.errorMessage = "INVALID EMAIL"
        }
        
        //self.present(IntroductionViewController, animated: true, completion: nil)
    }
    
    func isValidEmail(testStr:String) -> Bool
    {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
}
