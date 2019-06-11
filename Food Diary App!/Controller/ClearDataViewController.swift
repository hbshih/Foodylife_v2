//
//  ClearDataViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 14/02/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit
import CoreData

class ClearDataViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearData(_ sender: Any)
    {
        // reference from http://swiftdeveloperblog.com/uialertcontroller-confirmation-dialog-swift/
        let dialogMessage = UIAlertController(title: "WARNING", message: "Are you sure you want to delete everything?", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "YES", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            self.deleteRecord()
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    /*Delete all data*/
    
    func deleteRecord()
    {
        // Delete everything in core data
        //reference from https://stackoverflow.com/questions/24658641/ios-delete-all-core-data-swift
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let coord = appDel.persistentContainer.persistentStoreCoordinator
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntries")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try coord.execute(deleteRequest, with: context)
        } catch let error as NSError {
            debugPrint(error)
        }
        
        // Delete everything in document directory
        //reference from https://stackoverflow.com/questions/34369616/delete-files-in-ios-directory-using-swift
        let fileManager = FileManager.default
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        let documentsPath = documentsUrl.path
        
        do {
            if let documentPath = documentsPath
            {
                let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                for fileName in fileNames {
                    if (fileName.hasSuffix(".jpg") || fileName.hasSuffix("Note"))
                    {
                        try fileManager.removeItem(atPath: "\(documentPath)/\(fileName)")
                    }
                }
            }
            
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
}
