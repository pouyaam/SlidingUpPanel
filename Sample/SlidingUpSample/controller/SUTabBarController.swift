//
//  SUTabBarController.swift
//  SlidingUpSample
//
//  Created by Pouya Amirahmadi on 4/20/17.
//  Copyright © 2017 Pouya Amirahmadi. All rights reserved.
//

import UIKit

class SUTabBarController: UITabBarController, TSSlidingUpPanelStateDelegate {
    @IBOutlet weak var suTabBar: UITabBar!
    
    var slidingUpVC: SUSlidingUpVC!
    
    let slideUpPanelManager: TSSlidingUpPanelManager = TSSlidingUpPanelManager.with
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        slidingUpVC = (storyboard?.instantiateViewController(withIdentifier: "SUSlidingUp"))! as! SUSlidingUpVC
        
        slideUpPanelManager.slidingUpPanelStateDelegate = self
        
        slideUpPanelManager.initPanelWithTabBar(inView: view, tabBar: suTabBar, slidingUpPanelView: slidingUpVC.view, slidingUpPanelHeaderSize: 49)
        
        
        slideUpPanelManager.changeSlideUpPanelStateTo(toState: SLIDE_UP_PANEL_STATE.DOCKED)
    }
    
    
    func slidingUpPanelStateChanged(slidingUpPanelNewState: SLIDE_UP_PANEL_STATE, yPos: CGFloat) {
        
    }
}
