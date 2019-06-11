//
//  localNotification_Scheduled.swift
//  Food Diary App!
//
//  Created by Ben Shih on 04/04/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import Foundation
import UserNotifications
import AudioToolbox

struct localNotification_Scheduled
{
    func scheduleTomorrowNoUseNotification()
    {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.body = "No eating today, update now?".localized()
        AudioServicesPlaySystemSound(4095)
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: Date())
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day! + 1, hour: 19, minute: 00)
        
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: true)
        let notificationRequest = UNNotificationRequest(identifier: "\(NSDate().timeIntervalSince1970)", content: notificationContent, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error
            {
                let errorString = String(format: NSLocalizedString("Unable to Add Notification Request %@, %@", comment: ""), error as CVarArg, error.localizedDescription)
                print(errorString)
            }else
            {
                print("Notification Added succesful!")
            }
        }
    }
    
    func scheduleTomorrowHelpBalanceNotification(MinConsume: String)
    {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.body = String.localizedStringWithFormat(NSLocalizedString("I would like to advise you to eat more %@ today to make your diet balance".localized(), comment: ""),"\(MinConsume)")
        AudioServicesPlaySystemSound(4095)
        
        
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: Date())
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day! + 1, hour: 11, minute: 30)
        
        print("Notification Date \(newComponents)")
        
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: true)
        let notificationRequest = UNNotificationRequest(identifier: "lackConsumeNoti", content: notificationContent, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error
            {
                let errorString = String(format: NSLocalizedString("Unable to Add Notification Request %@, %@", comment: ""), error as CVarArg, error.localizedDescription)
                print(errorString)
            }else
            {
                print("Notification Added succesful!")
            }
        }
    }
}
