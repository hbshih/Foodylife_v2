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

class homepageViewController: UIViewController {
    
    @IBOutlet weak var circularSlider: KDCircularProgress!
    @IBOutlet weak var centerFace: UIButton!
    var healthPercentage = 0
    
    //--
    // General Variables
    var images: [UIImage] = [] // Storing Images
    var fileName: [String] = [] // Storing the names of the images to get images
    var notes: [String] = [] // Storing notes
    
    // Nutrition Info Variables
    var dairyList: [Int] = []
    var vegetableList: [Int] = []
    var proteinList: [Int] = []
    var fruitList: [Int] = []
    var grainList: [Int] = []
    //--
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        circularSlider.startAngle = -90.0
        
        //--
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
                    // Store data in the corresponding array
                    if let imageName = result.value(forKey: "imageName") as? String
                    {
                        var str = imageName.prefix(13)
                        var date = str.suffix(10)
                        self.fileName.append(String(date))
                        if let grain_value = result.value(forKey: "n_Grain") as? Int
                        {
                            if let vegetableValue = result.value(forKey: "n_Vegetable") as? Int
                            {
                                if let fruitValue = result.value(forKey: "n_Fruit") as? Int
                                {
                                    if let dairyValue = result.value(forKey: "n_Dairy") as? Int
                                    {
                                        if let proteinValue = result.value(forKey: "n_Protein") as? Int
                                        {
                                            self.grainList.append(grain_value)
                                            self.vegetableList.append(vegetableValue)
                                            self.proteinList.append(proteinValue)
                                            self.dairyList.append(dairyValue)
                                            self.fruitList.append(fruitValue)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }catch
        {
            print("Retrieving core data error")
        }
        //--
        
        if fileName.count > 2
        {
        var rate = balanceRate()
        rate.fileName = fileName
        rate.dairyList = dairyList
        rate.vegetableList = vegetableList
        rate.proteinList = proteinList
        rate.fruitList = fruitList
        rate.grainList = grainList
        rate.getDailyNumbers()
        }
        
    }
    
    @IBAction func buttonTapped(_ sender: Any)
    {
        
        let newAngleView = newAngle()
        print(newAngleView)
        circularSlider.animate(toAngle: newAngleView, duration: 0.5, completion: nil)
        shake(layer: self.centerFace.layer)
    }
    
    func getHealthInfo()
    {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("Users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                if let number = dictionary["Overall"] as? Int
                {
                    self.healthPercentage = number
                }
            }
            
        }
    }
    
    func newAngle() -> Double
    {
        getHealthInfo()
        print(circularSlider.angle)
        if circularSlider.angle >= 360
        {
            print("----- Start Again -----")
            return 0
        }
        // Red -- Bad Health
        if circularSlider.angle >= 0 && circularSlider.angle <= 30
        {
            circularSlider.set(colors: UIColor(red:0.99, green:0.44, blue:0.39, alpha:1.0))
            circularSlider.trackColor = UIColor(red:0.99, green:0.44, blue:0.39, alpha:0.2)
            centerFace.setImage(UIImage(named: "Face_Sad.png"), for: .normal)
        }// Yellow -- Neutral
        else if circularSlider.angle > 30 && circularSlider.angle <= 180
        {
            circularSlider.set(colors: UIColor(red:0.99, green:0.82, blue:0.39, alpha:1.0))
            circularSlider.trackColor = UIColor(red:0.99, green:0.82, blue:0.39, alpha:0.2)
            centerFace.setImage(UIImage(named: "Face_Yellow.png"), for: .normal)
        }
            // Blue -- Good
        else if circularSlider.angle > 180 && circularSlider.angle <= 330
        {
            circularSlider.set(colors:UIColor(red:0.39, green:0.82, blue:0.99, alpha:1.0))
            circularSlider.trackColor = UIColor(red:0.39, green:0.82, blue:0.99, alpha:0.2)
            centerFace.setImage(UIImage(named: "Face_Happy.png"), for: .normal)
        }else if circularSlider.angle > 330 && circularSlider.angle < 360
        {
            circularSlider.set(colors: UIColor(red:0.60, green:0.80, blue:0.29, alpha:1.0))
            circularSlider.trackColor = UIColor(red:0.60, green:0.80, blue:0.29, alpha:0.2)
            centerFace.setImage(UIImage(named: "Face_Smile.png"), for: .normal)
        }
        
        let currentAngle = circularSlider.angle
        return currentAngle + 10
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
