//
//  localNotification.swift
//  Food Diary App!
//
//  Created by Ben Shih on 03/04/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import Foundation
import UserNotifications
import AudioToolbox

struct localNotification
{
    let title: String
    let message: String
    
    func push()
    {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        //AudioServicesPlaySystemSound(4095)
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        let request = UNNotificationRequest(identifier: "customNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("Push failed")
            }else {
                print("Push completed")
            }
        }
    }    
}
