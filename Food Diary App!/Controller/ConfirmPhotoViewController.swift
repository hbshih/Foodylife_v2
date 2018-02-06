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

class ConfirmPhotoViewController:UIViewController, UITextViewDelegate
{
    @IBOutlet weak var containerView:UIView!
    @IBOutlet weak var originalImage:UIImageView!
    @IBOutlet weak var imageToFilter:UIImageView!
    @IBOutlet weak var filtersScrollView:UIScrollView!
    @IBOutlet weak var buttonBar:UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var addnoteText: UITextView!
    @IBOutlet weak var dairyField: UIImageView!
    @IBOutlet weak var proteinField: UIImageView!
    @IBOutlet weak var grainField: UIImageView!
    @IBOutlet weak var fruitField: UIImageView!
    @IBOutlet weak var vegetableField: UIImageView!
    @IBOutlet weak var vegetableCountLabel: UILabel!
    @IBOutlet weak var dairyCountLabel: UILabel!
    @IBOutlet weak var proteinCountLabel: UILabel!
    @IBOutlet weak var grainCountLabel: UILabel!
    @IBOutlet weak var fruitCountLabel: UILabel!
    // Genetal Variables
    var image:UIImage?
    // Saving nutrition info
    var grain = 0.0
    var protein = 0.0
    var fruit = 0.0
    var vegetable = 0.0
    var dairy = 0.0
    // Array of all filters
    var CIFilterNames = [
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone",
        "CIColorControls"
    ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Working with interface transition
        addnoteText.text = "add some note here..."
        addnoteText.textColor = UIColor.lightGray
        addnoteText.delegate = self
        originalImage.image = image
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
            print("grain: \(vegetable)")
        case 2:
            grain += 0.5
            grainField.alpha = 1
            grainCountLabel.alpha = 1
            grainCountLabel.text = "x\(String(grain))"
            print("fruit: \(grain)")
        case 3:
            protein += 0.5
            proteinField.alpha = 1
            proteinCountLabel.alpha = 1
            proteinCountLabel.text = "x\(String(protein))"
            print("protein: \(protein)")
        case 4:
            fruit += 0.5
            fruitField.alpha = 1
            fruitCountLabel.alpha = 1
            fruitCountLabel.text = "x\(String(fruit))"
            print("vegetable: \(fruit)")
        case 5:
            dairy += 0.5
            dairyField.alpha = 1
            dairyCountLabel.alpha = 1
            dairyCountLabel.text = "x\(String(dairy))"
            print("dairy: \(dairy)")
        default:
            alertMessage(title: "You sure?", message: "Are you sure you don't want to add some nutrition?")
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
    }
    // Save image
    @IBAction func completeTapped(_ sender: Any)
    {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd-hh-mm-ss"
        let currentTime = Date()
        let currentFileName = "img\(format.string(from: currentTime))"
        saveImage(imageName: currentFileName, time: currentTime)
    }

    // Save image processing
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
            imageSaveImage = imageToFilter.image!
        }else
        {
            imageSaveImage = originalImage.image!
        }
        //get the JPG data for this image
        let data = UIImageJPEGRepresentation(imageSaveImage, 0.5)
        //store it in the document directory
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)

        // Accessing core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newValue = NSEntityDescription.insertNewObject(forEntityName: "UserEntries", into: context)
        // Setting values for each corresponding data
        newValue.setValue(time, forKey: "time")
        newValue.setValue(imageName, forKey: "imageName")
        if addnoteText.text != "add some note here..."
        {
            newValue.setValue(addnoteText.text, forKey: "note")
        }else
        {
            newValue.setValue("", forKey: "note")
        }
        if grain != 0
        {
            newValue.setValue(grain, forKey: "n_Grain")
        }else
        {
            newValue.setValue(0, forKey: "n_Grain")
        }
        if fruit != 0
        {
            newValue.setValue(fruit, forKey: "n_Fruit")
        }else
        {
            newValue.setValue(0, forKey: "n_Fruit")
        }
        if protein != 0
        {
            newValue.setValue(protein
                , forKey: "n_Protein")
        }else
        {
            newValue.setValue(0, forKey: "n_Protein")
        }
        if vegetable != 0
        {
            newValue.setValue(vegetable, forKey: "n_Vegetable")
        }else
        {
            newValue.setValue(0, forKey: "n_Vegetable")
        }
        if dairy != 0
        {
            newValue.setValue(dairy, forKey: "n_Dairy")
        }else
        {
            newValue.setValue(0, forKey: "n_Dairy")
        }
        do {
            try context.save()
            print("All data saved succesfully")
        } catch {
            alertMessage(title: "Problem with saving", message: "Sorry")
            print("Problem Saving Data")
        }
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
    //##
    func alertMessage(title: String, message: String)
    {
        let mes = AlertMessage()
        mes.displayAlert(title: title, message: message, VC: self)
    }
    @IBAction func instructionTapped(_ sender: Any)
    {
        // Create a custom view controller
        let InstructionPopUpVC = InstructionPopUpViewController(nibName: "InstructionPopUpViewController", bundle: nil)
        
        // Create the dialog
        let popup = PopupDialog(viewController: InstructionPopUpVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        
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
