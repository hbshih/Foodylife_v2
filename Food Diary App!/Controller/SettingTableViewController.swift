//
//  TableViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 02/02/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit
import UserNotifications

class SettingTableViewController: UITableViewController
{
    @IBOutlet weak var notificationSwitch: UISwitch!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("Notification Status \(UserDefaultsHandler().getNotificationStatus())")
        if UserDefaultsHandler().getNotificationStatus()
        {
            notificationSwitch.setOn(true, animated: false)
        }else
        {
           notificationSwitch.setOn(false, animated: false)
        //    notificationSwitch.isOn = false
        }
    }
    @IBAction func smartNotificationSwitch(_ sender: Any)
    {
        if (notificationSwitch.isOn)
        {
            SCLAlertMessage(title: "Love you 💕", message: "I will remind you when you should improve your balance diet").showMessage()
            UserDefaultsHandler().setNotificationStatus(flag: true)
        }
        else
        {
            SCLAlertMessage(title: "Awwwww", message: "I will not bother you when you are eating imbalance, but don't forget to keep recording your food diary with me").showMessage()
            UserDefaultsHandler().setNotificationStatus(flag: false)
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (req) in
                print(req)
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Showing all settings options
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print(indexPath.row)
        if indexPath.row == 1
        {
            performSegue(withIdentifier: "nutritionSettings", sender: nil)
        }else if indexPath.row == 2
        {
            performSegue(withIdentifier: "dataSettingsSegue", sender: nil)
        }else if indexPath.row == 3
        {
            performSegue(withIdentifier: "conditionSegue", sender: nil)
        }else if indexPath.row == 4
        {
            performSegue(withIdentifier: "privacySegue", sender: nil)
        }else if indexPath.row == 5
        {
            performSegue(withIdentifier: "reportABugSegue", sender: nil)
        }else if indexPath.row == 6
        {
            performSegue(withIdentifier: "licenseSegue", sender: nil)
        }else
        {
            //Do nothing
            
        }
    }
    
}
