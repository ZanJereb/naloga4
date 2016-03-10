//
//  DateTools.swift
//  naloga 4
//
//  Created by Zan on 2/26/16.
//  Copyright © 2016 Zan. All rights reserved.
//

import UIKit

class DateTools: NSObject {

    class func addMonthsToDate(date: NSDate, count: Int) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.month = count
        
        if let newDate = calendar.dateByAddingComponents(components, toDate: date, options: .MatchFirst) {
            return newDate
        } else {
            return date
        }
    }
    
    class func addDaysToDate(date: NSDate, count: Int) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.day = count
        
        if let newDate = calendar.dateByAddingComponents(components, toDate: date, options: .MatchFirst) {
            return newDate
        } else {
            return date
        }
    }
    
    class func beginningOfDay(date: NSDate) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        return calendar.startOfDayForDate(date)
        
    }
    class func beginningOfMonth(date: NSDate) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month], fromDate: date)
        if let toReturn = calendar.dateFromComponents(components) {
            return toReturn
        } else {
            return date
        }
    }
}
