//
//  AddInfoViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 01/03/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit
import YPImagePicker
import FirebaseAnalytics
import PopupDialog
import Instructions
import DatePickerDialog

class AddInfoViewController: UIViewController,UITextViewDelegate {
    
    var LaunchCamera: Bool?
    var pickerdismiss: Bool?
    var LaunchCameraTimes = 0
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var addnoteText: UITextView!
    @IBOutlet weak var vegetableField: UIButton!
    @IBOutlet weak var proteinField: UIButton!
    @IBOutlet weak var fruitField: UIButton!
    @IBOutlet weak var grainField: UIButton!
    @IBOutlet weak var dairyField: UIButton!
    @IBOutlet weak var vegetableCountLabel: UILabel!
    @IBOutlet weak var dairyCountLabel: UILabel!
    @IBOutlet weak var proteinCountLabel: UILabel!
    @IBOutlet weak var grainCountLabel: UILabel!
    @IBOutlet weak var fruitCountLabel: UILabel!
    @IBOutlet weak var foodgroupStackView: UIStackView!
    @IBOutlet weak var instructionOutlet: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var decreaseIntro: UILabel!
    @IBOutlet weak var savingDateLabel: UILabel!
    
    @IBOutlet weak var vIncreaseButtonn: UIButton!
    @IBOutlet weak var gIncreaseButton: UIButton!
    @IBOutlet weak var pIncreaseButton: UIButton!
    @IBOutlet weak var fIncreaseButton: UIButton!
    @IBOutlet weak var dIncreaseButton: UIButton!
    
    
    public var skip = false
    
    //Layout
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var centerView: UIView!
    
    // Saving nutrition info
    private var grain = 0.0
    private var protein = 0.0
    private var fruit = 0.0
    private var vegetable = 0.0
    private var dairy = 0.0
    // For tutorial walkthrough
    
    let coachMarksController = CoachMarksController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let locale = NSLocale.current.languageCode
        if (locale == "zh")
        {
            vIncreaseButtonn.setImage(#imageLiteral(resourceName: "zh_Icon_VegetableBlank"), for: .normal)
            gIncreaseButton.setImage(#imageLiteral(resourceName: "zh_Icon_GrainBlank"), for: .normal)
            pIncreaseButton.setImage(#imageLiteral(resourceName: "zh_Icon_ProteinBlank"), for: .normal)
            fIncreaseButton.setImage(#imageLiteral(resourceName: "zh_Icon_FruitBlank"), for: .normal)
            dIncreaseButton.setImage(#imageLiteral(resourceName: "zh_Icon_DairyBlank"), for: .normal)
        }
        /*else if (locale == "zh-Hans")
        {
            vIncreaseButtonn.setImage(#imageLiteral(resourceName: "zh_hans_Icon_VegetableBlank"), for: .normal)
            gIncreaseButton.setImage(#imageLiteral(resourceName: "zh_hans_Icon_GrainBlank"), for: .normal)
            pIncreaseButton.setImage(#imageLiteral(resourceName: "zh_hans_Icon_ProteinBlank"), for: .normal)
            fIncreaseButton.setImage(#imageLiteral(resourceName: "zh_hans_Icon_FruitBlank"), for: .normal)
            dIncreaseButton.setImage(#imageLiteral(resourceName: "zh_hans_Icon_DairyBlank"), for: .normal)
        }*/
        
        LaunchCamera = true
        pickerdismiss = false
        // Working with interface transition
        addnoteText.text = "add some note here...".localized()
        addnoteText.textColor = UIColor.lightGray
        addnoteText.delegate = self
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if LaunchCamera! && LaunchCameraTimes < 1
        {
            showPicker()
            LaunchCameraTimes += 1
        }else
        {
            if image.image == nil
            {
                performSegue(withIdentifier: "closeSegue", sender: nil)
                //      image.image = #imageLiteral(resourceName: "Sample_Image")
                // Return Home
            }else
            {
                LaunchCamera = false
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        image.image = nil
    }
    
    @objc func showPicker() {
        // Configuration
        var config = YPImagePickerConfiguration()
        
        // Uncomment and play around with the configuration 👨‍🔬 🚀
        
        //        /// Set this to true if you want to force the  library output to be a squared image. Defaults to false
        config.library.onlySquare = true
        //
        //        /// Set this to true if you want to force the camera output to be a squared image. Defaults to true
        config.onlySquareImagesFromCamera = true
        //
        //        /// Ex: cappedTo:1024 will make sure images from the library will be
        //        /// resized to fit in a 1024x1024 box. Defaults to original image size.
        //        config.libraryTargetImageSize = .cappedTo(size: 1024)
        //
        //        /// Enables videos within the library. Defaults to false
        //        config.showsVideoInLibrary = true
        //
        //        /// Enables selecting the front camera by default, useful for avatars. Defaults to false
        //        config.usesFrontCamera = true
        //
        //        /// Adds a Filter step in the photo taking process.  Defaults to true
        config.showsFilters = true
        //
        //        /// Enables you to opt out from saving new (or old but filtered) images to the
        //        /// user's photo library. Defaults to true.
        config.shouldSaveNewPicturesToAlbum = false
        //
        //        /// Choose the videoCompression.  Defaults to AVAssetExportPresetHighestQuality
        //        config.videoCompression = AVAssetExportPreset640x480
        //
        //        /// Defines the name of the album when saving pictures in the user's photo library.
        //        /// In general that would be your App name. Defaults to "DefaultYPImagePickerAlbumName"
        //        config.albumName = "ThisIsMyAlbum"
        //
        //        /// Defines which screen is shown at launch. Video mode will only work if `showsVideo = true`.
        //        /// Default value is `.photo`
        //        config.startOnScreen = .video
        //
        //        /// Defines which screens are shown at launch, and their order.
        //        /// Default value is `[.library, .photo]`
        // config.screens = [.library, .photo]
        //
        //        /// Defines the time limit for recording videos.
        //        /// Default is 30 seconds.
        //        config.videoRecordingTimeLimit = 5.0
        //
        //        /// Defines the time limit for videos from the library.
        //        /// Defaults to 60 seconds.
        //        config.videoFromLibraryTimeLimit = 10.0
        //
        //        /// Adds a Crop step in the photo taking process, after filters.  Defaults to .none
        //        config.showsCrop = .rectangle(ratio: (16/9))
        
        // Set it the default conf for all Pickers
        //      YPImagePicker.setDefaultConfiguration(config)
        // And then use the default configuration like so:
        //      let picker = YPImagePicker()
        
        
        
        // Here we use a per picker configuration.
        let picker = YPImagePicker(configuration: config)
        
        // unowned is Mandatory since it would create a retain cycle otherwise :)
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let img = items.singlePhoto {
                self.image.image = img.image
                self.image.alpha = 1
                self.addnoteText.alpha = 1
                self.centerView.alpha = 1
                self.doneButton.alpha = 1
                self.navBar.alpha = 1
                self.savingDateLabel.alpha = 1
                self.dateButton.alpha = 1
                picker.dismiss(animated: true, completion: {
                    if UserDefaultsHandler().getAddNoteTip() != true
                    {
                        self.coachMarksController.dataSource = self
                        self.coachMarksController.start(on: self)
                        self.coachMarksController.overlay.allowTap = true
                        let skipView = CoachMarkSkipDefaultView()
                        skipView.setTitle("Skip", for: .normal)
                        self.coachMarksController.skipView = skipView
                    }
                })
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    @IBAction func close(_ sender: Any)
    {
        addnoteText.text = nil
        image.image = nil
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func decreaseNutritionElement(_ sender: AnyObject)
    {
        switch sender.tag
        {
        case 0:
            vegetable -= 0.5
            if vegetable == 0.0
            {
                vegetableField.alpha = 0
                vegetableCountLabel.alpha = 0
            }
            vegetableCountLabel.text = "x\(String(vegetable))"
        case 1:
            protein -= 0.5
            if protein == 0.0
            {
                proteinField.alpha = 0
                proteinCountLabel.alpha = 0
            }
            proteinCountLabel.text = "x\(String(protein))"
        case 2:
            fruit -= 0.5
            if fruit == 0.0
            {
                fruitField.alpha = 0
                fruitCountLabel.alpha = 0
            }
            fruitCountLabel.text = "x\(String(fruit))"
        case 3:
            grain -= 0.5
            if grain == 0.0
            {
                grainField.alpha = 0
                grainCountLabel.alpha = 0
            }
            grainCountLabel.text = "x\(String(grain))"
        case 4:
            dairy -= 0.5
            if dairy == 0.0
            {
                dairyField.alpha = 0
                dairyCountLabel.alpha = 0
            }
            dairyCountLabel.text = "x\(String(dairy))"
        default:
            print("none")
        }
        if (vegetable == 0.0 && grain == 0.0 && protein == 0.0 && fruit == 0.0 && dairy == 0.0)
        {
            decreaseIntro.alpha = 0
        }
    }
    
    //Working with nutrition element selection
    @IBAction func nutritionTapped(_ sender: AnyObject)
    {
        decreaseIntro.alpha = 1
        switch sender.tag
        {
        case 1:
            vegetable += 0.5
            vegetableField.alpha = 1
            vegetableCountLabel.alpha = 1
            vegetableCountLabel.text = "x\(String(vegetable))"
        case 2:
            grain += 0.5
            grainField.alpha = 1
            grainCountLabel.alpha = 1
            grainCountLabel.text = "x\(String(grain))"
        case 3:
            protein += 0.5
            proteinField.alpha = 1
            proteinCountLabel.alpha = 1
            proteinCountLabel.text = "x\(String(protein))"
        case 4:
            fruit += 0.5
            fruitField.alpha = 1
            fruitCountLabel.alpha = 1
            fruitCountLabel.text = "x\(String(fruit))"
        case 5:
            dairy += 0.5
            dairyField.alpha = 1
            dairyCountLabel.alpha = 1
            dairyCountLabel.text = "x\(String(dairy))"
        default:
            print("none")
        }
    }
    @IBAction func doneTapped(_ sender: Any)
    {
        Analytics.logEvent("Done_with_AddCam", parameters: nil)
        if(vegetable == 0.0 && grain == 0.0 && protein == 0.0 && fruit == 0.0 && dairy == 0.0)
        {
            let noEntryAlert = UIAlertController(title: nil, message: "Are you sure you don't want to record anything?".localized(), preferredStyle: UIAlertControllerStyle.alert)
            noEntryAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (Alert) in
                if !self.dateChanged
                {
                    let format = DateFormatter()
                    format.dateFormat = "yyyy-MM-dd-hh-mm-ss"
                    let currentTime = Date()
                    let currentFileName = "\(format.string(from: currentTime)).jpg"
                    print(currentFileName)
                    self.saveImage(imageName: currentFileName, time: currentTime)
                }else
                {
                    let format = DateFormatter()
                    format.dateFormat = "yyyy-MM-dd-hh-mm-ss"
                    let currentFileName = "\(format.string(from: self.savedDate!)).jpg"
                    print(currentFileName)
                    self.saveImage(imageName: currentFileName, time: self.savedDate!)
                }
                self.performSegue(withIdentifier: "closeSegue", sender: nil)
            }))
            noEntryAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            present(noEntryAlert, animated: true, completion: nil)
        }else
        {
            if !dateChanged
            {
                let format = DateFormatter()
                format.dateFormat = "yyyy-MM-dd-hh-mm-ss"
                let currentTime = Date()
                let currentFileName = "\(format.string(from: currentTime)).jpg"
                print(currentFileName)
                saveImage(imageName: currentFileName, time: currentTime)
            }else
            {
                let format = DateFormatter()
                format.dateFormat = "yyyy-MM-dd-hh-mm-ss"
                let currentFileName = "\(format.string(from: savedDate!)).jpg"
                print(currentFileName)
                saveImage(imageName: currentFileName, time: savedDate!)
            }
            self.performSegue(withIdentifier: "closeSegue", sender: nil)
        }
    }
    
    // Save image to database
    func saveImage(imageName: String, time: Date)
    {
        //create an instance of the FileManager
        let fileManager = FileManager.default
        //get the image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        //get the JPG data for this image
        let data = UIImageJPEGRepresentation(image.image!, 0.5)
        //store it in the document directory
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
        
        // Coredatas
        var notes = ""
        let nutritionValues = [grain,vegetable,protein,fruit,dairy] // Grain,Vegetable,Protein,Fruit,Dairy
        // Set note
        if addnoteText.text != "add some note here...".localized()
        {
            notes = addnoteText.text
        }
        //Save to Core
        CoreDataHandler().setNewRecord(time: time, imageName: imageName, note: notes, nutritionInfo: nutritionValues)
    }
    
    // Working with textfield ##
    func textViewDidBeginEditing(_ textView: UITextView) {
        if addnoteText.textColor == UIColor.lightGray
        {
            addnoteText.text = ""
            addnoteText.textColor = UIColor.black
        }
        doneButton.alpha = 0.25
    }
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if addnoteText.text == ""
        {
            addnoteText.text = "add some note here...".localized()
            addnoteText.textColor = UIColor.lightGray
        }
        doneButton.alpha = 1
    }
    
    // Show instructions
    @IBAction func instructionTapped(_ sender: Any)
    {
        // Log to analytics
        Analytics.logEvent("Instruction_with_AddCam", parameters: nil)
        // Create a custom view controller
        let InstructionPopUpVC = InstructionPopUpViewController(nibName: "InstructionPopUpViewController", bundle: nil)
        
        // Create the dialog
        let popup = PopupDialog(viewController: InstructionPopUpVC, buttonAlignment: .horizontal, transitionStyle: .bounceUp, preferredWidth: 320, gestureDismissal: true, hideStatusBar: true)
        
        // Create first button
        let buttonOne = CancelButton(title: "I understand now".localized(), height: 60) {
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne])
        
        // Present dialog
        present(popup, animated: true, completion: nil)
    }
    var dateChanged = false
    var showDate = ""
    var savedDate: Date?
    @IBAction func changeDateTapped(_ sender: Any)
    {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let todayAction = UIAlertAction(title: "Today".localized(), style: .default) { (Alert) in
            self.dateChanged = true
            self.showDate = "Today".localized()
            self.dateButton.setTitle(self.showDate, for: .normal)
            self.savedDate = Date()
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let formatterSaved = DateFormatter()
        formatterSaved.dateFormat = "yyyy-MM-dd-mm-ss"
        
        let yesterdayAction = UIAlertAction(title: "Yesterday".localized(), style: .default) { (Alert) in
            self.showDate = formatter.string(from: Date().yesterday)
            self.dateChanged = true
            self.dateButton.setTitle(self.showDate, for: .normal)
            self.savedDate = Date().yesterday
        }
        
        let customAction = UIAlertAction(title: "Set Custom Date".localized(), style: .default) { (Alert) in
            // Create a custom view controller
            
            DatePickerDialog().show("Set Date".localized(), doneButtonTitle: "Done".localized(), cancelButtonTitle: "Cancel".localized(), datePickerMode: .date) {
                (date) -> Void in
                if let dt = date {
                    self.showDate = formatter.string(from: dt)
                    self.dateChanged = true
                    self.dateButton.setTitle(self.showDate, for: .normal)
                    self.savedDate =  dt
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        optionMenu.addAction(todayAction)
        optionMenu.addAction(yesterdayAction)
        optionMenu.addAction(customAction)
        optionMenu.addAction(cancelAction)
        
        //dateButton.setTitle(showDate, for: .normal)
        
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Protocol Conformance | CoachMarksControllerDataSource
extension AddInfoViewController: CoachMarksControllerDataSource
{
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?)
    {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        
        switch(index)
        {
        case 0:
            coachViews.bodyView.hintLabel.text = "Add some notes and related information here!".localized()
            coachViews.bodyView.nextLabel.text = "Next".localized()
        case 1:
            coachViews.bodyView.hintLabel.text = "Tap on the food groups that you think your food contains and record the correct servings!".localized()
            coachViews.bodyView.nextLabel.text = "Next".localized()
        case 2:
            coachViews.bodyView.hintLabel.text = "Tap here to help with identifying food groups and counting their servings!".localized()
            coachViews.bodyView.nextLabel.text = "Done".localized()
        default: break
        }
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        
        switch(index)
        {
        case 0:
            return coachMarksController.helper.makeCoachMark(for: self.addnoteText)
        case 1:
            return coachMarksController.helper.makeCoachMark(for: self.foodgroupStackView)
        case 2:
            UserDefaultsHandler().setAddNoteTip(status: true)
            return coachMarksController.helper.makeCoachMark(for: self.instructionOutlet)
        default:
            return coachMarksController.helper.makeCoachMark()
        }
        
    }
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int
    {
        return 3
    }
}

