//
//  CircleView.swift
//  BFH MyGrades
//
//  Created by Jonas Mosimann on 03.03.16.
//  Copyright © 2016 Percori. All rights reserved.
//

import UIKit

let π:CGFloat = CGFloat(M_PI)

@IBDesignable class CircleView: UIView {
    
    @IBInspectable var percent: CGFloat = 41.5
    @IBInspectable var outlineColor: UIColor = UIColor.blueColor()
    @IBInspectable var counterColor: UIColor = UIColor.orangeColor()
    
    
    override func drawRect(rect: CGRect) {
        // 1
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        
        // 2
        let radius: CGFloat = min(bounds.width, bounds.height) - 10
        
        // 3
        let arcWidth: CGFloat = 20
        
        // 4
        let startAngle: CGFloat = -π / 2
        
        //then calculate the arc for each single glass
        let arcLengthPer1Percent = 2 * π / CGFloat(100)
        
        //then multiply out by the actual glasses drunk
        let outlineEndAngle = arcLengthPer1Percent * percent + startAngle
        
        //2 - draw the outer arc
        let outlinePath = UIBezierPath(arcCenter: center,
            radius: radius/2 - arcWidth/2,
            startAngle: startAngle,
            endAngle: outlineEndAngle,
            clockwise: true)
        
        let progressLine = CAShapeLayer()
        progressLine.path = outlinePath.CGPath
        progressLine.strokeColor = outlineColor.CGColor
        progressLine.fillColor = UIColor.clearColor().CGColor
        progressLine.lineWidth = arcWidth
        progressLine.lineCap = kCALineCapRound
        
        self.layer.addSublayer(progressLine)
        
        let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        animateStrokeEnd.duration = 1.0
        animateStrokeEnd.fromValue = 0.0
        animateStrokeEnd.toValue = 1.0
        
        // add the animation
        progressLine.addAnimation(animateStrokeEnd, forKey: "animate stroke end animation")
    }
}