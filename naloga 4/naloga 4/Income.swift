//
//  Income.swift
//  naloga 4
//
//  Created by Zan on 3/3/16.
//  Copyright © 2016 Zan. All rights reserved.
//

import UIKit

class Income: NSObject {
    
    var value: CGFloat = 0.0
    var date: NSDate = NSDate()
    
    private static var mockedData: [Income]?
    
    private class func fetchMockedData() -> [Income] {
        if let data = mockedData {
            return data
        } else {
            mockedData = [Income]()

            for var i = 0; i<10000; i++ {
                let item = Income()
                item.value = CGFloat(Int(rand())%1000)/1000.0
                let randomFloat = (Double(Int(rand())%100000)/100000.0)*2.0 - 1.0
                item.date = NSDate().dateByAddingTimeInterval(randomFloat*60.0*60.0*24.0*1000)
                mockedData?.append(item)
            }
            return mockedData!
        }
    }
    
    class func fetchDataFrom(startDate: NSDate, toDate endDate: NSDate, callback: (data: [Income]) -> Void) {
        let toReturn = fetchMockedData().filter { (income) -> Bool in
            if income.date.compare(startDate) == .OrderedAscending {
                return false
            } else if income.date.compare(endDate) != .OrderedAscending {
                return false
            } else {
                return true
            }
        }
        
        
        callback(data: toReturn)
    }
    
    class func fetchDailyIncomes(startDate: NSDate, toDate endDate: NSDate, callback: (data: [Income]) -> Void) {
        fetchDataFrom(startDate, toDate: endDate) { (data) -> Void in
            var toReturn = [Income]()
            data.forEach({ income in
                let beginningDate = DateTools.beginningOfDay(income.date)
                var target: Income? = nil
                for item in toReturn {
                    if item.date.compare(beginningDate) == .OrderedSame{
                        target = item
                        break
                    }
                }
                if target == nil {
                    let newIncome = Income()
                    newIncome.date = beginningDate
                    toReturn.append(newIncome)
                    target = newIncome
                }
                target?.value += income.value
            })
            callback(data: toReturn)
        }
    }
    
}
