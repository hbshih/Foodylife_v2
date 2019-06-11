//
//  balanceRate.swift
//  Food Diary App!
//
//  Created by Ben Shih on 23/01/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct balanceRate
{
    
    // General Variables
    var fileName: [String] = [] // Storing the names of the images to get images
    
    // Nutrition Info Variables
    var dairyList: [Int] = []
    var vegetableList: [Int] = []
    var proteinList: [Int] = []
    var fruitList: [Int] = []
    var grainList: [Int] = []
    
    var dateSaved: [String] = []
    var dayCountVegetable: [Double] = []
    var dayCountProtein: [Double] = []
    var dayCountFruit: [Double] = []
    var dayCountGrain: [Double] = []
    var dayCountDairy: [Double] = []
    var AverageCount: [Double] = []
    var averageHealth: Double = 0.0
    
    var averageVegetable = 0.0
    var averageGrain = 0.0
    var averageProtein = 0.0
    var averageFruit = 0.0
    var averageDairy = 0.0
    
    mutating func setPercentage()
    {
        var v = 0
        var d = 0
        var g = 0
        var p = 0
        var f = 0
        
        for i in 0 ..< fileName.count - 1
        {
            if fileName[i] == fileName[i + 1]
            {
                v += vegetableList [i]
                p += proteinList [i]
                d += dairyList [i]
                f += fruitList [i]
                g += grainList [i]
                if i + 1 == fileName.count - 1
                {
                    v += vegetableList[i+1]
                    p += proteinList [i+1]
                    d += dairyList [i+1]
                    f += fruitList [i+1]
                    g += grainList [i+1]
                    dateSaved.append(fileName[i])
                    dayCountVegetable.append(Double(v))
                    dayCountGrain.append(Double(g))
                    dayCountFruit.append(Double(f))
                    dayCountProtein.append(Double(p))
                    dayCountDairy.append(Double(d))
                }
            }else
            {
                v += vegetableList [i]
                p += proteinList [i]
                d += dairyList [i]
                f += fruitList [i]
                g += grainList [i]
                dateSaved.append(fileName[i])
                dayCountVegetable.append(Double(v))
                dayCountGrain.append(Double(g))
                dayCountFruit.append(Double(f))
                dayCountProtein.append(Double(p))
                dayCountDairy.append(Double(d))
                v = 0
                d = 0
                p = 0
                f = 0
                g = 0
                if i + 1 == fileName.count - 1
                {
                    v += vegetableList[i+1]
                    p += proteinList [i+1]
                    d += dairyList [i+1]
                    f += fruitList [i+1]
                    g += grainList [i+1]
                    dateSaved.append(fileName[i + 1])
                    dayCountVegetable.append(Double(v))
                    dayCountGrain.append(Double(g))
                    dayCountFruit.append(Double(f))
                    dayCountProtein.append(Double(p))
                    dayCountDairy.append(Double(d))
                }
            }
        }
        print("Date: \(dateSaved)")
        print("DaycountOfVege: \(dayCountVegetable)")
        print("DaycountOfVege: \(dayCountGrain)")
        print("DaycountOfVege: \(dayCountProtein)")
        print("DaycountOfVege: \(dayCountFruit)")
        print("DaycountOfVege: \(dayCountDairy)")
        
        let vegetableStandard = 4.0
        let fruitStandard = 3.0
        let grainStandard = 6.0
        let dairyStandard = 3.0
        let proteinStandard = 3.0
        
        for i in 0 ..< dateSaved.count
        {
            dayCountVegetable[i] = ((dayCountVegetable[i] / vegetableStandard)*100).rounded()
            dayCountDairy[i] = ((dayCountDairy[i] / dairyStandard)*100).rounded()
            dayCountProtein[i] = ((dayCountProtein[i] / proteinStandard)*100).rounded()
            dayCountFruit[i] = ((dayCountFruit[i] / fruitStandard)*100).rounded()
            dayCountGrain[i] = ((dayCountGrain[i] / grainStandard)*100).rounded()
            AverageCount.append((dayCountGrain[i] + dayCountFruit[i] + dayCountProtein[i] + dayCountDairy[i] + dayCountVegetable[i]) / 5.0)
        }
        
        print("###")
        print("DaycountOfVege: \(dayCountVegetable)")
        print("DaycountOfG: \(dayCountGrain)")
        print("DaycountOfP: \(dayCountProtein)")
        print("DaycountOfF: \(dayCountFruit)")
        print("DaycountOfD: \(dayCountDairy)")
        print("Average: \(AverageCount)")
        
        var sum = 0.0
        var sumv = 0.0
        var sumg = 0.0
        var sump = 0.0
        var sumf = 0.0
        var sumd = 0.0
        
        for i in 0 ..< AverageCount.count
        {
            sum += AverageCount[i]
            sumv += dayCountVegetable[i]
            sumd += dayCountDairy[i]
            sump += dayCountProtein[i]
            sumf += dayCountFruit[i]
            sumg += dayCountGrain[i]
        }
        
        averageHealth = sum / Double(AverageCount.count)
        averageVegetable = sumv / Double(AverageCount.count)
        averageDairy = sumd / Double(AverageCount.count)
        averageFruit = sumf / Double(AverageCount.count)
        averageProtein = sump / Double(AverageCount.count)
        averageGrain = sumg / Double(AverageCount.count)
        
        
        
    }
    
    func getPercentage()
    {
        
        
        
    }
    
}
