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
    
    // General Variables
    var images: [UIImage] = [] // Storing Images
    var fileName: [String] = [] // Storing the names of the images to get images
    var notes: [String] = [] // Storing notes
    
    // Nutrition Info Variables
    var dairyList: [Double] = []
    var vegetableList: [Double] = []
    var proteinList: [Double] = []
    var fruitList: [Double] = []
    var grainList: [Double] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Accessing Core Data
        var dataHandler = CoreDataHandler()
        fileName = dataHandler.getImageFilename()
        notes = dataHandler.getNote()
        let nutritionDic = dataHandler.get5nList()
        dairyList = nutritionDic["dairyList"]!
        vegetableList = nutritionDic["vegetableList"]!
        proteinList = nutritionDic["proteinList"]!
        fruitList = nutritionDic["fruitList"]!
        grainList = nutritionDic["grainList"]!
        
        //-- to display the most up to date items first
        fileName = fileName.reversed()
        notes = notes.reversed()
        fruitList = fruitList.reversed()
        dairyList = dairyList.reversed()
        vegetableList = vegetableList.reversed()
        proteinList = proteinList.reversed()
        grainList = grainList.reversed()
        
        //-- Accesing App File, getting images
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
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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
        // Delete Button
        if editingStyle == .delete
        {
            // Accesing Core Data
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntries")
            // Get the corresponding image that user intend to delete
            request.predicate = NSPredicate(format: "imageName = %@", "\(fileName[indexPath.row])")
            request.returnsObjectsAsFaults = false
            do
            {
                let result = try context.fetch(request)
                
                if result.count > 0
                {
                    for name in result as! [NSManagedObject]
                    {
                        // Access to coredata and delete them
                        if let Imagename = name.value(forKey: "imageName") as? String
                        {
                            print("\(Imagename) deleted complete")
                            context.delete(name)
                            do {
                                try context.save()
                            } catch  {
                                alertMessage(title: "Delete Failed", message: "An Error has occured, please try again later.")
                                print("Delete Failed")
                            }
                        }
                    }
                }
            }catch
            {
                alertMessage(title: "Error", message: "An Error has occured, please try again later.")
            }
            
            // Access to file and delete them
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
            // Delete from the table
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
            // Manipulating Data, showing correct information
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
            
            // Displaying informations
            cell.foodImage.image = images[indexPath.row]
            cell.date.text = date
            cell.time.text = time
            cell.note.text = notes[indexPath.row]
            
            // Show nutrition icons and counts
            
            if vegetableList[indexPath.row] > 0
            {
                cell.vegetableField.alpha = 1
                cell.vegetableLabel.alpha = 1
                cell.vegetableLabel.text = String(vegetableList[indexPath.row])
            }else
            {
                cell.vegetableField.alpha = 0.25
                cell.vegetableLabel.alpha = 0
            }
            
            if proteinList[indexPath.row] > 0
            {
                cell.proteinField.alpha = 1
                cell.proteinLabel.alpha = 1
                cell.proteinLabel.text = String(proteinList[indexPath.row])
            }else
            {
                cell.proteinField.alpha = 0.25
                cell.proteinLabel.alpha = 0
            }
            
            if grainList[indexPath.row] > 0
            {
                cell.grainField.alpha = 1
                cell.grainLabel.alpha = 1
                cell.grainLabel.text = String(grainList[indexPath.row])
            }else
            {
                cell.grainField.alpha = 0.25
                cell.grainLabel.alpha = 0
            }
            
            if fruitList[indexPath.row] > 0
            {
                cell.fruitField.alpha = 1
                cell.fruitLabel.alpha = 1
                cell.fruitLabel.text = String(fruitList[indexPath.row])
            }else
            {
                cell.fruitField.alpha = 0.25
                cell.fruitLabel.alpha = 0
            }
            
            if dairyList[indexPath.row] != 0
            {
                cell.dairyLabel.alpha = 1
                cell.dairyField.alpha = 1
                cell.dairyLabel.text = String(dairyList[indexPath.row])
            }else
            {
                cell.dairyLabel.alpha = 0
                cell.dairyField.alpha = 0.25
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
    
    func alertMessage(title: String, message: String)
    {
        let mes = AlertMessage()
        mes.displayAlert(title: title, message: message, VC: self)
    }
    
    
}
