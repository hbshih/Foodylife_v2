//
//  numberOfServes.swift
//  Food Diary App!
//
//  Created by Ben Shih on 19/02/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import Foundation

struct numberOfServes
{
    /* Return list
     grainStandard = userPlan[0]
     vegetableStandard = userPlan[1]
     proteinStandard = userPlan [2]
     fruitStandard = userPlan[3]
     dairyStandard = userPlan[4]
     */
    private let maleDefaultSet = [6.0,3.0,6.0,2.0,2.5] // Grain,Vegetable,Protein,Fruit,Dairy
    private let femaleDefauthSet = [6.0,2.5,5.0,2.0,2.5] // Grain,Vegetable,Protein,Fruit,Dairy
    private var customSet = [6.0,8.0,5.0,4.0,3.0]//Add yourself
    

    
    func getMaleSet() -> [Double]
    {
        return maleDefaultSet
    }
    
    func getFemaleSet() -> [Double]
    {
        return femaleDefauthSet
    }
    
    func getCustom() -> [Double]
    {
        return customSet
    }
    
}
