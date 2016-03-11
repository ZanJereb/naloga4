//
//  GraphView.swift
//  naloga 4
//
//  Created by Zan on 3/3/16.
//  Copyright © 2016 Zan. All rights reserved.
//

import UIKit

@objc public protocol GraphViewDelegate: class {
    func valuesForObj(sender: GraphView, value: AnyObject) -> CGFloat
    
    optional func graphShouldRefreshLabel(label: UILabel, value: AnyObject)
}

public class GraphView: UIView {
    
    
    public var barWidth: CGFloat = 0.0
    public var maxValue: CGFloat = 0.0
    public weak var delegate: GraphViewDelegate?
    
    public enum graphAnimationType{
        case None
        case Resize
        case FromLeft
        case FromRight
    }
    
    private class BarView: UIView {
        var _label: UILabel?
        var label:UILabel {
            set {
                _label = newValue
            }
            get {
                if let label = _label{
                    return label
                } else {
                    let newLabel = UILabel(frame: CGRect())
                    addSubview(newLabel)
                    _label = newLabel
                    newLabel.textAlignment = .Center
                    
                    return newLabel
                }
            
            }
        }
        
        override var frame:CGRect {
            didSet {
                self.label.center = CGPoint(x: self.frame.size.width*0.5, y: self.frame.size.height + self.label.frame.size.height*0.5)
            }
        }
    }
    
    public var barColor = UIColor.blackColor() {
        didSet {
            minimumColor = barColor
            maximumColor = barColor
        }
    }
    public var minimumColor = UIColor.blackColor()
    public var maximumColor = UIColor.blackColor()
    
    private var viewContainer = [BarView]()
    
    public var values = [AnyObject]()
    
    public func refresh(animationType: graphAnimationType = .None) {

        switch animationType{
        
        case .FromRight:
            refreshFromRight()
            break
            
        case .FromLeft:
            refreshFromLeft()
            break
            
        case .None:
            refreshByResizing()
            break
            
        case .Resize:
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.refreshByResizing()
            })
            break
        }
        
    }
    
    private func getBarWidth() -> CGFloat {
        if barWidth > 0.0 {
            return barWidth
        } else if values.count > 0 {
            return self.frame.size.width / CGFloat(values.count)
        } else {
            return 1.0 // not that it matters
        }
    }
    
    private func getMaxValue() -> CGFloat {
        if maxValue > 0.0 {
            return maxValue
        } else if values.count > 0{
            var maxValue: CGFloat = 0.0
            self.values.forEach({ (rawItem) -> () in
                if let item = self.delegate?.valuesForObj(self, value: rawItem) where item > maxValue {
                    maxValue = item
                }
            })
            if maxValue <= 0.0 {
                maxValue = 1.0
            }
            return maxValue
        } else {
            return 1.0 // not that it matters
        }
    }
    
    private func refreshByResizing() {
        var separator: CGFloat = 1.0
        let barWidth = getBarWidth() - separator
        let maxValue = getMaxValue()

        if values.count > 0 {
            separator = 1.0
        }
        
        var oldViews = viewContainer
        var newViews = [BarView]()
        
        for var index=0; index<values.count; index++ {
            var value: CGFloat = 0.0
            if let rawValue = self.delegate?.valuesForObj(self, value: values[index]) {
                value = rawValue
            }
            var targetView:BarView? = nil
            
            let x = separator*0.5 + (barWidth + separator)*CGFloat(index)
            let height = value/maxValue * self.frame.height
            let newFrame = CGRect(x: x, y: self.frame.height-height, width: barWidth, height: height)
            
            
            if oldViews.count > 0 {
                targetView = oldViews.first
                oldViews.removeFirst()
            } else {
                UIView.setAnimationsEnabled(false)
                targetView = BarView()
                targetView?.frame = CGRect(x: x, y: self.frame.height ,width:  barWidth, height: 0)
                self.addSubview(targetView!)
                UIView.setAnimationsEnabled(true)
            }
            
            if let targetView = targetView {
                newViews.append(targetView)
                
                //targetView.backgroundColor = colorForScale(value/maxValue)
                
                
                evaluateTextLabelForBar(targetView, data: values[index])
                
                targetView.frame = newFrame
                
                let gradient: CAGradientLayer = CAGradientLayer()
                
                gradient.frame = targetView.bounds
                gradient.colors = [colorForScale(value/maxValue).CGColor, minimumColor.CGColor]
                targetView.layer.insertSublayer(gradient, atIndex: 0)
                
                
                
            }
        }
        oldViews.forEach({ $0.removeFromSuperview() })
        
        viewContainer = newViews
    }
    
    private func refreshFromRight() {
        var separator: CGFloat = 1.0
        let barWidth = getBarWidth() - separator
        let maxValue = getMaxValue()
        
        if values.count > 0 {
            separator = (self.frame.size.width - barWidth * CGFloat(values.count)) / CGFloat(values.count)
        }
        
        let oldViews = viewContainer
        var newViews = [BarView]()
        
        UIView.setAnimationsEnabled(false)
        
        for var index=0; index<values.count; index++ {
            var value: CGFloat = 0.0
            if let rawValue = self.delegate?.valuesForObj(self, value: values[index]) {
                value = rawValue
            }
            var targetView:BarView? = nil
            
            let x = separator*0.5 + (barWidth + separator)*CGFloat(index)
            let height = value/maxValue * self.frame.height
            
            
            targetView = BarView()
            
            if let targetView = targetView {
                evaluateTextLabelForBar(targetView, data: values[index])
                targetView.frame = CGRect(x: x + self.frame.size.width, y: self.frame.height-height ,width:  barWidth, height: height)
                self.addSubview(targetView)
                
                newViews.append(targetView)
                

                
                //targetView.backgroundColor = colorForScale(value/maxValue)
                
                let gradient: CAGradientLayer = CAGradientLayer()
                
                gradient.frame = targetView.bounds
                gradient.colors = [colorForScale(value/maxValue).CGColor, minimumColor.CGColor]
                targetView.layer.insertSublayer(gradient, atIndex: 0)
            }
        }
        
        self.viewContainer = newViews
        UIView.setAnimationsEnabled(true)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            oldViews.forEach { (view) -> () in
                view.center = CGPoint(x: view.center.x-self.frame.size.width, y: view.center.y)
            }
            newViews.forEach { (view) -> () in
                view.center = CGPoint(x: view.center.x-self.frame.size.width, y: view.center.y)
            }
            }) { (finished) -> Void in
                oldViews.forEach({ $0.removeFromSuperview() })
        }
    }
    
    private func refreshFromLeft() {
        var separator: CGFloat = 1.0
        let barWidth = getBarWidth() - separator
        let maxValue = getMaxValue()
        if values.count > 0 {
            separator = (self.frame.size.width - barWidth * CGFloat(values.count)) / CGFloat(values.count)
        }
        
        let oldViews = viewContainer
        var newViews = [BarView]()
        
        UIView.setAnimationsEnabled(false)
        
        for var index=0; index<values.count; index++ {
            var value: CGFloat = 0.0
            if let rawValue = self.delegate?.valuesForObj(self, value: values[index]) {
                value = rawValue
            }
            var targetView:BarView? = nil
            
            let x = separator*0.5 + (barWidth + separator)*CGFloat(index)
            let height = value/maxValue * self.frame.height
            
            targetView = BarView()
            
            
            
            if let targetView = targetView {
                newViews.append(targetView)
                evaluateTextLabelForBar(targetView, data: values[index])

                
                targetView.frame = CGRect(x: x - self.frame.size.width, y: self.frame.height-height ,width:  barWidth, height: height)
                self.addSubview(targetView)
                //targetView.backgroundColor = colorForScale(value/maxValue)
                let gradient: CAGradientLayer = CAGradientLayer()
                
                gradient.frame = targetView.bounds
                gradient.colors = [colorForScale(value/maxValue).CGColor, minimumColor.CGColor]
                targetView.layer.insertSublayer(gradient, atIndex: 0)
                
            }
        }
        
        self.viewContainer = newViews
        
        UIView.setAnimationsEnabled(true)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            oldViews.forEach { (view) -> () in
                view.center = CGPoint(x: view.center.x+self.frame.size.width, y: view.center.y)
            }
            newViews.forEach { (view) -> () in
                view.center = CGPoint(x: view.center.x+self.frame.size.width, y: view.center.y)
            }
            }) { (finished) -> Void in
                oldViews.forEach({ $0.removeFromSuperview() })
        }
    }
    
    private func evaluateTextLabelForBar(bar: BarView, data: AnyObject) {
        delegate?.graphShouldRefreshLabel?(bar.label, value: data)
    }
    
    
    private func colorForScale(var scale: CGFloat) -> UIColor {
        if scale < 0.0 {
            scale = 0.0
        } else if scale > 1.0 {
            scale = 1.0
        }
        
        var minR: CGFloat = 0.0
        var minG: CGFloat = 0.0
        var minB: CGFloat = 0.0
        var minA: CGFloat = 0.0
        minimumColor.getRed(&minR, green: &minG, blue: &minB, alpha: &minA)
        
        var maxR: CGFloat = 0.0
        var maxG: CGFloat = 0.0
        var maxB: CGFloat = 0.0
        var maxA: CGFloat = 0.0
        maximumColor.getRed(&maxR, green: &maxG, blue: &maxB, alpha: &maxA)
        
        let red = minR + (maxR-minR)*scale
        let blue = minB + (maxB-minB)*scale
        let green = minG + (maxG-minG)*scale
        let alpha = minA + (maxA-minA)*scale
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}
