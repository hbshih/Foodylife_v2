//
//  SendFeedbackViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 07/02/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit
import IBAnimatable


class SendFeedbackViewController: UIViewController {

    @IBOutlet weak var emailTextfield: SkyFloatingLabelTextField!
    
    @IBOutlet weak var feedbackTextField: AnimatableTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let valid = validate()
        if valid.isValidEmail(testStr: emailTextfield.text!)
        {
            if feedbackTextField.text != ""
            {
               print("connect to backend")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
