//
//  GraphView.swift
//  naloga 4
//
//  Created by Zan on 3/3/16.
//  Copyright © 2016 Zan. All rights reserved.
//

import UIKit

public class GraphView: UIView {

    public var barWidth: CGFloat = 10.0
    public var maxValue: CGFloat = 1.0
    
    public var barColor = UIColor.blackColor()
    
    public var values = [CGFloat]()
    
    public func refresh() {
        var separator: CGFloat = 0.0
        if values.count > 0 {
            separator = (self.frame.size.width - barWidth * CGFloat(values.count)) / CGFloat(values.count)
        }
        for var index=0; index<values.count; index++ {
            var targetView = viewForIndex(index)
            if targetView == nil {
                targetView = UIView()
                self.addSubview(targetView!)
            }
            
            guard let view = targetView else {
                continue
            }
            
            view.backgroundColor = barColor
            let x = separator*0.5 + (barWidth + separator)*CGFloat(index)
            let height = values[index]/maxValue * self.frame.height
            view.frame = CGRect(x: x, y: self.frame.height-height, width: barWidth, height: height)
        }
    }
    
    public func viewForIndex(idnex: Int) -> UIView? {
        // TODO: from array
        return nil
    }
}
