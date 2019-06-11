//
//  circularSliderDeterminer.swift
//  Food Diary App!
//
//  Created by Ben Shih on 18/03/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import Foundation
import UIKit

struct circularSliderDeterminer
{
    var value: Double?
    var sliderValue: Double = 0.0
    var sliderColor: UIColor = UIColor(red:0.99, green:0.44, blue:0.39, alpha:1.0)
    var sliderTrackColor: UIColor = UIColor(red:0.99, green:0.44, blue:0.39, alpha:0.2)
    var face: UIImage?
    var count: Int?
    
    init(value:Double, count: Int)
    {
        self.value = value
        self.count = count
        setValueAndColourDeterminer()
    }
    
    mutating func getSliderValue()-> Double
    {
        return sliderValue
    }
    mutating func getSliderColour()-> UIColor
    {
        return sliderColor
    }
    mutating func getSliderTrackColour() -> UIColor
    {
        return sliderTrackColor
    }
    
    mutating func setValueAndColourDeterminer()
    {
        let value = self.value!
        if value > 0.0 && value <= 20.0
        {
            if count == 1
            {
                sliderColor = UIColor(red:248/255, green:123/255, blue:28/255, alpha:1.0)
                sliderTrackColor = UIColor(red:248/255, green:123/255, blue:28/255, alpha:0.2)
                face = #imageLiteral(resourceName: "Face_JustStarted")
            }
            else
            {
                sliderColor = UIColor(red:0.99, green:0.44, blue:0.39, alpha:1.0)
                sliderTrackColor = UIColor(red:0.99, green:0.44, blue:0.39, alpha:0.2)
                face = #imageLiteral(resourceName: "Face_Red")
            }
        }else if value > 20.0 && value <= 60.0 || value == 0
        {
            sliderColor = UIColor(red:0.99, green:0.82, blue:0.39, alpha:1.0)
            sliderTrackColor = UIColor(red:0.99, green:0.82, blue:0.39, alpha:0.2)
            face = #imageLiteral(resourceName: "Face_Yellow")
        }else if value > 60.0 && value <= 80.0
        {
            sliderColor = UIColor(red:0.59, green:0.79, blue:0.30, alpha:1.0)
            sliderTrackColor = UIColor(red:0.59, green:0.79, blue:0.30, alpha:0.2)
            face = #imageLiteral(resourceName: "Face_Green")
        }else
        {
            sliderColor = UIColor(red:0.94, green:0.60, blue:0.18, alpha:1.0)
            sliderTrackColor = UIColor(red:0.94, green:0.60, blue:0.18, alpha:0.2)
            face = #imageLiteral(resourceName: "Face_Orange")
        }
        sliderValue = value * 3.6
    }
    
    mutating func getFace() -> UIImage
    {
        return face!
    }
}
