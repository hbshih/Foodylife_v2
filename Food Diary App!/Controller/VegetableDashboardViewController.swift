//
//  VegetableDashboardViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 14/01/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit
import CoreData

class VegetableDashboardViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    var images: [UIImage] = []
    var fileName: [String] = []
    var notes: [String] = []
    //var revFileName: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntries")
        
        request.returnsObjectsAsFaults = false
        
        do
        {
            let results = try context.fetch(request)
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    if let imageName = result.value(forKey: "imageName") as? String
                    {
                        fileName.append(imageName)
                        if let note = result.value(forKey: "note") as? String
                        {
                            notes.append(note)
                        }
                    }
                }
            }
        }catch
        {
            print("Retrieving core data error")
        }
        
        if fileName.count != 0
        {
            let fileManager = FileManager.default
            for imageName in fileName
            {
                let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
                if fileManager.fileExists(atPath: imagePath){
                    if let outputImage = UIImage(contentsOfFile: imagePath)
                    {
                        images.append(outputImage)
                    }else
                    {
                        print("cannot find \(imagePath)")
                    }
                }else{
                    print("Panic! No Image!")
                }
            }
        }
        
        var XCoord:CGFloat = 5
        let yCoord:CGFloat = 5
        let scrollImageWidth:CGFloat =  130
        let scrollImageHeight:CGFloat = 130
        let gapBetweenImage:CGFloat = 5
        var itemCount = 0
        
        for i in 0..<images.count
        {
            itemCount = i
            let imagebutton = UIButton(type:.custom)
            imagebutton.frame = CGRect(x: XCoord,y: yCoord,width: scrollImageWidth,height: scrollImageHeight)
            imagebutton.addTarget(self,action:#selector(imageButtonTapped(sender:)),for:.touchUpInside)
            imagebutton.layer.cornerRadius = 6
            imagebutton.clipsToBounds = true
            let imageForButton = images[itemCount]
            imagebutton.setBackgroundImage(imageForButton,for:.normal)
            XCoord += scrollImageWidth + gapBetweenImage
            scrollView.addSubview(imagebutton)
        }
        scrollView.contentSize = CGSize(width: scrollImageWidth * CGFloat(itemCount + 2),height: yCoord + 50)
        
    }
    
    @objc func imageButtonTapped(sender:UIButton)
    {
        print("Tapped")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
