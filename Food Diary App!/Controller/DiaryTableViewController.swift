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
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DiaryTableViewCell
        {
            let str = self.fileName[indexPath.row]
            
            var subString = str.prefix(7)
            let month = subString.suffix(2)
            subString = str.prefix(10)
            let day = subString.suffix(2)
            subString = str.prefix(13)
            let hour = subString.suffix(2)
            subString = str.prefix(16)
            let minute = subString.suffix(2)
            
            let date = "\(month)/\(day)"
            let time = "\(hour):\(minute)"
            
            // if images[indexPath.row] ==
            // print("Image array \(images[indexPath.row])")
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
    
}
