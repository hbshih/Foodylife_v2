//
//  accessNutritionData.swift
//  Food Diary App!
//
//  Created by Ben Shih on 25/01/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct accessNutritionData{
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
    
    mutating func viewDidLoad()
    {    // Accessing Core Data
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
                        let str = imageName.prefix(13)
                        let date = str.suffix(10)
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
            print ("old \(grainList)")
        }catch
        {
            print("Retrieving core data error")
        }
    }
}

