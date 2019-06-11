//
//  NotificationPageViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 10/04/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

class NotificationPageViewController: UIViewController,UNUserNotificationCenterDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func AllowTapped(_ sender: Any)
    {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        }

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (success, error) in
            
            if error != nil {
                print("Authorization Unsuccessfull")
                UserDefaultsHandler().setNotificationStatus(flag: false)
            }else {
                print("Authorization Successfull")
                Analytics.logEvent("Accept_Notification", parameters: nil)
                UserDefaultsHandler().setNotificationStatus(flag: true)
                localNotification_Scheduled.init().scheduleTomorrowNoUseNotification()
            }
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3)
        { // change 2 to desired number of seconds
            // Your code with delay
            self.performSegue(withIdentifier: "showHomeSegue", sender: nil)
        }
    }
    @IBAction func notNowTapped(_ sender: Any)
    {
        UserDefaultsHandler().setNotificationStatus(flag: false)
        performSegue(withIdentifier: "showHomeSegue", sender: nil)
    }
    
}
