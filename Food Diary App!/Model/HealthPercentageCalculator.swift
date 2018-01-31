//
//  HealthPercentageCalculator.swift
//  Food Diary App!
//
//  Created by Ben Shih on 30/01/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import Foundation

struct HealthPercentageCalculator
{
    // General Variables
    private var fileName: [String] = [] // Storing the names of the images to get images
    
    // Nutrition Info Variables
    private var dairyList: [Int] = []
    private var vegetableList: [Int] = []
    private var proteinList: [Int] = []
    private var fruitList: [Int] = []
    private var grainList: [Int] = []
    
    // The daily food balance standard
    private let vegetableStandard = 4.0
    private let fruitStandard = 3.0
    private let grainStandard = 6.0
    private let dairyStandard = 3.0
    private let proteinStandard = 3.0
    
    //Save the date the user record on
    private var dateSaved: [String] = []
    //The total count of each nutrition element in each day.
    private var dayCountVegetable: [Double] = []
    private var dayCountProtein: [Double] = []
    private var dayCountFruit: [Double] = []
    private var dayCountGrain: [Double] = []
    private var dayCountDairy: [Double] = []
    private var dayBalancePercentage: [Double] = []
    
    private var averageHealth: Double = 0.0
    private var averageVegetable = 0.0
    private var averageGrain = 0.0
    private var averageProtein = 0.0
    private var averageFruit = 0.0
    private var averageDairy = 0.0
    
    init(fileNames: [String], nutritionDic:[String:[Int]])
    {
        self.fileName = getTrimmedDate(Name: fileNames)
        dairyList = nutritionDic["dairyList"]!
        vegetableList = nutritionDic["vegetableList"]!
        proteinList = nutritionDic["proteinList"]!
        fruitList = nutritionDic["fruitList"]!
        grainList = nutritionDic["grainList"]!
        calculateOverallHealthRate()
    }
    
    private mutating func calculateOverallHealthRate()
    {
        
        calculateEachElementDailyTotalCount()
        convertDailyCountIntoBalancePercentage()
        getAverageOfEachElement()
    }
    
    private mutating func calculateEachElementDailyTotalCount()
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
    }
    
    private mutating func convertDailyCountIntoBalancePercentage()
    {
        for i in 0 ..< dateSaved.count
        {
            dayCountVegetable[i] = ((dayCountVegetable[i] / vegetableStandard)*100).rounded()
            dayCountDairy[i] = ((dayCountDairy[i] / dairyStandard)*100).rounded()
            dayCountProtein[i] = ((dayCountProtein[i] / proteinStandard)*100).rounded()
            dayCountFruit[i] = ((dayCountFruit[i] / fruitStandard)*100).rounded()
            dayCountGrain[i] = ((dayCountGrain[i] / grainStandard)*100).rounded()
            dayBalancePercentage.append((dayCountGrain[i] + dayCountFruit[i] + dayCountProtein[i] + dayCountDairy[i] + dayCountVegetable[i]) / 5.0)
        }
        print("###")
        print("DaycountOfVege: \(dayCountVegetable)")
        print("DaycountOfG: \(dayCountGrain)")
        print("DaycountOfP: \(dayCountProtein)")
        print("DaycountOfF: \(dayCountFruit)")
        print("DaycountOfD: \(dayCountDairy)")
        print("Average: \(dayBalancePercentage)")
    }
    
    private mutating func getAverageOfEachElement()
    {
        var sum = 0.0
        var sumv = 0.0
        var sumg = 0.0
        var sump = 0.0
        var sumf = 0.0
        var sumd = 0.0
        
        for i in 0 ..< dayBalancePercentage.count
        {
            sum += dayBalancePercentage[i]
            sumv += dayCountVegetable[i]
            sumd += dayCountDairy[i]
            sump += dayCountProtein[i]
            sumf += dayCountFruit[i]
            sumg += dayCountGrain[i]
        }
        
        averageHealth = sum / Double(dayBalancePercentage.count)
        averageVegetable = sumv / Double(dayBalancePercentage.count)
        averageDairy = sumd / Double(dayBalancePercentage.count)
        averageFruit = sumf / Double(dayBalancePercentage.count)
        averageProtein = sump / Double(dayBalancePercentage.count)
        averageGrain = sumg / Double(dayBalancePercentage.count)
    }
    
    mutating func getTrimmedDate(Name: [String]) -> [String]
    {
        var newFileName: [String] = []
        for i in 0 ..< Name.count
        {
            let str = Name[i].prefix(13)
            let date = str.suffix(10)
            newFileName.append(String(date))
        }
        return newFileName
    }
    
    mutating func getTrimmedDate() -> [String]
    {
        return dateSaved
    }
    
    mutating func getDayBalancePercentage() -> [Double]
    {
        return dayBalancePercentage
    }
    
    mutating func getAverageHealth() -> Double
    {
        return averageHealth
    }
    
    mutating func getEachNutritionHealthAverage() -> [String: Double]
    {
        return ["averageVegetable": averageVegetable, "averageGrain": averageGrain, "averageProtein": averageProtein, "averageFruit": averageFruit,"averageDairy": averageDairy]
    }
}
