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
    
    private var viewContainer = [UIView]()
    
    public var values = [CGFloat]()
    
    public func refresh() {
        var separator: CGFloat = 0.0
        if values.count > 0 {
            separator = (self.frame.size.width - barWidth * CGFloat(values.count)) / CGFloat(values.count)
        }
        
        var oldViews = viewContainer
        var newViews = [UIView]()
        
        for var index=0; index<values.count; index++ {
            var targetView:UIView? = nil
            
            let x = separator*0.5 + (barWidth + separator)*CGFloat(index)
            let height = values[index]/maxValue * self.frame.height
            let newFrame = CGRect(x: x, y: self.frame.height-height, width: barWidth, height: height)
            
            if oldViews.count > 0 {
                targetView = oldViews.first
                oldViews.removeFirst()
            } else {
                UIView.setAnimationsEnabled(false)
                targetView = UIView()
                targetView?.frame = CGRect(x: x, y: self.frame.height ,width:  barWidth, height: height)
                self.addSubview(targetView!)
                UIView.setAnimationsEnabled(true)
            }
            
            if let targetView = targetView {
                newViews.append(targetView)
                
                targetView.backgroundColor = barColor
                targetView.frame = newFrame
            }
        }
        oldViews.forEach({ $0.removeFromSuperview() })
        viewContainer = newViews
        
    }
    
    
    public func viewForIndex(idnex: Int) -> UIView? {
        // TODO: from array
        return nil
    }
}
