//
//  FaceView.swift
//  Facelt
//
//  Created by dongluis on 2017/01/06.
//  Copyright © 2017 dongluis. All rights reserved.
//

import UIKit

class FaceView: UIView {
    
    private var scale: CGFloat = 0.90

    private var smile:CGFloat = 0
    
    private var skullRadius:CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    private var skullCenter:CGPoint {
        return CGPoint(x: bounds.midX, y:bounds.midY)
    }
    
    private struct Ratios {
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffset: CGFloat = 3
    }
    
    private enum Eye {
        case Left
        case Right
    }
    
    private func pathForCircleCenteredAPoint(midPoint:CGPoint, withRadius radius:CGFloat) -> UIBezierPath
    {
        let path =  UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2*M_PI),
            clockwise: false)
        path.lineWidth = 3.0
        return path
    }
    
    private func getEyeCenter(eye:Eye) -> CGPoint
    {
        let eyeOfset = skullRadius/Ratios.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOfset
        switch eye {
        case .Left:
            eyeCenter.x -= eyeOfset
        case .Right:
            eyeCenter.x += eyeOfset
        }
        return eyeCenter
    }
    
    private func pathForEye(eye:Eye) -> UIBezierPath
    {
        let eyeRadius = skullRadius/Ratios.SkullRadiusToEyeRadius
        let eyeCenter = getEyeCenter(eye: eye)
        
        return pathForCircleCenteredAPoint(midPoint: eyeCenter, withRadius: eyeRadius)
    }
    
    private func pathForMouth() -> UIBezierPath
    {
        let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
    
        let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
        let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset
        let mouthX = skullCenter.x - mouthWidth/2
        let mouthY = skullCenter.y + mouthOffset
        
        let mouthRect = CGRect.init(x: mouthX, y: mouthY, width: mouthWidth, height: mouthHeight)
        
        let startPoint = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        
        let offsetHeight = mouthRect.height * smile
        
        let p1 = CGPoint(x: mouthRect.minX + mouthRect.width/3,
                         y: mouthRect.minY + 2*offsetHeight/3)
        let p2 = CGPoint(x: mouthRect.maxX - mouthRect.width/3,
                         y: mouthRect.minY + 2*offsetHeight/3)
        
        
        let endPoint = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addCurve(to: endPoint, controlPoint1: p1, controlPoint2: p2)
        path.lineWidth = 3.0
        return path
    }
    
    override func draw(_ rect: CGRect)
    {
        UIColor.blue.set()
        pathForCircleCenteredAPoint(midPoint: skullCenter, withRadius:skullRadius ).stroke()
        pathForEye(eye: .Left).stroke()
        pathForEye(eye: .Right).stroke()
        pathForMouth().stroke()
    }
    
}
