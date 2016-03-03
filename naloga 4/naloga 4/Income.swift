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
            // TODO: fill with random data
            let item = Income()
            item.value = CGFloat(Int(rand())%1000)/1000.0
            let randomFloat = (Double(Int(rand())%100000)/100000.0)*2.0 - 1.0
            item.date = NSDate().dateByAddingTimeInterval(randomFloat*60.0*60.0*24.0*1000)
            mockedData?.append(item)
            return mockedData!
        }
    }
    
    func fetchDataFrom(startDate: NSDate, toDate endDate: NSDate, callback: (data: [Income]) -> Void) {
        var toReturn = [Income]()
        
        
        callback(data: toReturn)
    }
    
//    func groupDataByDate(){
//    }
    
}
