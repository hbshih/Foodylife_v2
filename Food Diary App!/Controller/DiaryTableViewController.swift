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
        
        fileName = fileName.reversed()
        notes = notes.reversed()
        
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
    
    override func viewDidAppear(_ animated: Bool)
    {
        tableView.reloadData()
    }
    
}
