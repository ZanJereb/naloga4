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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        graphView.values = [0.1, 0.0, 0.3, 0.6, 0.8, 1.0]
        graphView.refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func monthSelectionViewDidSelectNewDate(sender: MonthSelectionView, date: NSDate) {
        print("Date changed: \(date)")
    }
}
