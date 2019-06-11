//
//  Date_Extension.swift
//  Food Diary App!
//
//  Created by Ben Shih on 18/03/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import Foundation

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date { 
        let formatter = DateFormatter()
        formatter.dateFormat = "hh-mm-ss"
        let timeNow = formatter.string(from: Date())
        let hour = Int(timeNow.prefix(2))
        let minute = Int(timeNow.prefix(5).suffix(2))
        let second = Int(timeNow.suffix(2))
        return Calendar.current.date(bySettingHour: hour!, minute: minute!, second: second!, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
}
