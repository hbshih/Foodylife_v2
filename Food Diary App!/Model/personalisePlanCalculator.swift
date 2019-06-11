//
//  personalisePlanCalculator.swift
//  Food Diary App!
//
//  Created by Ben Shih on 19/03/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import Foundation

struct personalisePlanCalculator
{
    var calorie: Double?
    var plan: [Double] = []
    init(calorie: Double)
    {
        self.calorie = calorie
        customisePlanCalculator()
    }
    
    private mutating func customisePlanCalculator()
    {
        var personPlan = [0.0,0.0,0.0,0.0,0.0] // Grain,Vegetable,Protein,Fruit,Dairy
        let locale = NSLocale.current.identifier
        if (locale == "zh-Hans" || locale == "zh-Hant")
        {
            if calorie! < 1350
            {
                personPlan = [1.5,3.0,3.0,2.0,1.5]
            }else if calorie! >= 1350 && calorie! < 1650
            {
                personPlan = [2.5,3.0,4.0,2.0,1.5]
            }else if calorie! >= 1650 && calorie! < 1900
            {
                personPlan = [3.0,3.0,5.0,2.0,1.5]
            }else if calorie! >= 1900 && calorie! < 2100
            {
                personPlan = [3.0,4.0,6.0,3.0,1.5]
            }else if calorie! >= 2100 && calorie! < 2350
            {
                personPlan = [3.5,4.0,6.0,3.5,1.5]
            }else if calorie! >= 2350 && calorie! < 2600
            {
                personPlan = [4.0,5.0,7.0,4.0,1.5]
            }else
            {
                personPlan = [4.0,5.0,8.0,4.0,2.0]
            }
        }else
        {
            // Plan in MyPlate
            if calorie! < 1700.00
            {
                personPlan = [5.0,2.0,5.0,1.5,3.0]
            }else if calorie! >= 1700 && calorie! < 1900
            {
                personPlan = [6.0,2.5,5.0,1.5,3.0]
            }else if calorie! >= 1900 && calorie! < 2100
            {
                personPlan = [6.0,2.5,5.5,2.0,3.0]
            }else if calorie! >= 2100 && calorie! < 2300
            {
                personPlan = [7.0,3.0,6.0,2.0,3.0]
            }else if calorie! >= 2300 && calorie! < 2500
            {
                personPlan = [8.0,3.0,6.5,2.0,3.0]
            }else if calorie! >= 2500 && calorie! < 2700
            {
                personPlan = [9.0,3.5,6.5,2.0,3.0]
            }else if calorie! >= 2700 && calorie! < 2900
            {
                personPlan = [10.0,3.5,7.0,2.5,3.0]
            }else if calorie! >= 2900 && calorie! < 3100
            {
                personPlan = [10.0,4.0,7.0,2.5,3.0]
            }else
            {
                personPlan = [10.0,4.0,7.0,2.5,3.0]
            }
        }
        plan = personPlan
    }
    
    func getPlan() -> [Double]
    {
        return plan
    }
    
}
