//
//  GraphViewController.swift
//  naloga 4
//
//  Created by Zan on 2/26/16.
//  Copyright © 2016 Zan. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, MonthSelectionViewDelegate {

    @IBOutlet weak var dateSelectionView: MonthSelectionView!
    
    @IBOutlet weak var graphView: GraphView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateSelectionView.setDate(NSDate())
        dateSelectionView.delegate = self
        graphView.maxValue = 100.0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        Income.fetchDailyIncomes(NSDate(), toDate: NSDate().dateByAddingTimeInterval(60.0*60.0*24.0*30.0)) { (data) -> Void in
            var values = [CGFloat]()
            data.forEach({ (item) -> () in
                values.append(item.value)
            })
            self.graphView.values = values
        }
        
        graphView.refresh()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func monthSelectionViewDidSelectNewDate(sender: MonthSelectionView, date: NSDate) {
        Income.fetchDailyIncomes(date, toDate: date.dateByAddingTimeInterval(60.0*60.0*24.0*30.0)) { (data) -> Void in
            var values = [CGFloat]()
            data.forEach({ (item) -> () in
                values.append(item.value)
            })
            self.graphView.values = values
            self.graphView.refresh()
        }
    }
}
