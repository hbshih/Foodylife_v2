//
//  TestCoreDataViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 13/01/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit
import CoreData

class TestCoreDataViewController: UIViewController {

    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var submitUsername: UIButton!
    @IBOutlet weak var welcomeMessage: UILabel!
    var user = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntries")
        
        request.returnsObjectsAsFaults = false
        
        do
        {
            let result = try context.fetch(request)
            
            if result.count > 0
            {
                for name in result as! [NSManagedObject]
                {
                    if let username = name.value(forKey: "identifier") as? String
                    {
                        user = username
                        // print(username)
                        welcomeMessage.text = "Welcome, \(username)"
                        usernameTextfield.placeholder = "Change your name here"
                    }
                }
            }else
            {
                welcomeMessage.alpha = 0
                //LogOutButton.alpha = 0
            }
            
            
        }catch
        {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitUsernameButton(_ sender: Any) {
        if user != ""
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let newValue = NSEntityDescription.insertNewObject(forEntityName: "UserEntries", into: context)
            newValue.setValue(usernameTextfield.text, forKey: "identifier")
            user = usernameTextfield.text!
            welcomeMessage.text = "Welcome, \(user)"
            welcomeMessage.alpha = 1
           // LogOutButton.alpha = 1
            do {
                try context.save()
            } catch {
                print("error")
            }
            
        }else
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let userEntry = NSEntityDescription.insertNewObject(forEntityName: "UserEntries", into: context)
            userEntry.setValue(usernameTextfield.text, forKey: "identifier")
            user = usernameTextfield.text!
            welcomeMessage.text = "Welcome, \(user)"
           // LogOutButton.alpha = 1
            welcomeMessage.alpha = 1
            do {
                try context.save()
            } catch {
                print("error")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
