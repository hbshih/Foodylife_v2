//
//  VegetableDashboardViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 14/01/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit
import CoreData

class VegetableDashboardViewController: UIViewController {

    // Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var centerImage: UIImageView!
    @IBOutlet weak var navDash: UINavigationItem!
    // General Variables
    var images: [UIImage] = []
    var fileName: [String] = []
    var dashboardType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Building interface
        buildDashboard()
        
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
                    let searchFor = "n_\(dashboardType!)"
                    if let vegValue = result.value(forKey: searchFor) as? Int
                    {
                        if let imageName = result.value(forKey: "ImageName") as? String
                        {
                            if vegValue != 0
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
        
        fileName = fileName.reversed()
        
        //Getting corresponding images
        let fileManager = FileMangerModel()
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
    
    func buildDashboard()
    {
        if dashboardType == "Vegetable"
        {
            navDash.title = "Vegetable Dashboard"
            centerImage.image = #imageLiteral(resourceName: "Demo_Vegetable")
        } else if dashboardType == "Grain"
        {
            navDash.title = "Grain Dashboard"
            centerImage.image = #imageLiteral(resourceName: "Demo_Grain")
        }else if dashboardType == "Protein"
        {
            navDash.title = "Protein Dashboard"
            centerImage.image = #imageLiteral(resourceName: "Demo_Protein")
        }else if dashboardType == "Fruit"
        {
            navDash.title = "Fruit Dashboard"
            centerImage.image = #imageLiteral(resourceName: "Demo_Fruit")
        }else
        {
            navDash.title = "Dairy Dashboard"
            centerImage.image = #imageLiteral(resourceName: "Demo_Dairy")
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
