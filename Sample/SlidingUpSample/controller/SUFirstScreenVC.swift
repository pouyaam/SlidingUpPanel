//
//  FirstScreenVC.swift
//  tabbedsample
//
//  Created by Pouya Amirahmadi on 4/20/17.
//  Copyright © 2017 Pouya Amirahmadi. All rights reserved.
//

import UIKit


class SUFirstScreenVC: UIViewController, TSSlidingUpPanelStateDelegate {

    let slideUpPanelManager = TSSlidingUpPanelManager.with
    override func viewDidLoad() {
        super.viewDidLoad()
        slideUpPanelManager.slidingUpPanelStateDelegate = self
    }
    
    @IBAction func toggleSlidingUpPanel(_ sender: Any) {
        switch slideUpPanelManager.getSlideUpPanelState() {
        case .OPENED:
            slideUpPanelManager.changeSlideUpPanelStateTo(toState: .DOCKED)
            break
        case .CLOSED:
            slideUpPanelManager.changeSlideUpPanelStateTo(toState: .DOCKED)
            break
        case .DOCKED:
            slideUpPanelManager.changeSlideUpPanelStateTo(toState: .CLOSED)
            break
        }
    }
    func slidingUpPanelStateChanged(slidingUpPanelNewState: SLIDE_UP_PANEL_STATE, yPos: CGFloat) {
        print("[SUFirstScreenVC::slidingUpPanelStateChanged] slidingUpPanelNewState=\(slidingUpPanelNewState) yPos=\(yPos)")
    }
}
