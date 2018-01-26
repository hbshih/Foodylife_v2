//
//  DashboardViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 19/01/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit
import CoreData

class DashboardViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var circularProgress: KDCircularProgress!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var centerImage: UIImageView!
    @IBOutlet weak var navDash: UINavigationItem!
    // General Variables
    var images: [UIImage] = []
    var fileName: [String] = []
    var dashboardType: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Building interface
        buildDashboard()
        
        if dashboardType != ""
        {
            // Accessing Core Data
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
                        let searchFor = "n_\(dashboardType!)"
                        if let vegValue = result.value(forKey: searchFor) as? Int
                        {
                            if let imageName = result.value(forKey: "ImageName") as? String
                            {
                                if vegValue != 0
                                {
                                    fileName.append(imageName)
                                }
                            }
                        }
                    }
                }
            }catch
            {
                print("Retrieving core data error")
            }
            
            fileName = fileName.reversed()
            
            //Getting corresponding images
            let fileManager = FileMangerModel()
            images = fileManager.lookupImage(fileNames: fileName)
            
            // Preparing for scroll image views
            var XCoord:CGFloat = 5
            let yCoord:CGFloat = 5
            let scrollImageWidth:CGFloat =  130
            let scrollImageHeight:CGFloat = 130
            let gapBetweenImage:CGFloat = 5
            var itemCount = 0
            // Loading images
            for i in 0..<images.count
            {
                itemCount = i
                let imageForButton = images[itemCount]
                let imageView = UIImageView(image: imageForButton)
                imageView.frame = CGRect(x: XCoord,y: yCoord,width: scrollImageWidth,height: scrollImageHeight)
                imageView.layer.cornerRadius = 6
                imageView.clipsToBounds = true
                XCoord += scrollImageWidth + gapBetweenImage
                // Add it to the view controller
                scrollView.addSubview(imageView)
            }
            scrollView.contentSize = CGSize(width: scrollImageWidth * CGFloat(itemCount + 2),height: yCoord + 50)
        }
    }
    
    func buildDashboard()
    {
        var data = accessNutritionData()
        var rate = balanceRate()
        data.viewDidLoad()
        rate.fileName = data.fileName
        rate.grainList = data.grainList
        rate.fruitList = data.fruitList
        rate.dairyList = data.dairyList
        rate.proteinList = data.proteinList
        rate.vegetableList = data.vegetableList
        rate.setPercentage()
        if dashboardType == "Vegetable"
        {
            navDash.title = "Vegetable Dashboard"
            centerImage.image = #imageLiteral(resourceName: "Icon_Vegetable")
            setUpSlider(value: rate.averageVegetable*3.6)
        } else if dashboardType == "Grain"
        {
            navDash.title = "Grain Dashboard"
            centerImage.image = #imageLiteral(resourceName: "Icon_Grain")
            setUpSlider(value: rate.averageGrain*3.6)
        }else if dashboardType == "Protein"
        {
            navDash.title = "Protein Dashboard"
            centerImage.image = #imageLiteral(resourceName: "Icon_Protein")
            setUpSlider(value: rate.averageProtein*3.6)
        }else if dashboardType == "Fruit"
        {
            navDash.title = "Fruit Dashboard"
            centerImage.image = #imageLiteral(resourceName: "Icon_Fruit")
            setUpSlider(value: rate.averageFruit*3.6)
        }else
        {
            navDash.title = "Dairy Dashboard"
            centerImage.image = #imageLiteral(resourceName: "Icon_Dairy")
            setUpSlider(value: rate.averageDairy*3.6)
        }
    }
    
    func setUpSlider(value: Double)
    {
        let slider = circularProgress!
        slider.animate(toAngle: value, duration: 1.0, completion: nil)
        if value >= 0 && value <= 30
        {
            slider.set(colors: UIColor(red:0.99, green:0.44, blue:0.39, alpha:1.0))
            slider.trackColor = UIColor(red:0.99, green:0.44, blue:0.39, alpha:0.2)
        }// Yellow -- Neutral
        else if value > 30 && value <= 180
        {
            slider.set(colors: UIColor(red:0.99, green:0.82, blue:0.39, alpha:1.0))
            slider.trackColor = UIColor(red:0.99, green:0.82, blue:0.39, alpha:0.2)
        }
            // Blue -- Good
        else if value > 180 && value <= 330
        {
            slider.set(colors:UIColor(red:0.39, green:0.82, blue:0.99, alpha:1.0))
            slider.trackColor = UIColor(red:0.39, green:0.82, blue:0.99, alpha:0.2)
        }else if value > 330 && value <= 360
        {
            slider.set(colors: UIColor(red:0.60, green:0.80, blue:0.29, alpha:1.0))
            slider.trackColor = UIColor(red:0.60, green:0.80, blue:0.29, alpha:0.2)
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
