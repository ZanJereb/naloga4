//
//  GraphViewController.swift
//  naloga 4
//
//  Created by Zan on 2/26/16.
//  Copyright © 2016 Zan. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, MonthSelectionViewDelegate, GraphViewDelegate {

    @IBOutlet weak var dateSelectionView: MonthSelectionView!
    
    @IBOutlet weak var graphView: GraphView!
    
    
    var selectedDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateSelectionView.setDate(selectedDate)
        dateSelectionView.delegate = self
        graphView.minimumColor = UIColor.blueColor()
        graphView.maximumColor = UIColor.magentaColor()
        graphView.delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        Income.fetchDailyIncomes(getStartDate(), toDate: getEndDate()) { (data) -> Void in
            self.graphView.values = data
            self.graphView.refresh()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getStartDate() -> NSDate {
        return DateTools.beginningOfMonth(selectedDate)
    }
    private func getEndDate() -> NSDate {
        return DateTools.addMonthsToDate(DateTools.beginningOfMonth(selectedDate), count: 1)
    }
    
    func monthSelectionViewDidSelectNewDate(sender: MonthSelectionView, date: NSDate) {
        var animationType: GraphView.graphAnimationType = .Resize
        if self.selectedDate.compare(date) == NSComparisonResult.OrderedAscending {
            animationType = .FromRight
        } else if self.selectedDate.compare(date) == NSComparisonResult.OrderedDescending {
            animationType = .FromLeft
        }
        
        self.selectedDate = date
        
        Income.fetchDailyIncomes(getStartDate(), toDate: getEndDate()) { (data) -> Void in
            self.graphView.values = data
            self.graphView.refresh(animationType)
        }
    }

    func valuesForObj(sender: GraphView, value: AnyObject) -> CGFloat {
        if let income = value as? Income {
            return income.value
        } else if let floatValue = value as? CGFloat {
            return floatValue
        } else {
            return 0.0
        }
    }
    
    func graphShouldRefreshLabel(label: UILabel, value: AnyObject) {
        if let income = value as? Income where DateTools.dayOfWeek(income.date) == 2 {
            label.font = UIFont.boldSystemFontOfSize(12.0)
            label.frame = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0)
            label.layer.cornerRadius = 10.0
            label.backgroundColor = UIColor.redColor()
            label.textColor = UIColor.whiteColor()
            label.text = "\(DateTools.dayOfMonth(income.date))"
            label.hidden = false
            label.clipsToBounds = true
        } else {
            label.text = nil
            label.hidden = true
        }
    }

}
