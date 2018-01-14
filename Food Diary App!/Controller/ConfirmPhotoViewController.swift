//
//  ConfirmPhotoViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 21/12/2017.
//  Copyright © 2017 BenShih. All rights reserved.
//

import UIKit
import CoreData

class ConfirmPhotoViewController:UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var containerView:UIView!
    @IBOutlet weak var originalImage:UIImageView!
    @IBOutlet weak var imageToFilter:UIImageView!
    @IBOutlet weak var filtersScrollView:UIScrollView!
    @IBOutlet weak var buttonBar:UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var addnoteText: UITextView!
    
    
    var image:UIImage?
    
    // Array of all filters
    var CIFilterNames = [
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone"
    ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addnoteText.text = "add some note here..."
        addnoteText.textColor = UIColor.lightGray
        addnoteText.delegate = self
        
        originalImage.image = image
        
        var XCoord:CGFloat = 5
        let yCoord:CGFloat = 5
        let buttonWidth:CGFloat = 80
        let buttonHeight:CGFloat = 80
        let gapBetweenButtons:CGFloat = 5
        doneButton.alpha = 1
        
        buttonBar.alpha = 0
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneTapped(_ sender: Any)
    {
        UIView.animate(withDuration: 0.2, animations: {self.buttonBar.alpha = 1}, completion: nil)
        doneButton.alpha = 0
        filtersScrollView.alpha = 0
        addnoteText.alpha = 0
    }
    @IBAction func completeTapped(_ sender: Any)
    {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd-hh-mm-ss"
     //   let currentTime = "\(format.string(from: Date()))"
        let currentTime = Date()
        let currentFileName = "img\(format.string(from: Date()))"
        saveImage(imageName: currentFileName, time: currentTime)
        if addnoteText.text != "add some note here..."
        {
          //  saveText(textName: currentFileName)
        }
    }
    
    func saveText(textName: String)
    {
        let file = "\(textName)txt" //this is the file.
        let text = addnoteText.text
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
            //writing
            do {
                try text?.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {/* error handling here */}
        }
    }
    
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
        //print("This is the image path \(imagePath)")

        // Update the image name array to keep track of all the photos
        let defaults = UserDefaults.standard
        var myarray = defaults.object(forKey: "imageFileName") as? [String] ?? [String]()
        myarray.append(imageName)
        defaults.set(myarray, forKey: "imageFileName")
        for i in myarray
        {
            print("\(i) saved succesfully\n")
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newValue = NSEntityDescription.insertNewObject(forEntityName: "UserEntries", into: context)
        newValue.setValue(time, forKey: "time")
        newValue.setValue(imageName, forKey: "imageName")
        if addnoteText.text != "add some note here..."
        {
            newValue.setValue(addnoteText.text, forKey: "note")
        }else
        {
            newValue.setValue("", forKey: "note")
        }
        
        do {
            try context.save()
            print("All data saved succesfully")
        } catch {
            print("Problem Saving Data")
        }
    }
    
    @objc func filterButtonTapped(sender:UIButton)
    {
        let button = sender as UIButton
        imageToFilter.image = button.backgroundImage(for: UIControlState.normal)
    }
    
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
    
}
