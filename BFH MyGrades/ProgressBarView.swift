//
//  ProgressBarView.swift
//  BFH MyGrades
//
//  Created by Jonas Mosimann on 03.03.16.
//  Copyright © 2016 Percori. All rights reserved.
//

import UIKit

@IBDesignable class ProgressBarView: UIView {
    
    @IBInspectable var outlineColor: UIColor = UIColor.blueColor()
    var percent : CGFloat = 0

    override func drawRect(rect: CGRect) {
        let widthOfPath = (bounds.width - 40) / 100 * percent
        let outlinePath = UIBezierPath()
        outlinePath.moveToPoint(CGPoint(x: bounds.minX + 20, y: bounds.minY + bounds.height/2))
        outlinePath.addLineToPoint(CGPoint(x: widthOfPath, y: bounds.minY + bounds.height/2))

        let progressLine = CAShapeLayer()
        progressLine.path = outlinePath.CGPath
        progressLine.strokeColor = outlineColor.CGColor
        progressLine.fillColor = UIColor.clearColor().CGColor
        progressLine.lineWidth = 20
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
