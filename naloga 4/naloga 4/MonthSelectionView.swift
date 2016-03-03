//
//  MonthSelectionView.swift
//  naloga 4
//
//  Created by Zan on 2/26/16.
//  Copyright © 2016 Zan. All rights reserved.
//

import UIKit

protocol MonthSelectionViewDelegate {
    func monthSelectionViewDidSelectNewDate(sender: MonthSelectionView, date: NSDate)
}

class MonthSelectionView: UIView {

    @IBOutlet private weak var monthLabel: UILabel!
    private var selectedDate = NSDate()
    
    var delegate: MonthSelectionViewDelegate?

    private enum LabelAnimationType{
        case None
        case FromLeft
        case FromRight
    }
    
    private func refreshLabel(animationType: LabelAnimationType = .None) {
        let calendar = NSCalendar.currentCalendar()
        
        let formater = NSDateFormatter()
        formater.calendar = calendar
        
        if calendar.component(.Year, fromDate: selectedDate) == calendar.component(.Year, fromDate: NSDate()) {
            formater.dateFormat = "MMMM"
        } else {
            formater.dateFormat = "MMMM yyyy"
        }
        
        switch animationType {
        case .FromRight:
            let newLabel = UILabel(frame: monthLabel.frame)
            newLabel.text = monthLabel.text
            newLabel.textColor = monthLabel.textColor
            newLabel.font = monthLabel.font
            newLabel.textAlignment = monthLabel.textAlignment
            monthLabel.superview?.addSubview(newLabel)
            monthLabel.frame = CGRect(x: monthLabel.frame.origin.x+monthLabel.frame.size.width, y: monthLabel.frame.origin.y, width: monthLabel.frame.size.width, height: monthLabel.frame.size.height)
            monthLabel.text = formater.stringFromDate(selectedDate)
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                newLabel.frame = CGRect(x: newLabel.frame.origin.x-newLabel.frame.size.width, y: newLabel.frame.origin.y, width: newLabel.frame.size.width, height: newLabel.frame.size.height)
                self.layoutIfNeeded()
                }, completion: { (didFinish) -> Void in
                    newLabel.removeFromSuperview()
            })
            break
        case .FromLeft:
            let newLabel = UILabel(frame: monthLabel.frame)
            newLabel.text = monthLabel.text
            newLabel.textColor = monthLabel.textColor
            newLabel.font = monthLabel.font
            newLabel.textAlignment = monthLabel.textAlignment
            monthLabel.superview?.addSubview(newLabel)
            monthLabel.frame = CGRect(x: monthLabel.frame.origin.x-monthLabel.frame.size.width, y: monthLabel.frame.origin.y, width: monthLabel.frame.size.width, height: monthLabel.frame.size.height)
            monthLabel.text = formater.stringFromDate(selectedDate)
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                newLabel.frame = CGRect(x: newLabel.frame.origin.x+newLabel.frame.size.width, y: newLabel.frame.origin.y, width: newLabel.frame.size.width, height: newLabel.frame.size.height)
                self.layoutIfNeeded()
                }, completion: { (didFinish) -> Void in
                    newLabel.removeFromSuperview()
            })
            break
        case .None:
            monthLabel.text = formater.stringFromDate(selectedDate)
            break
        }
        
    }
    
    @IBAction private func leftButtonPressed(sender: AnyObject) {
        selectedDate = DateTools.addMonthsToDate(selectedDate, count: -1)
        refreshLabel(.FromLeft)
        delegate?.monthSelectionViewDidSelectNewDate(self, date: selectedDate)
    }
    
    @IBAction private func rightButtonPressed(sender: AnyObject) {
        selectedDate = DateTools.addMonthsToDate(selectedDate, count: 1)
        refreshLabel(.FromRight)
        delegate?.monthSelectionViewDidSelectNewDate(self, date: selectedDate)
    }

    func setDate(date: NSDate) {
        selectedDate = date
        refreshLabel()
    }
    
}
