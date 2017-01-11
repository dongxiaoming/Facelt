//
//  FaceView.swift
//  Facelt
//
//  Created by dongluis on 2017/01/06.
//  Copyright © 2017 dongluis. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    
    @IBInspectable
    var scale: CGFloat = 0.90 { didSet {setNeedsDisplay()}}
    @IBInspectable
    var mouthCurvature: Double = 1.0 { didSet {setNeedsDisplay()}}
    @IBInspectable
    var eyesOpen: Bool =  false { didSet {setNeedsDisplay()}}
    @IBInspectable
    var eyeBrowTilt: Double = 0.0 { didSet {setNeedsDisplay()}}
    @IBInspectable
    var color: UIColor = UIColor.blue { didSet {setNeedsDisplay()}}
    @IBInspectable
    var lineWidth:CGFloat = 5.0 { didSet {setNeedsDisplay()}}
    
    func changeScale(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            scale *= recognizer.scale
            recognizer.scale = 1.0
        case .ended:
            scale = 0.90
        default: break
        }

    }
    
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
        static let SkullRadiusToBrowOffset : CGFloat = 5
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
        path.lineWidth = lineWidth
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
        if eyesOpen {
            return pathForCircleCenteredAPoint(midPoint: eyeCenter, withRadius: eyeRadius)
        } else {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y ))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
            path.lineWidth = lineWidth
            return path
        }
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
        
        let smileOffset = mouthRect.height * CGFloat(max(-1, min(mouthCurvature,1)))
        
        let p1 = CGPoint(x: mouthRect.minX + mouthRect.width/3,
                         y: mouthRect.minY + 2*smileOffset/3)
        let p2 = CGPoint(x: mouthRect.maxX - mouthRect.width/3,
                         y: mouthRect.minY + 2*smileOffset/3)
        
        
        let endPoint = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addCurve(to: endPoint, controlPoint1: p1, controlPoint2: p2)
        path.lineWidth = lineWidth
        return path
    }
    
    static let SkullRadiusToBrowOfset : CGFloat = 5
    
    private func pathForBrow(eye: Eye) -> UIBezierPath {
        var tilt = eyeBrowTilt
        switch eye {
            case .Left: tilt *= -1.0
            case .Right: break
        }
        var browCenter = getEyeCenter(eye: eye)
        browCenter.y -= skullRadius / Ratios.SkullRadiusToBrowOffset
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let tiltOffset = CGFloat(max(-1, min(tilt,1))) * eyeRadius / 2
        let browStart = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
        let browEnd = CGPoint(x: browCenter.x + eyeRadius, y: browCenter.y + tiltOffset)
        let path = UIBezierPath()
        path.move(to: browStart)
        path.addLine(to: browEnd)
        path.lineWidth = lineWidth
        return path
    }
    
    override func draw(_ rect: CGRect)
    {
        color.set()
        pathForCircleCenteredAPoint(midPoint: skullCenter, withRadius:skullRadius ).stroke()
        pathForEye(eye: .Left).stroke()
        pathForEye(eye: .Right).stroke()
        pathForMouth().stroke()
        pathForBrow(eye: .Left).stroke()
        pathForBrow(eye: .Right).stroke()
    }
    
}
