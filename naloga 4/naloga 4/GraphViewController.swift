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
        graphView.minimumColor = UIColor.greenColor()
        graphView.maximumColor = UIColor.redColor()
        graphView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        Income.fetchDailyIncomes(NSDate(), toDate: NSDate().dateByAddingTimeInterval(60.0*60.0*24.0*30.0)) { (data) -> Void in
            self.graphView.values = data
        }
        graphView.refresh()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func monthSelectionViewDidSelectNewDate(sender: MonthSelectionView, date: NSDate) {
        Income.fetchDailyIncomes(date, toDate: date.dateByAddingTimeInterval(60.0*60.0*24.0*30.0)) { (data) -> Void in
            
            self.graphView.values = data
            if self.selectedDate.compare(date) == NSComparisonResult.OrderedAscending {
                self.graphView.refresh(.FromRight)
            } else if self.selectedDate.compare(date) == NSComparisonResult.OrderedDescending {
                self.graphView.refresh(.FromLeft)
            } else {
                self.graphView.refresh(.Resize)
            }
            self.selectedDate = date
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
}
