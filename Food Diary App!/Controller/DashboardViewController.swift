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
    @IBOutlet weak var informationLabel: UILabel!
    // General Variables
    var images: [UIImage] = []
    var fileName: [String] = []
    var dashboardType: String?
    // Create and data handler to handle all core data query
    private var dataHandler = CoreDataHandler()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        //Building interface
        buildDashboard()
        
        
        if dashboardType != ""
        {
            // Core data handler
            fileName = dataHandler.getImageFilename(type: "n_\(dashboardType!)")
            print(fileName)
            
            //Getting corresponding images
            let fileManager = FileManagerModel()
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
        informationLabel.text = "Your Recent \(dashboardType!)".localized()
        navDash.title = "\(dashboardType!) Dashboard".localized()
        var healthData = HealthPercentageCalculator(nutritionDic: dataHandler.get5nList(), timestamp: dataHandler.getTimestamp())
        
        if dashboardType == "Vegetable"
        {
            centerImage.image = #imageLiteral(resourceName: "Icon_Vegetable")
            setUpSlider(value: healthData.getEachNutritionHealthAverage()["averageVegetable"]!*5)
        } else if dashboardType == "Grain"
        {
            centerImage.image = #imageLiteral(resourceName: "Icon_Grain")
            setUpSlider(value: healthData.getEachNutritionHealthAverage()["averageGrain"]!*5)
        }else if dashboardType == "Protein"
        {
            centerImage.image = #imageLiteral(resourceName: "Icon_Protein")
            setUpSlider(value: healthData.getEachNutritionHealthAverage()["averageProtein"]!*5)
        }else if dashboardType == "Fruit"
        {
            centerImage.image = #imageLiteral(resourceName: "Icon_Fruit")
            setUpSlider(value: healthData.getEachNutritionHealthAverage()["averageFruit"]!*5)
        }else
        {
            centerImage.image = #imageLiteral(resourceName: "Icon_Dairy")
            setUpSlider(value: healthData.getEachNutritionHealthAverage()["averageDairy"]!*5)
        }
    }
    
    func setUpSlider(value: Double)
    {
        var sliderDeterminer = circularSliderDeterminer(value: value, count: 2)
        let slider = circularProgress!
        slider.set(colors: sliderDeterminer.getSliderColour())
        slider.trackColor = sliderDeterminer.getSliderTrackColour()
        slider.animate(toAngle: sliderDeterminer.getSliderValue(), duration: 1.0, completion: nil)
        /*
        slider.animate(toAngle: value, duration: 1.0, completion: nil)
        if value >= 0 && value <= 75
        {
            slider.set(colors: UIColor(red:0.99, green:0.44, blue:0.39, alpha:1.0))
            slider.trackColor = UIColor(red:0.99, green:0.44, blue:0.39, alpha:0.2)
        }// Yellow -- Neutral
        else if value > 75 && value <= 225
        {
            slider.set(colors: UIColor(red:0.99, green:0.82, blue:0.39, alpha:1.0))
            slider.trackColor = UIColor(red:0.99, green:0.82, blue:0.39, alpha:0.2)
        }
            // Blue -- Good
        else if value > 225 && value <= 300
        {
            slider.set(colors:UIColor(red:0.39, green:0.82, blue:0.99, alpha:1.0))
            slider.trackColor = UIColor(red:0.39, green:0.82, blue:0.99, alpha:0.2)
        }else if value > 300 && value <= 360
        {
            slider.set(colors: UIColor(red:0.60, green:0.80, blue:0.29, alpha:1.0))
            slider.trackColor = UIColor(red:0.60, green:0.80, blue:0.29, alpha:0.2)
        }*/
    }
    @IBAction func BackTapped(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
