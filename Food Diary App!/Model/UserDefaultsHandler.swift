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
        return  (defaults.object(forKey: "OnboardingSuccess") as? Bool)!
    }
    
    mutating func getPlanStandard() -> AnyObject
    {
        return defaults.object(forKey: "PlanStandardArray") as AnyObject
    }
    
    func setOnboardingStatus(status: Bool)
    {
        defaults.set(status, forKey: "OnboardingSuccess")
    }
    
    func setPlanStandard(value: [Double])
    {
        defaults.set(value, forKey: "PlanStandardArray")
    }
    
    /*
    func getTutorialStatus() -> Bool
    {
        
    }
 */
    
}
