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
}
