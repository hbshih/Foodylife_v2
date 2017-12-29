//
//  DiaryTableViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 29/12/2017.
//  Copyright © 2017 BenShih. All rights reserved.
//

import UIKit

class DiaryTableViewController: UITableViewController {

    var images: [UIImage] = []
    var fileName: [String] = []
    //var revFileName: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        let myarray = defaults.object(forKey: "imageFileName") as? [String] ?? [String]()
        
        if myarray.count != 0
        {
            let fileManager = FileManager.default
            var counter = 0
            for imageName in myarray
            {
                fileName.append(imageName)
                print(imageName)
                let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
                if fileManager.fileExists(atPath: imagePath){
                    if let outputImage = UIImage(contentsOfFile: imagePath)
                    {
                        images.append(outputImage)
                        //
                        counter += 1
                    }
                }else{
                    print("Panic! No Image!")
                }
            }
        }
        
     //   revFileName = Array(fileName.reversed())
        
        
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
            print(month)
            subString = str.prefix(10)
            let day = subString.suffix(2)
            subString = str.prefix(13)
            let hour = subString.suffix(2)
            subString = str.prefix(16)
            let minute = subString.suffix(2)
            
            let date = "\(month)/\(day)"
            let time = "\(hour):\(minute)"
            
            cell.foodImage.image = images[indexPath.row]
            cell.date.text = date
            cell.time.text = time
            
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
