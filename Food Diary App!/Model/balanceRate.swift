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
    let vegetableStandard = 4
    let fruitStandard = 3
    let grainStandard = 6
    let dairyStandard = 3
    let proteinStandard = 3
    
    // General Variables
    var fileName: [String] = [] // Storing the names of the images to get images
    
    // Nutrition Info Variables
    var dairyList: [Int] = []
    var vegetableList: [Int] = []
    var proteinList: [Int] = []
    var fruitList: [Int] = []
    var grainList: [Int] = []
    
    
    
    mutating func getDailyNumbers()
    {
        var dateSaved: [String] = []
        var dayCountVegetable: [Double] = []
        var dayCountFruit: [Double] = []
        var dayCountDairy: [Double] = []
        var dayCountProtein: [Double] = []
        var dayCountGrain: [Double] = []
        var averageOfTheDay: [Double] = []
        var averageAllTime: Double
        
        var v = 0
        var f = 0
        var p = 0
        var g = 0
        var d = 0

        for i in 1 ..< fileName.count
        {
            if fileName[i] != fileName[i-1]
            {
                dateSaved.append(fileName[i])
                dayCountDairy.append(Double(d))
                dayCountFruit.append(Double(f))
                dayCountGrain.append(Double(g))
                dayCountProtein.append(Double(p))
                dayCountVegetable.append(Double(p))
                v = 0;f = 0;p = 0; g = 0; d = 0
            }else
            {
                v += vegetableList[i]
                f += fruitList[i]
                p += proteinList[i]
                g += grainList[i]
                d += dairyList[i]
                print("Vege loop \(v)")
            }
        }
        
        print("Date: \(dateSaved)")
        print("DaycountOfVege: \(dayCountVegetable)")
        
    }
    
    
    
}
