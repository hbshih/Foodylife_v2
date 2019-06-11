//
//  ConfirmPhotoViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 21/12/2017.
//  Copyright © 2017 BenShih. All rights reserved.
//

import UIKit
import CoreData
import PopupDialog
import Instructions
import FirebaseAnalytics

class ConfirmPhotoViewController:UIViewController, UITextViewDelegate
{
    @IBOutlet weak var containerView:UIView!
    @IBOutlet weak var originalImage:UIImageView!
    @IBOutlet weak var imageToFilter:UIImageView!
    @IBOutlet weak var filtersScrollView:UIScrollView!
    @IBOutlet weak var buttonBar:UIView!
    @IBOutlet weak var doneButton: UIButton!
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
    // Genetal Variables
    var image: UIImage?
    
    // Saving nutrition info
    private var grain = 0.0
    private var protein = 0.0
    private var fruit = 0.0
    private var vegetable = 0.0
    private var dairy = 0.0
    
    // Array of all filters
    private var CIFilterNames = [
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone",
        "CIVignette",
        "CIGaussianBlur",
        "CIColorControls"
    ]
    
    //Tutorial for new users
    private let coachMarksController = CoachMarksController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Working with interface transition
        addnoteText.text = "add some note here..."
        addnoteText.textColor = UIColor.lightGray
        addnoteText.delegate = self
        originalImage.image = image
       // originalImage.image = image
        doneButton.alpha = 1
        buttonBar.alpha = 0
        //Working with scrollbar
        var XCoord:CGFloat = 5
        let yCoord:CGFloat = 5
        let buttonWidth:CGFloat = 80
        let buttonHeight:CGFloat = 80
        let gapBetweenButtons:CGFloat = 5
        
        // For each filter, create it as a button with filtered-image in the scroll bar
        var itemCount = 5
        for i in 0..<CIFilterNames.count
        {
            itemCount = i
            let filterButton = UIButton(type:.custom)
            filterButton.frame = CGRect(x: XCoord,y: yCoord,width: buttonWidth,height: buttonHeight)
            filterButton.tag = itemCount
            filterButton.addTarget(self,action:#selector(filterButtonTapped(sender:)),for:.touchUpInside)
            filterButton.layer.cornerRadius = 6
            filterButton.clipsToBounds = true
            
            let ciContext = CIContext(options:nil)
            let coreImage = CIImage(image:originalImage.image!)
            let filter = CIFilter(name:"\(CIFilterNames[i])")
            filter?.setDefaults()
            filter!.setValue(coreImage,forKey:kCIInputImageKey)
            let filteredImageData = filter!.value(forKey:kCIOutputImageKey) as! CIImage
            let filteredImageRef = ciContext.createCGImage(filteredImageData,from:filteredImageData.extent)
            let imageForButton = UIImage(cgImage:filteredImageRef!)
            filterButton.setBackgroundImage(imageForButton,for:.normal)
            XCoord += buttonWidth + gapBetweenButtons
            filtersScrollView.addSubview(filterButton)
        }
        filtersScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(itemCount + 2),height: yCoord + 50)
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
    }
    
    //Working with nutrition element selection
    @IBAction func nutritionTapped(_ sender: AnyObject)
    {
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
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Show pop up dialog
    @IBAction func doneTapped(_ sender: Any)
    {
        UIView.animate(withDuration: 0.2, animations: {self.buttonBar.alpha = 1}, completion: nil)
        doneButton.alpha = 0
        filtersScrollView.alpha = 0
        addnoteText.alpha = 0
        // Show tutorial if is a new user.
        if !(UserDefaultsHandler().getAddDataTutorialStatus())
        {
            self.coachMarksController.dataSource = self
            self.coachMarksController.start(on: self)
        }
    }
    // Prepare to save image
    @IBAction func completeTapped(_ sender: Any)
    {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd-hh-mm-ss"
        let currentTime = Date()
        let currentFileName = "img\(format.string(from: currentTime)).jpg"
        saveImage(imageName: currentFileName, time: currentTime)
    }
    
    // Save image to database
    func saveImage(imageName: String, time: Date)
    {
        //create an instance of the FileManager
        let fileManager = FileManager.default
        //get the image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        //get the image we took with camera
        let imageSaveImage: UIImage
        if imageToFilter.image != nil
        {
            //Filtered
            imageSaveImage = imageToFilter.image!
        }else
        {
            //Unfiltered
            imageSaveImage = originalImage.image!
        }
        //get the JPG data for this image
        let data = UIImageJPEGRepresentation(imageSaveImage, 0.5)
        //store it in the document directory
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
        
        // Coredatas
        var notes = ""
        let nutritionValues = [grain,vegetable,protein,fruit,dairy] // Grain,Vegetable,Protein,Fruit,Dairy
        // Set note
        if addnoteText.text != "add some note here..."
        {
            notes = addnoteText.text
        }
        //Save to Core
        CoreDataHandler().setNewRecord(time: time, imageName: imageName, note: notes, nutritionInfo: nutritionValues)
    }
    
    //Action when filter is tapped (Change the current image to filtered ones)
    @objc func filterButtonTapped(sender:UIButton)
    {
        let button = sender as UIButton
        imageToFilter.image = button.backgroundImage(for: UIControlState.normal)
    }
    
    // Working with textfield ##
    func textViewDidBeginEditing(_ textView: UITextView) {
        if addnoteText.textColor == UIColor.lightGray
        {
            addnoteText.text = ""
            addnoteText.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if addnoteText.text == ""
        {
            addnoteText.text = "add some note here..."
            addnoteText.textColor = UIColor.lightGray
        }
    }

    // Show instructions
    @IBAction func instructionTapped(_ sender: Any)
    {
        // Log to analytics
        Analytics.logEvent("instructionShown", parameters: nil)
        // Create a custom view controller
        let InstructionPopUpVC = InstructionPopUpViewController(nibName: "InstructionPopUpViewController", bundle: nil)
        
        // Create the dialog
        let popup = PopupDialog(viewController: InstructionPopUpVC, buttonAlignment: .horizontal, transitionStyle: .bounceUp, preferredWidth: 320, gestureDismissal: true, hideStatusBar: true)
        
        // Create first button
        let buttonOne = CancelButton(title: "I understand now", height: 60) {
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne])
        
        // Present dialog
        present(popup, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
}

/* Protocol for tutorial walkthrough*/

// MARK: - Protocol Conformance | CoachMarksControllerDataSource
extension ConfirmPhotoViewController: CoachMarksControllerDataSource
{
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int
    {
        return 2
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark
    {
        switch(index) {
        case 0:
            return coachMarksController.helper.makeCoachMark(for: foodgroupStackView)
        case 1:
            return coachMarksController.helper.makeCoachMark(for: instructionOutlet)
        default:
            return coachMarksController.helper.makeCoachMark()
        }
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?)
    {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        
        switch(index) {
        case 0:
            coachViews.bodyView.hintLabel.text = "Tap those groups that you think your plate contains!"
            coachViews.bodyView.nextLabel.text = "OK"
            
        case 1:
            coachViews.bodyView.hintLabel.text = "Tap here for some tips to help you categorize them."
            coachViews.bodyView.nextLabel.text = "Got it"
            UserDefaultsHandler().setAddDataTutorialStatus(status: true)
        default: break
        }
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
}
