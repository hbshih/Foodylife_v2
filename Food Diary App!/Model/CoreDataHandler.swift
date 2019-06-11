//
//  CoreDataHandler.swift
//  Food Diary App!
//
//  Created by Ben Shih on 30/01/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct CoreDataHandler
{
    // General Variables
    private var fileName: [String] = [] // Storing the names of the images
    private var notes: [String] = [] // Storing notes
    private var timestamp: [Date] = [] // Storing date
    //private var hasImage: [Bool] = []
    private var id: [String] = []
    
    // Nutrition Info Variables
    private var dairyList: [Double] = []
    private var vegetableList: [Double] = []
    private var proteinList: [Double] = []
    private var fruitList: [Double] = []
    private var grainList: [Double] = []
    private let request: NSFetchRequest<NSFetchRequestResult>
    private let context: NSManagedObjectContext
    
    init()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntries")
        let sort = NSSortDescriptor(key: "timestamp", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
    }
    
    func setNewRecord(time: Date, imageName:String,note:String,nutritionInfo:[Double])
    {
        let newValue = NSEntityDescription.insertNewObject(forEntityName: "UserEntries", into: context)
        // Setting values for each corresponding data
        newValue.setValue(time, forKey: "timestamp")
        if imageName != ""
        {
            newValue.setValue(imageName, forKey: "imageName")
        //    newValue.setValue(true, forKey: "hasImage")
        }else
        {
            newValue.setValue("", forKey: "imageName")
         //   newValue.setValue(false, forKey: "hasImage")
        }
        let format = DateFormatter()
        format.dateFormat = "yyyyMMddhhmmss"
        newValue.setValue("Record\(format.string(from: time))", forKey: "id")
        newValue.setValue(note, forKey: "note")
        newValue.setValue(nutritionInfo[0], forKey: "n_Grain")
        newValue.setValue(nutritionInfo[1], forKey: "n_Vegetable")
        newValue.setValue(nutritionInfo[2], forKey: "n_Protein")
        newValue.setValue(nutritionInfo[3], forKey: "n_Fruit")
        newValue.setValue(nutritionInfo[4], forKey: "n_Dairy")
        do {
            try context.save()
        } catch {
            SCLAlertMessage.init(title: "Oops!", message: "Sorry, we coundn't save your photo, please try again!").showMessage()
            print(error)
        }
    }
    
//    mutating func getHasImage() -> [Bool]
//    {
//        timestamp.removeAll()
//        do
//        {
//            let results = try context.fetch(request)
//            if results.count > 0
//            {
//                for result in results as! [NSManagedObject]
//                {
//                    // Store data in the corresponding array
//                    if let hasImage = result.value(forKey: "hasImage") as? Bool
//                    {
//                        self.hasImage.append(hasImage)
//                    }
//                }
//            }
//        }catch
//        {
//            print("Retrieving core data error")
//        }
//        return self.hasImage
//    }
    
    mutating func getTimestamp() -> [Date]
    {
        timestamp.removeAll()
        do
        {
            let results = try context.fetch(request)
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    // Store data in the corresponding array
                    if let time = result.value(forKey: "timestamp") as? Date
                    {
                        timestamp.append(time)
                    }
                }
            }
        }catch
        {
            print("Retrieving core data error")
        }
        return timestamp
    }
    
    
    mutating func getImageFilename() -> [String]
    {
        fileName.removeAll()
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
//                        if(imageName.prefix(3) == "not" || imageName.prefix(3) == "ont")
//                        {
//                            result.setValue(imageName.suffix(23), forKey: "imageName")
//                        }
                        fileName.append(imageName)
                    }
                }
            }
        }catch
        {
            print("Retrieving core data error")
        }
        return fileName
    }
    
    
    mutating func getId() -> [String]
    {
        fileName.removeAll()
        do
        {
            let results = try context.fetch(request)
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    // Store data in the corresponding array
                    if let id = result.value(forKey: "id") as? String
                    {
                        self.id.append(id)
                    }
                }
            }
        }catch
        {
            print("Retrieving core data error")
        }
        return id
    }
    
    mutating func getImageFilename(type: String) -> [String]
    {
        fileName.removeAll()
        let queryFor = type
        do
        {
            let results = try context.fetch(request)
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    if let queryElement = result.value(forKey: queryFor) as? Double
                    {
                        // Store data in the corresponding array
                        if queryElement != 0
                        {
                            if let imageName = result.value(forKey: "imageName") as? String
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
        return fileName
    }
    
    mutating func get5nList() -> [String:[Double]]
    {
        grainList.removeAll()
        vegetableList.removeAll()
        fruitList.removeAll()
        proteinList.removeAll()
        dairyList.removeAll()
        do
        {
            let results = try context.fetch(request)
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    if let imageName = result.value(forKey: "imageName") as? String
                    {
                        print(imageName)
                        // Store data in the corresponding array
                        if let grain_value = result.value(forKey: "n_Grain") as? Double
                        {
                            if let vegetableValue = result.value(forKey: "n_Vegetable") as? Double
                            {
                                if let fruitValue = result.value(forKey: "n_Fruit") as? Double
                                {
                                    if let dairyValue = result.value(forKey: "n_Dairy") as? Double
                                    {
                                        if let proteinValue = result.value(forKey: "n_Protein") as? Double
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
        return ["grainList":grainList,"vegetableList":vegetableList,"proteinList":proteinList,"dairyList":dairyList,"fruitList":fruitList]
    }
    
    mutating func getNote() -> [String]
    {
        notes.removeAll()
        do
        {
            let results = try context.fetch(request)
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    // Store data in the corresponding array
                    if let note = result.value(forKey: "note") as? String
                    {
                        notes.append(note)
                    }
                }
            }
        }catch
        {
            print("Retrieving core data error")
        }
        return notes
    }
}
