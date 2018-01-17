//
//  DiaryTableViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 29/12/2017.
//  Copyright © 2017 BenShih. All rights reserved.
//

import UIKit
import CoreData

class DiaryTableViewController: UITableViewController {
    
    var images: [UIImage] = []
    var fileName: [String] = []
    var notes: [String] = []
    // var nutritionList = ["vegetable":0,"protein":0,"diary":0,"fruit":0,"grain":0]
    var nutritionList: [Int:[Int]]?
    //var revFileName: [String] = []
    var dairyList: [Int] = []
    var vegetableList: [Int] = []
    var proteinList: [Int] = []
    var fruitList: [Int] = []
    var grainList: [Int] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nutritionList?.removeAll()
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
                                            var pr = [grain_value,vegetableValue,fruitValue,dairyValue,proteinValue]
                                            print(pr)
                                            grainList.append(grain_value)
                                            vegetableList.append(vegetableValue)
                                            proteinList.append(proteinValue)
                                            dairyList.append(dairyValue)
                                            fruitList.append(fruitValue)
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
        
        //-- to display the most up to date items first
        print(grainList)
        fileName = fileName.reversed()
        notes = notes.reversed()
        fruitList = fruitList.reversed()
        dairyList = dairyList.reversed()
        vegetableList = vegetableList.reversed()
        proteinList = proteinList.reversed()
        grainList = grainList.reversed()
        
        
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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true 
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            print("I will delete")
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntries")
            request.predicate = NSPredicate(format: "imageName = %@", "\(fileName[indexPath.row])")
            request.returnsObjectsAsFaults = false
            do
            {
                let result = try context.fetch(request)
                
                if result.count > 0
                {
                    for name in result as! [NSManagedObject]
                    {
                        if let Imagename = name.value(forKey: "imageName") as? String
                        {
                            print("\(Imagename) deleted complete")
                            context.delete(name)
                            do {
                                try context.save()
                            } catch  {
                                print("Delete Failed")
                            }
                        }
                    }
                }else
                {
                }
                
                
            }catch
            {
                
            }
            
            let fileManager = FileManager.default
            let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(fileName[indexPath.row])
            if fileManager.fileExists(atPath: imagePath)
            {
                do
                {
                    try fileManager.removeItem(atPath: imagePath)
                }catch
                {
                    print("error on filemanager remove")
                }
                print("image deleted from \(imagePath)")
            }else{
                print("Panic! No Image!")
            }
            images.remove(at: indexPath.row)
            notes.remove(at: indexPath.row)
            fileName.remove(at: indexPath.row)
            
            tableView.reloadData()
            
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DiaryTableViewCell
        {
            print(indexPath.row)
            let str = self.fileName[indexPath.row]
            var subString = str.prefix(10)
            let month = subString.suffix(2)
            subString = str.prefix(13)
            let day = subString.suffix(2)
            subString = str.prefix(16)
            let hour = subString.suffix(2)
            subString = str.prefix(19)
            let minute = subString.suffix(2)
            
            let date = "\(month)/\(day)"
            let time = "\(hour):\(minute)"
            
            cell.foodImage.image = images[indexPath.row]
            cell.date.text = date
            cell.time.text = time
            
            cell.note.text = notes[indexPath.row]
            
            // Showing nutritions
            if grainList[indexPath.row] > 0
            {
                cell.grainField.alpha = 1
            }else
            {
                cell.grainField.alpha = 0.25
            }
            if vegetableList[indexPath.row] > 0
            {
                cell.vegetableField.alpha = 1
            }else
            {
                cell.vegetableField.alpha = 0.25
            }
            if proteinList[indexPath.row] > 0
            {
                cell.proteinField.alpha = 1
            }else
            {
                cell.proteinField.alpha = 0.25
            }
            if fruitList[indexPath.row] > 0
            {
                cell.fruitField.alpha = 1
            }else
            {
                cell.fruitField.alpha = 0.25
            }
            if dairyList[indexPath.row] > 0
            {
                cell.diaryField.alpha = 1
            }else
            {
                cell.diaryField.alpha = 0.25
            }
            
            // Add a ending line
            if indexPath.row == fileName.count - 1
            {
                cell.separationLine.image = UIImage(named: "Timeline_endLine.png")
            }
            
            return cell
        }else
        {
            return UITableViewCell ()
        }
    }
    
    
}
