//
//  RatingViewController.swift
//  PopupDialog
//
//  Created by Martin Wildfeuer on 11.07.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import YPImagePicker
import FirebaseAnalytics

class EditPopUpViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var grainTextField: UITextField!
    @IBOutlet weak var vegetableTextField: UITextField!
    @IBOutlet weak var proteinTextField: UITextField!
    @IBOutlet weak var fruitTextField: UITextField!
    @IBOutlet weak var dairyTextField: UITextField!
    @IBOutlet weak var grainStepper: UIStepper!
    @IBOutlet weak var vegetableStepper: UIStepper!
    @IBOutlet weak var proteinStepper: UIStepper!
    @IBOutlet weak var fruitStepper: UIStepper!
    @IBOutlet weak var dairyStepper: UIStepper!
    @IBOutlet weak var notesField: UITextView!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    
    var n_Values = [0.0,0.0,0.0,0.0,0.0]
    var notes = ""
    var hasImage = false
    var image: UIImage?
    var hasNewImage = false
    var newImage: UIImage?
    
    var recordChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent("EditPopUp", parameters: nil)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        
        grainStepper.value = n_Values[0]
        vegetableStepper.value = n_Values[1]
        proteinStepper.value = n_Values[2]
        fruitStepper.value = n_Values[3]
        dairyStepper.value = n_Values[4]
        
        grainTextField.text = String(grainStepper.value)
        vegetableTextField.text = String(vegetableStepper.value)
        proteinTextField.text = String(proteinStepper.value)
        fruitTextField.text = String(fruitStepper.value)
        dairyTextField.text = String(dairyStepper.value)
        
        if hasImage
        {
            foodImage.image = image
            cameraButton.isHidden = true
        }
        
        if notes != ""
        {
            notesField.text = notes
        }else
        {
            notesField.delegate = self
            notesField.text = "add some note here...".localized()
            notesField.textColor = UIColor.lightGray
        }
    }
    
    

    @IBAction func CameraTapped(_ sender: Any)
    {
        showPicker()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func stepperTapped(_ sender: UIStepper)
    {
        switch sender.tag
        {
        case 0:
            grainTextField.text = String(sender.value)
        case 1:
            vegetableTextField.text = String(sender.value)
        case 2:
            proteinTextField.text = String(sender.value)
        case 3:
            fruitTextField.text = String(sender.value)
        case 4:
            dairyTextField.text = String(sender.value)
        default:
            break
        }
        Analytics.logEvent("Edit_Servings", parameters: nil)
        recordChanged = true
    }
    
    @objc func endEditing()
    {
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if notes != notesField.text
        {
            self.recordChanged = true
            notes = notesField.text
            Analytics.logEvent("Edit_Note", parameters: nil)
        }
        
        if notesField.text == "add some note here...".localized()
        {
            notes = ""
        }
        
        print(notesField.text)
        print(notes)
        
        n_Values = [grainStepper.value,vegetableStepper.value,proteinStepper.value,fruitStepper.value,dairyStepper.value]
    }
    
    
    @objc func showPicker() {
        // Configuration
        var config = YPImagePickerConfiguration()
        config.library.onlySquare = true
        config.onlySquareImagesFromCamera = true
        config.showsFilters = true
        config.shouldSaveNewPicturesToAlbum = false

        // Here we use a per picker configuration.
        let picker = YPImagePicker(configuration: config)
        
        // unowned is Mandatory since it would create a retain cycle otherwise :)
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let img = items.singlePhoto {
                self.foodImage.image = img.image
                self.cameraButton.isHidden = true
                self.recordChanged = true
                self.hasNewImage = true
                self.newImage = img.image
                Analytics.logEvent("Edit_NewImage", parameters: nil)
                picker.dismiss(animated: true, completion: nil)
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    // Working with textfield ##
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if notesField.textColor == UIColor.lightGray
        {
            notesField.text = ""
            notesField.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if notesField.text == ""
        {
            notesField.text = "add some note here...".localized()
            notesField.textColor = UIColor.lightGray
        }
    }
}

extension EditPopUpViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
}
