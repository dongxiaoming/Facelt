//
//  FaceView.swift
//  Facelt
//
//  Created by dongluis on 2017/01/06.
//  Copyright © 2017 dongluis. All rights reserved.
//

import UIKit

class FaceView: UIView {
    
    override func draw(_ rect: CGRect)
    {
        let width = bounds.size.width
        let height = bounds.size.height
        let skullRadius = min(width-5, height-5) / 2
        let skullCenter = CGPoint(x: bounds.midX, y:bounds.midY)
        
        let skull = UIBezierPath(arcCenter: skullCenter, radius: skullRadius, startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise: false)
        skull.lineWidth = 3.0
        UIColor.blue.set()
        skull.stroke()
    }
    
}
