//
//  ViewController.swift
//  Facelt
//
//  Created by dongluis on 2017/01/05.
//  Copyright © 2017 dongluis. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    var facialExpression = FacialExpression(eyes: .Open, eyeBrows: .Relaxed, mouth: .Smile){
        didSet {
            updateUI()
        }
    }

    @IBOutlet weak var faceView: FaceView!{
        didSet {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: faceView,
                action: #selector(FaceView.changeScale(recognizer:)
                )))
            
            let happinerRecognizer = UISwipeGestureRecognizer(
                target: self,
                action: #selector(FaceViewController.mouthSmiler))
            happinerRecognizer.direction = .down
            faceView.addGestureRecognizer(happinerRecognizer)
            
            let sadderRecognizer = UISwipeGestureRecognizer(
                target: self,
                action: #selector(FaceViewController.mouthSadder))
            sadderRecognizer.direction = .up
            faceView.addGestureRecognizer(sadderRecognizer)
            
            let relasedBrowRecognizer = UISwipeGestureRecognizer(
                target: self,
                action: #selector(FaceViewController.relasedBrow))
            relasedBrowRecognizer.direction = .left
            faceView.addGestureRecognizer(relasedBrowRecognizer)
            
            let furrowedBrowRecognizer = UISwipeGestureRecognizer(
                target: self,
                action: #selector(FaceViewController.furrowedBrow))
            furrowedBrowRecognizer.direction = .right
            faceView.addGestureRecognizer(furrowedBrowRecognizer)
            
            updateUI()
        }
    }
    
    @IBAction func taggleEye(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            switch facialExpression.eyes {
            case .Open: facialExpression.eyes = .Closed
            case .Closed: facialExpression.eyes = .Open
            case.Squinting: break
            }
        }
    }
    private var mouthCurvature = [FacialExpression.Mouth.Frown: -1.0, .Smirk: -0.5, .Neutral: 0.0, .Grin: 0.5, .Smile: 1.0]
    private var eyeBrowTilts = [FacialExpression.EyeBrows.Furrowed: -1.0, .Normal: 0.0, .Relaxed: 1.0]
    
    func mouthSmiler() {
            facialExpression.mouth = facialExpression.mouth.happierMouth()
    }
    
    func mouthSadder() {
        facialExpression.mouth = facialExpression.mouth.sadderMouth()
    }
    
    func relasedBrow() {
        facialExpression.eyeBrows = facialExpression.eyeBrows.moreRelasedBrow()
    }
    
    func furrowedBrow() {
        facialExpression.eyeBrows = facialExpression.eyeBrows.moreFurrowedVrow()
    }
    
    func updateUI() {
        switch facialExpression.eyes {
            case .Open: faceView.eyesOpen = true
            case .Closed: faceView.eyesOpen = false
            case .Squinting: faceView.eyesOpen = false
        }
        faceView.mouthCurvature = mouthCurvature[facialExpression.mouth] ?? 0.0
        faceView.eyeBrowTilt = eyeBrowTilts[facialExpression.eyeBrows] ?? 0.0
    }
    
}

