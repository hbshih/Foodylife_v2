//
//  calorieDeterminer.swift
//  Food Diary App!
//
//  Created by Ben Shih on 20/03/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import Foundation

struct calorieDeterminer
{
    var sex: String
    var age: Double
    var weight: Double
    var height: Double
    var activityLevel: String
    
    // Calculation for Calorie
    func getCalculateCalorie() -> Double
    {
        let Calculation = 10 * (weight) + 6.25 * (height)
        var sexCalculation = 0.0
        if sex == "Male"
        {
            sexCalculation = Calculation - 5 * age + 5
        }else
        {
            sexCalculation = Calculation - 5 * age - 161
        }
        
        var harrisBenedictFactor = 0.0
        
        switch activityLevel {
        case "Sedentary (little or no exercise)":
            harrisBenedictFactor = 1.2
        case "Lightly active (1-3 times/week)":
            harrisBenedictFactor = 1.375
        case "Moderately active (3-5 times/week)":
            harrisBenedictFactor = 1.55
        case "Very active (6-7 times/week)":
            harrisBenedictFactor = 1.725
        case "Extra active twice/day)":
            harrisBenedictFactor = 1.9
        default:
            break
        }

        return sexCalculation * harrisBenedictFactor
        
    }
}

