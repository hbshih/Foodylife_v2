//
//  homepageViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 13/12/2017.
//  Copyright © 2017 BenShih. All rights reserved.
//

import UIKit
import SCLAlertView
import FirebaseDatabase
import FirebaseAuth
import CoreData
import Spring

class homepageViewController: UIViewController {
    
    @IBOutlet weak var dairyCircularSlider: KDCircularProgress!
    @IBOutlet weak var fruitCircularSlider: KDCircularProgress!
    @IBOutlet weak var proteinCircularSlider: KDCircularProgress!
    @IBOutlet weak var grainCircularSlider: KDCircularProgress!
    @IBOutlet weak var vegetableCircularSlider: KDCircularProgress!
    @IBOutlet weak var circularSlider: KDCircularProgress!
    @IBOutlet weak var centerFace: UIButton!
    private var healthPercentage = 0.0
    private var vegetablePercentage = 0.0
    private var dairyPercentage = 0.0
    private var fruitPercentage = 0.0
    private var proteinPercentage = 0.0
    private var grainPercentage = 0.0
    
    // General Variables
    private var images: [UIImage] = [] // Storing Images
    private var fileName: [String] = [] // Storing the names of the images to get images
    private var notes: [String] = [] // Storing notes
    
    @IBOutlet weak var animationDemo: UIImageView!
    // Nutrition Info Variables
    private var dairyList: [Double] = []
    private var vegetableList: [Double] = []
    private var proteinList: [Double] = []
    private var fruitList: [Double] = []
    private var grainList: [Double] = []
    
    private var dataHandler = CoreDataHandler()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        var nutritionDic = dataHandler.get5nList()
        dairyList = nutritionDic["dairyList"]!
        vegetableList = nutritionDic["vegetableList"]!
        proteinList = nutritionDic["proteinList"]!
        fruitList = nutritionDic["fruitList"]!
        grainList = nutritionDic["grainList"]!
        fileName = dataHandler.getImageFilename()
        
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        //-- access nutrtiion data nad blaance rate.swift
        if fileName.count > 2 // After 2 meal
        {
            var healthData = HealthPercentageCalculator(fileNames: dataHandler.getImageFilename(),nutritionDic: dataHandler.get5nList())
            healthPercentage = healthData.getAverageHealth() * 3.6
            vegetablePercentage = healthData.getEachNutritionHealthAverage()["averageVegetable"]! * 3.6
            grainPercentage = healthData.getEachNutritionHealthAverage()["averageGrain"]! * 3.6
            proteinPercentage = healthData.getEachNutritionHealthAverage()["averageProtein"]! * 3.6
            fruitPercentage = healthData.getEachNutritionHealthAverage()["averageFruit"]! * 3.6
            dairyPercentage = healthData.getEachNutritionHealthAverage()["averageDairy"]! * 3.6
            showCircularSliderData()
        }else
        {
            print("Haven't got enough data to show")
        }

        animationDemo.alpha = 1
        self.animationDemo.frame = CGRect(x: 153, y: 123, width: self.animationDemo.frame.width, height: self.animationDemo.frame.height)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.animationDemo.frame = CGRect(x: 90, y: 50, width: self.animationDemo.frame.width, height: self.animationDemo.frame.height)
        }) { (finish) in
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.animationDemo.alpha = 0
            }, completion: nil)
        }
       

    }
    
    func showCircularSliderData()
    {
        setSliderColor(value: vegetablePercentage, slider: vegetableCircularSlider)
        setSliderColor(value: proteinPercentage, slider: proteinCircularSlider)
        setSliderColor(value: grainPercentage, slider: grainCircularSlider)
        setSliderColor(value: dairyPercentage, slider: dairyCircularSlider)
        setSliderColor(value: fruitPercentage, slider: fruitCircularSlider)
        setSliderColor(value: healthPercentage, slider: circularSlider)
        shake(layer: self.centerFace.layer)
    }

    func setSliderColor(value: Double, slider: KDCircularProgress)
    {
        slider.animate(toAngle: value, duration: 1.5, completion: nil)
        if value >= 0 && value <= 30
        {
            slider.set(colors: UIColor(red:0.99, green:0.44, blue:0.39, alpha:1.0))
            slider.trackColor = UIColor(red:0.99, green:0.44, blue:0.39, alpha:0.2)
            if slider == circularSlider
            {centerFace.setImage(UIImage(named: "Face_Sad.png"), for: .normal);print("I am slider : \(slider)")}
        }// Yellow -- Neutral
        else if value > 30 && value <= 180
        {
            slider.set(colors: UIColor(red:0.99, green:0.82, blue:0.39, alpha:1.0))
            slider.trackColor = UIColor(red:0.99, green:0.82, blue:0.39, alpha:0.2)
            if slider == circularSlider {centerFace.setImage(UIImage(named: "Face_Yellow.png"), for: .normal)}
        }
            // Blue -- Good
        else if value > 180 && value <= 330
        {
            slider.set(colors:UIColor(red:0.39, green:0.82, blue:0.99, alpha:1.0))
            slider.trackColor = UIColor(red:0.39, green:0.82, blue:0.99, alpha:0.2)
            if slider == circularSlider {centerFace.setImage(UIImage(named: "Face_Happy.png"), for: .normal)}
        }else if value > 330 && value <= 360
        {
            slider.set(colors: UIColor(red:0.60, green:0.80, blue:0.29, alpha:1.0))
            slider.trackColor = UIColor(red:0.60, green:0.80, blue:0.29, alpha:0.2)
            if slider == circularSlider {centerFace.setImage(UIImage(named: "Face_Smile.png"), for: .normal)}
        }
    }
    
    func shake(layer: CALayer)
    {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    @IBAction func faceTapped(_ sender: Any)
    {
        let appearance = SCLAlertView.SCLAppearance(
            //kCircleIconHeight: 55.0
            kTitleFont: UIFont(name: "HelveticaNeue-Medium", size: 18)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 16)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 18)!,
            showCloseButton: true
        )
        let alert = SCLAlertView(appearance: appearance)
        let icon = UIImage(named:"Alert_Yellow.png")
        let color = UIColor.orange        
        _ = alert.showCustom("STOP", subTitle: "STOP TOUCHING MY EYES! YOU MEATBALL", color: color, icon: icon!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "vegetableDashSegue"
        {
            if let vegeVC = segue.destination as? DashboardViewController
            {
                vegeVC.dashboardType = "Vegetable"
            }
        }else if segue.identifier == "grainDashSegue"
        {
            if let vegeVC = segue.destination as? DashboardViewController
            {
                vegeVC.dashboardType = "Grain"
            }
        }else if segue.identifier == "proteinDashSegue"
        {
            if let vegeVC = segue.destination as? DashboardViewController
            {
                vegeVC.dashboardType = "Protein"
            }
        }else if segue.identifier == "fruitDashSegue"
        {
            if let vegeVC = segue.destination as? DashboardViewController
            {
                vegeVC.dashboardType = "Fruit"
            }
        }else if segue.identifier == "dairyDashSegue"
        {
            if let vegeVC = segue.destination as? DashboardViewController
            {
                vegeVC.dashboardType = "Dairy"
            }
        }else
        {
            
        }
    }
    
}
