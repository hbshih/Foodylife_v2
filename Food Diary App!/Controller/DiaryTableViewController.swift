//
//  DiaryTableViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 29/12/2017.
//  Copyright © 2017 BenShih. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAnalytics
import PopupDialog
import Instructions

class DiaryTableViewController: UITableViewController {
    
    @IBOutlet var tableViewController: UITableView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    // General Variables
    private var images: [UIImage] = [] // Storing Images
    private var fileName: [String] = [] // Storing the names of the images to get images
    private var notes: [String] = [] // Storing notes
    private var dates: [Date] = [] // Storinng dates
    private var id: [String] = []
    
    // Nutrition Info Variables
    private var dairyList: [Double] = []
    private var vegetableList: [Double] = []
    private var proteinList: [Double] = []
    private var fruitList: [Double] = []
    private var grainList: [Double] = []
    
    private var recordCount = 0
    private var startShowing = -1
    
    var showRecord = "All"
    
    var dataEdited = false
    var dataDeleted = false
    
    @IBOutlet weak var noDataIndicator: UILabel!
    
    var defaults = UserDefaultsHandler()
    
    // For tutorial walkthrough
    let coachMarksController = CoachMarksController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Accessing Core Data
        var dataHandler = CoreDataHandler()
        fileName = dataHandler.getImageFilename()
        dates = dataHandler.getTimestamp()
        notes = dataHandler.getNote()
        //      hasImage = dataHandler.getHasImage()
        id = dataHandler.getId()
        let nutritionDic = dataHandler.get5nList()
        dairyList = nutritionDic["dairyList"]!
        vegetableList = nutritionDic["vegetableList"]!
        proteinList = nutritionDic["proteinList"]!
        fruitList = nutritionDic["fruitList"]!
        grainList = nutritionDic["grainList"]!
        
        if id.count > 0 && defaults.getDiaryTutorialStatus() == false
        {
            
            self.coachMarksController.dataSource = self
            self.coachMarksController.start(on: self)
            self.coachMarksController.overlay.allowTap = true
        }
        
        //-- to display the most up to date items first
        if showRecord != "All"
        {
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            print(dates)
            for i in 0 ..< dates.count
            {
                if format.string(from:dates[i]) == showRecord
                {
                    print("Similar dates \(dates[i]) == \(showRecord)")
                    print(i)
                    recordCount += 1
                    if startShowing == -1
                    {
                        startShowing = i
                        print("Start Showinng from \(startShowing)")
                    }
                }
            }
        }else
        {
            recordCount = dates.count
            startShowing = 0
        }
        
        //-- Accesing App File, getting images
        if id.count != 0
        {
            noDataIndicator.alpha = 0
            images = FileManagerModel().lookupImageDiary(fileNames: fileName)
        }else
        {
            noDataIndicator.alpha = 1
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return recordCount
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true 
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // 生成刪除按鈕
        let deleteAction: UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete".localized(), handler: {(action, indexPath) -> Void in
            // Accesing Core Data
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntries")
            // Get the corresponding record that user intend to delete
            request.predicate = NSPredicate(format: "id = %@", "\(self.id[indexPath.row + self.startShowing])")
            request.returnsObjectsAsFaults = false
            do
            {
                let result = try context.fetch(request)
                if result.count > 0
                {
                    print("Fetch Result")
                    print(result)
                    for name in result as! [NSManagedObject]
                    {
                        // Access to coredata and delete them
                        if let id = name.value(forKey: "id") as? String
                        {
                            print(id)
                            print("\(id) deleted complete")
                            context.delete(name)
                            do
                            {
                                try context.save()
                            } catch  {
                                self.alertMessage(title: "Delete Failed", message: "An Error has occured, please try again later.")
                                print("Delete Failed")
                            }
                        }
                    }
                }
            }catch
            {
                self.alertMessage(title: "Error", message: "An Error has occured, please try again later.")
            }
            
            if self.fileName[indexPath.row + self.startShowing] != ""
            {
                // Access to file and delete them
                let fileManager = FileManager.default
                let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(self.fileName[indexPath.row + self.startShowing])
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
            }
            
            // Delete from the table
            self.images.remove(at: indexPath.row + self.startShowing)
            self.notes.remove(at: indexPath.row + self.startShowing)
            self.fileName.remove(at: indexPath.row + self.startShowing)
            self.dates.remove(at: indexPath.row + self.startShowing)
            self.id.remove(at: indexPath.row + self.startShowing)
            self.dairyList.remove(at: indexPath.row + self.startShowing)
            self.vegetableList.remove(at: indexPath.row + self.startShowing)
            self.proteinList.remove(at: indexPath.row + self.startShowing)
            self.fruitList.remove(at: indexPath.row + self.startShowing)
            self.grainList.remove(at: indexPath.row + self.startShowing)
            self.recordCount -= 1
            
            self.dataDeleted = true
            
            tableView.reloadData()
            
        })
        
        deleteAction.backgroundColor = UIColor.red
        
        // 生成分享按鈕
        let shareAction: UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Edit".localized(), handler: {(action, indexPath) -> Void in

            let n_Array = [self.grainList[indexPath.row + self.startShowing],self.vegetableList[indexPath.row + self.startShowing],
                           self.proteinList[indexPath.row + self.startShowing],self.fruitList[indexPath.row + self.startShowing],
                           self.dairyList[indexPath.row + self.startShowing]]
            let note = self.notes[indexPath.row + self.startShowing]
            
            
            var image: UIImage?
            image = self.images[indexPath.row + self.startShowing]
            
            self.showeditPopup(n_Array: n_Array, note: note, image: image!,whichRecord: indexPath.row + self.startShowing)
            
        })
        
        shareAction.backgroundColor = UIColor.orange
        return [deleteAction, shareAction]
    }
    
    func showeditPopup(n_Array:[Double],note: String,image: UIImage,whichRecord: Int)
    {
        // Create a custom view controller
        let editVC = EditPopUpViewController(nibName: "EditPopUpViewController", bundle: nil)
        
        editVC.n_Values = n_Array
        editVC.notes = note
        
        if image == #imageLiteral(resourceName: "zh_NoImage") || image == #imageLiteral(resourceName: "image_None")
        {
            editVC.hasImage = false
        }else
        {
            editVC.hasImage = true
            editVC.image = image
        }
        
        // Create the dialog
        let popup = PopupDialog(viewController: editVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL".localized(), height: 60) {
            // self.label.text = "You canceled the rating dialog"
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "OK".localized(), height: 60)
        {
            if editVC.recordChanged
            {
                if editVC.hasNewImage
                {
                    self.updateRecord(newNutri: editVC.n_Values, newNote: editVC.notes,hasNewImage:editVC.hasNewImage, newImage: editVC.newImage!, whoToUpdate: whichRecord)
                }else
                {
                    self.updateRecord(newNutri: editVC.n_Values, newNote: editVC.notes,hasNewImage:editVC.hasNewImage, newImage: #imageLiteral(resourceName: "image_None"), whoToUpdate: whichRecord)
                }
                self.dataEdited = true
                print("Record has changed")
            }else
            {
                print("Nothing is changed")
            }
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        present(popup, animated: true, completion: nil)
    }
    
    func updateRecord(newNutri:[Double], newNote: String,hasNewImage: Bool, newImage: UIImage, whoToUpdate: Int)
    {
        // Accesing Core Data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntries")
        // Get the corresponding record that user intend to delete
        request.predicate = NSPredicate(format: "id = %@", "\(id[whoToUpdate])")
        request.returnsObjectsAsFaults = false
        do
        {
            let result = try context.fetch(request)
            if result.count == 1
            {
                let update = result[0] as! NSManagedObject
                
                update.setValue(newNote, forKey: "note")
                update.setValue(newNutri[0], forKey: "n_Grain")
                update.setValue(newNutri[1], forKey: "n_Vegetable")
                update.setValue(newNutri[2], forKey: "n_Protein")
                update.setValue(newNutri[3], forKey: "n_Fruit")
                update.setValue(newNutri[4], forKey: "n_Dairy")
                
                notes.insert(newNote, at: whoToUpdate)
                notes[whoToUpdate] = newNote
                grainList[whoToUpdate] = newNutri[0]
                vegetableList[whoToUpdate] = newNutri[1]
                proteinList[whoToUpdate] = newNutri[2]
                fruitList[whoToUpdate] = newNutri[3]
                dairyList[whoToUpdate] = newNutri[4]
                
                if hasNewImage
                {
                    
                    //Create name
                    let format = DateFormatter()
                    format.dateFormat = "yyyy-MM-dd-hh-mm-ss"
                    let FileName = "\(format.string(from: dates[whoToUpdate])).jpg"
                    //create an instance of the FileManager
                    let fileManager = FileManager.default
                    //get the image path
                    let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(FileName)
                    //get the JPG data for this image
                    let data = UIImageJPEGRepresentation(newImage, 0.5)
                    //store it in the document directory
                    fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
                    update.setValue(FileName, forKey: "imageName")
                    
                    images.insert(newImage, at: whoToUpdate)
                    
                    print("Image Update Completed")
                    print(imagePath)
                }
                do
                {
                    try context.save()
                    tableViewController.reloadData()
                }catch
                {
                    print(error)
                }
            }
        }catch
        {
            alertMessage(title: "Error", message: "An Error has occured, please try again later.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "dismissSegue"
        {
            if let vc = segue.destination as? DayViewDiaryViewController
            {
                vc.dataEditedFromDiary = dataEdited
                vc.dataDeletedFromDiary = dataDeleted
            }
        }
    }
    
    /*
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
     {
     // Delete Button
     if editingStyle == .delete
     {
     // Accesing Core Data
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     let context = appDelegate.persistentContainer.viewContext
     let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntries")
     // Get the corresponding record that user intend to delete
     request.predicate = NSPredicate(format: "id = %@", "\(id[indexPath.row + startShowing])")
     request.returnsObjectsAsFaults = false
     do
     {
     let result = try context.fetch(request)
     if result.count > 0
     {
     print("Fetch Result")
     print(result)
     
     for name in result as! [NSManagedObject]
     {
     // Access to coredata and delete them
     if let id = name.value(forKey: "id") as? String
     {
     print(id)
     print("\(id) deleted complete")
     context.delete(name)
     do
     {
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
     
     if fileName[indexPath.row + startShowing] != ""
     {
     // Access to file and delete them
     let fileManager = FileManager.default
     let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(fileName[indexPath.row + startShowing])
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
     }
     
     // Delete from the table
     images.remove(at: indexPath.row + startShowing)
     notes.remove(at: indexPath.row + startShowing)
     fileName.remove(at: indexPath.row + startShowing)
     dates.remove(at: indexPath.row + startShowing)
     id.remove(at: indexPath.row + startShowing)
     dairyList.remove(at: indexPath.row + startShowing)
     vegetableList.remove(at: indexPath.row + startShowing)
     proteinList.remove(at: indexPath.row + startShowing)
     fruitList.remove(at: indexPath.row + startShowing)
     grainList.remove(at: indexPath.row + startShowing)
     recordCount -= 1
     print(dates)
     print(id)
     print("Dairy \(dairyList)")
     print("Protein \(proteinList)")
     tableView.reloadData()
     }
     }*/
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DiaryTableViewCell
        {
            // Manipulating Data, showing correct information
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            var date = format.string(from: dates[indexPath.row + startShowing])
            format.dateFormat = "hh:mm"
            let time = format.string(from: dates[indexPath.row + startShowing])
            
            if date == showRecord || showRecord == "All"
            {
                format.dateFormat = "MM/dd"
                date = format.string(from: dates[indexPath.row + startShowing])
                // Displaying informations
                cell.foodImage.image = images[indexPath.row + startShowing]
                cell.date.text = date
                cell.time.text = time
              //  cell.note.text = notes[indexPath.row + startShowing]
                cell.noteView.text = notes[indexPath.row + startShowing]
                
                // Show nutrition icons and counts
                cell.vegetableLabel.text = String(vegetableList[indexPath.row + startShowing])
                cell.proteinLabel.text = String(proteinList[indexPath.row + startShowing])
                cell.grainLabel.text = String(grainList[indexPath.row + startShowing])
                cell.fruitLabel.text = String(fruitList[indexPath.row + startShowing])
                cell.dairyLabel.text = String(dairyList[indexPath.row + startShowing])
                
                if vegetableList[indexPath.row + startShowing] > 0
                {
                    cell.vegetableField.alpha = 1
                    cell.vegetableLabel.alpha = 1
                    cell.vegetableLabel.text = String(vegetableList[indexPath.row + startShowing])
                }else
                {
                    cell.vegetableField.alpha = 0.25
                    cell.vegetableLabel.alpha = 0.25
                }
                
                if proteinList[indexPath.row + startShowing] > 0
                {
                    cell.proteinField.alpha = 1
                    cell.proteinLabel.alpha = 1
                    cell.proteinLabel.text = String(proteinList[indexPath.row + startShowing])
                }else
                {
                    cell.proteinField.alpha = 0.25
                    cell.proteinLabel.alpha = 0.25
                }
                
                if grainList[indexPath.row + startShowing] > 0
                {
                    cell.grainField.alpha = 1
                    cell.grainLabel.alpha = 1
                    cell.grainLabel.text = String(grainList[indexPath.row + startShowing])
                }else
                {
                    cell.grainField.alpha = 0.25
                    cell.grainLabel.alpha = 0.25
                }
                
                if fruitList[indexPath.row + startShowing] > 0
                {
                    cell.fruitField.alpha = 1
                    cell.fruitLabel.alpha = 1
                    cell.fruitLabel.text = String(fruitList[indexPath.row + startShowing])
                }else
                {
                    cell.fruitField.alpha = 0.25
                    cell.fruitLabel.alpha = 0.25
                }
                
                if dairyList[indexPath.row + startShowing] != 0
                {
                    cell.dairyLabel.alpha = 1
                    cell.dairyField.alpha = 1
                    cell.dairyLabel.text = String(dairyList[indexPath.row + startShowing])
                }else
                {
                    cell.dairyLabel.alpha = 0.25
                    cell.dairyField.alpha = 0.25
                }
                
                // Add a ending line
                
                if indexPath.row == recordCount - 1
                {
                    cell.separationLine.image = UIImage(named: "Timeline_endLine.png")
                }
            }
            return cell
        }
        else
        {
            return UITableViewCell ()
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any)
    {
        performSegue(withIdentifier: "dismissSegue", sender: nil)
    }
    
    func alertMessage(title: String, message: String)
    {
        let mes = AlertMessage()
        mes.displayAlert(title: title, message: message, VC: self)
    }
    
    
}

// MARK: - Protocol Conformance | CoachMarksControllerDataSource
extension DiaryTableViewController: CoachMarksControllerDataSource
{
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?)
    {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        
        switch(index)
        {
        case 0:
            coachViews.bodyView.hintLabel.text = "Swipe Left! 👈👈👈".localized()
            coachViews.bodyView.nextLabel.text = "Done".localized()
            UserDefaultsHandler().setDiaryTutorialStatus(status: true)
        default: break
        }
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark
    {
        
        let cell_Frame = tableViewController.rectForRow(at: IndexPath(row: 0, section: 0))
        let view_View = UIView(frame: cell_Frame)
        view_View.frame = CGRect(x: 0.0, y: (self.navigationController?.navigationBar.frame.size.height)! + 25, width: view_View.frame.width, height: view_View.frame.height)
        switch(index)
        {
        case 0:
            return coachMarksController.helper.makeCoachMark(for: view_View)
        default:
            return coachMarksController.helper.makeCoachMark()
        }
        
    }
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int
    {
        return 1
    }
}


