//
//  SUSlidingUpVC.swift
//  SlidingUpSample
//
//  Created by Pouya Amirahmadi on 4/20/17.
//  Copyright © 2017 Pouya Amirahmadi. All rights reserved.
//

import UIKit

class SUSlidingUpVC: UIViewController, TSSlidingUpPanelDraggingDelegate,TSSlidingUpPanelAnimationDelegate {

    @IBOutlet weak var toggleSlidingUpPanelBtn: UIButton!
    let slidingUpManager: TSSlidingUpPanelManager = TSSlidingUpPanelManager.with
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        slidingUpManager.slidingUpPanelDraggingDelegate = self
        slidingUpManager.slidingUpPanelAnimationDelegate = self
    }
    
    @IBAction func toggleSlidingUpPanelBtnPressed(_ sender: Any) {
        if slidingUpManager.getSlideUpPanelState() == .DOCKED {
            slidingUpManager.changeSlideUpPanelStateTo(toState: .OPENED)
        } else {
            slidingUpManager.changeSlideUpPanelStateTo(toState: .DOCKED)
        }
    }
    
    func slidingUpPanelStartDragging(startYPos: CGFloat) {
        
    }
    
    func slidingUpPanelDraggingFinished(delta: CGFloat) {
        
    }
    
    func slidingUpPanelDraggingVertically(yPos: CGFloat) {
        let dismissBtnRotationDegree = slidingUpManager.scaleNumber(oldValue: yPos, newMin: 0, newMax: CGFloat(Double.pi))
        
        toggleSlidingUpPanelBtn.transform = CGAffineTransform(rotationAngle: dismissBtnRotationDegree)
    }
    
    func slidingUpPanelAnimationStart(withDuration: TimeInterval, slidingUpCurrentPanelState: SLIDE_UP_PANEL_STATE, yPos: CGFloat) {
        
        var rotationAngle: CGFloat = 0.0
        print("[SUSlidingUpVC::animationStart] sliding Up Panel state=\(slidingUpCurrentPanelState) yPos=\(yPos)")
        
        switch slidingUpCurrentPanelState {
            
        case .OPENED:
            rotationAngle = CGFloat(Double.pi)
            break
        case .DOCKED:
            rotationAngle = 0.0
            break
        case .CLOSED:
            rotationAngle = CGFloat(Double.pi)
            break;
        }
        
        UIView.animate(withDuration: withDuration, animations: {
            self.toggleSlidingUpPanelBtn.transform = CGAffineTransform(rotationAngle: rotationAngle)
        })
        
    }
    
    func slidingUpPanelAnimationFinished(withDuration: TimeInterval, slidingUpCurrentPanelState: SLIDE_UP_PANEL_STATE, yPos: CGFloat) {
        print("[SUSlidingUpVC::animationFinished] sliding Up Panel state=\(slidingUpCurrentPanelState) yPos=\(yPos)")
        
    }
}
