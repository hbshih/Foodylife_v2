//
//  AppDelegate.swift
//  Food Diary App!
//
//  Created by Ben Shih on 12/12/2017.
//  Copyright © 2017 BenShih. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import Fabric
import IQKeyboardManagerSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self as? MessagingDelegate
        
        //Firebafses
        FirebaseApp.configure()
        //        if #available(iOS 8.0, *)
        //        {
        //            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert,.sound], categories: nil)
        //            application.registerUserNotificationSettings(settings)
        //            application.registerForRemoteNotifications()
        //        }else
        //        {
        //            let types: UIRemoteNotificationType = [.alert,.sound]
        //            application.registerForRemoteNotifications(matching: types)
        //        }
        
        //        if #available(iOS 10.0, *) {
        //            // For iOS 10 display notification (sent via APNS)
        //            UNUserNotificationCenter.current().delegate = self
        //
        //            let authOptions: UNAuthorizationOptions = [.alert, .sound]
        //            UNUserNotificationCenter.current().requestAuthorization(
        //                options: authOptions,
        //                completionHandler: {_, _ in })
        //        } else {
        //            let settings: UIUserNotificationSettings =
        //                UIUserNotificationSettings(types: [.alert, .sound], categories: nil)
        //            application.registerUserNotificationSettings(settings)
        //        }
        
        application.registerForRemoteNotifications()
        
        //        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (success, error) in
        //
        //            if error != nil {
        //                print("Authorization Unsuccessfull")
        //            }else {
        //                print("Authorization Successfull")
        //            }
        //        }
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized
            {
                print("Notification Not Authorized")
                // Notifications not allowed
            }else
            {
                print("Notification Authorized")
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification(notification:)), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        
        Fabric.sharedSDK().debug = true
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true
        
        //--facebook
        //FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // get the time the app last launched
        let lastLaunch = UserDefaults.standard.double(forKey: "lastLaunch")
        let lastLaunchDate = Date(timeIntervalSince1970: lastLaunch)
        // check to see if lastLaunchDate is today.
        let lastLaunchIsToday = Calendar.current.isDateInToday(lastLaunchDate)
        
        print("Home Loaded")
        
        if UserDefaultsHandler().getNotificationStatus()
        {
            if !lastLaunchIsToday
            {
                print("First launch Today")
                // show a popup or whatever
                
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                localNotification_Scheduled.init().scheduleTomorrowNoUseNotification()
                
            }else
            {
                print("Launched Today")
                
//                UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (request) in
//                    print(request)
//                })
            }
        }
        // update the last launch value
        UserDefaults().set(Date().timeIntervalSince1970, forKey: "lastLaunch")
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Device Tokenn \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
    }
    
    @objc func tokenRefreshNotification(notification: NSNotification)
    {
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        connectToFCM()
    }
    func connectToFCM()
    {
        // Won't connect since there is no token
        guard InstanceID.instanceID().token() != nil else {
            return;
        }
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        print("Go Background")
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == "lackConsumeNoti" {
                    identifiers.append(notification.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
            
            DispatchQueue.main.asyncAfter(deadline:.now(), execute:
            {
                    self.lackConsumeNotification()
                    UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (request) in
                        print(request)
                    })
            })
        }
    }
    
    func lackConsumeNotification()
    {
        if UserDefaultsHandler().getNotificationStatus()
        {
            var coreDataHandler = CoreDataHandler()
            if coreDataHandler.getId().count > 5
            {
                var healthCalculator = HealthPercentageCalculator(nutritionDic: coreDataHandler.get5nList(), timestamp: coreDataHandler.getTimestamp())
                let _ = healthCalculator.getLastSevenDaysEachElementPercentage()
                let minConsumeElement = healthCalculator.getMinConsumeElement() as String
                if minConsumeElement != ""
                {
                    print("Has less")
                    // Have element that percentage is less than 20%
                    // Schedule remind notification tmr noon
                    localNotification_Scheduled.init().scheduleTomorrowHelpBalanceNotification(MinConsume: minConsumeElement)
                }
                
            }
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //  FBSDKAppEvents.activateApp()
        connectToFCM()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Food Diary App!")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}


