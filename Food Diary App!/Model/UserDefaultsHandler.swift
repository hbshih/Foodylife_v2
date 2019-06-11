//
//  UserDefaultsHandler.swift
//  Food Diary App!
//
//  Created by Ben Shih on 03/02/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import Foundation
import UIKit

struct UserDefaultsHandler
{
    private let defaults = UserDefaults.standard
    
    mutating func getOnboardingStatus() -> Bool
    {
        return defaults.bool(forKey: "OnboardingSuccess")
    }
    
    func getPlanStandard() -> AnyObject
    {
        /* Return list
         grainStandard = userPlan[0]
         vegetableStandard = userPlan[1]
         proteinStandard = userPlan [2]
         fruitStandard = userPlan[3]
         dairyStandard = userPlan[4]
         */
        return defaults.object(forKey: "PlanStandardArray") as AnyObject
    }
    
    func setOnboardingStatus(status: Bool)
    {
        defaults.set(status, forKey: "OnboardingSuccess")
    }
    
    func setDayDiaryTutorialStatus(status: Bool)
    {
        defaults.set(status, forKey: "DayDiaryTutorialStatus")
    }
    
    mutating func getDayDiaryTutorialStatus() -> Bool
    {
        return defaults.bool(forKey: "DayDiaryTutorialStatus")
    }
    
    func setDiaryTutorialStatus(status: Bool)
    {
        defaults.set(status, forKey: "DiaryTutorialStatus")
    }
    
    mutating func getDiaryTutorialStatus() -> Bool
    {
        return defaults.bool(forKey: "DiaryTutorialStatus")
    }
    
    func setPersonalData(value: [String:Any])
    {
        defaults.set(value, forKey: "PersonalData")
    }
    
    func getPersonalData() -> AnyObject
    {
        return defaults.object(forKey: "PersonalData") as AnyObject
    }
    
    func setTodayEachElementData(value: [Double])
    {
        defaults.set(value, forKey: "TodayEachElementData")
    }
    
    func getSavedTodayEachElementData() -> AnyObject
    {
        return defaults.object(forKey: "TodayEachElementData") as AnyObject
    }
    
    func setNotificationStatus(flag: Bool)
    {
        defaults.set(flag, forKey: "needNotification")
    }
    
    func getNotificationStatus() -> Bool
    {
        return defaults.bool(forKey: "needNotification")
    }
    
    func setMessageSeen(seen: Bool)
    {
        defaults.set(seen, forKey: "seenMessages")
    }
    
    func getMessageSeen() -> Bool
    {
        return defaults.bool(forKey: "seenMessages")
    }
    
    func setPlanStandard(value: [Double])
    {
        defaults.set(value, forKey: "PlanStandardArray")
    }
    
    func setHomepageTutorialStatus(status: Bool)
    {
        defaults.set(status, forKey: "HomepageTutorial")
    }
    
    func setHomepageSecondTutorialStatus(status: Bool)
    {
        defaults.set(status, forKey: "HomepageSecondTutorial")
    }
    
    func setAddDataTutorialStatus(status: Bool)
    {
        defaults.set(status, forKey: "AddDataTutorial")
    }
    
    func getHomepageTutorialStatus() -> Bool
    {
        return defaults.bool(forKey: "HomepageTutorial")
    }
    
    func getHomepageSecondTutorialStatus() -> Bool
    {
        return defaults.bool(forKey: "HomepageSecondTutorial")
    }
    
    func getAddDataTutorialStatus() -> Bool
    {
        return defaults.bool(forKey: "AddDataTutorial")
    }
    
    func setCameraTip(status: Bool)
    {
        defaults.set(status, forKey: "cameraTip")
    }
    
    func setAddNoteTip(status: Bool)
    {
        defaults.set(status, forKey: "noteTip")
    }
    
    func getCameraTip() -> Bool
    {
        return defaults.bool(forKey: "cameraTip")
    }
    
    func getAddNoteTip() -> Bool
    {
        return defaults.bool(forKey: "noteTip")
    }
    
    func setGiveReviewState(status: Bool)
    {
        defaults.set(status, forKey: "GiveReviewState")
    }
    
    func setHasNotified(value: [String])
    {
        defaults.set(value, forKey: "hasNotified")
    }
    
    func getHasNotified() -> AnyObject
    {
        return defaults.object(forKey: "hasNotified") as AnyObject
    }
    
    /*
     func getTutorialStatus() -> Bool
     {
     
     }
     */
    
}

