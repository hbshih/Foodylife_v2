//
//  SendFeedbackViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 07/02/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit
import IBAnimatable
import FirebaseDatabase

class SendFeedbackViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var emailTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var feedbackMessage: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        feedbackMessage.textColor = UIColor.lightGray
        feedbackMessage.text = "Please type in your feedback".localized()
        feedbackMessage.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if feedbackMessage.textColor == UIColor.lightGray
        {
            feedbackMessage.text = nil
            feedbackMessage.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty
        {
            feedbackMessage.textColor = UIColor.lightGray
            feedbackMessage.text = "Please type in your feedback".localized()
        }
    }
    
    
    
    /*Send to DATABASE*/
    @IBAction func sendBugFeedback(_ sender: Any)
    {
        let valid = validate()
        if valid.isValidEmail(testStr: emailTextfield.text!) && feedbackMessage.text != "Please type in your feedback".localized()
        {
            var ref: DatabaseReference!
            
            ref = Database.database().reference()
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd-hh-mm-ss"
            let currentTime = format.string(from: Date())
                print("connect to backend")
            ref.child("Feedback").childByAutoId().setValue(["Timestamp":currentTime,"email":self.emailTextfield.text! ,"feedback":self.feedbackMessage.text!])
                let alert = UIAlertController(title: "Thank you".localized(), message: "We have received your feedback, we will contact you if needed!".localized(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }else
        {
            let alert = UIAlertController(title: "Oops".localized(), message: "Please recheck your email or check if you have type in correct message.".localized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
