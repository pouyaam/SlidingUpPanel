//
//  TSSlidingUpPanelManager.swift
//
//
//  Created by Pouya Amirahmadi on 4/20/17.
//  Copyright © 2017 Pouya Amirahmadi. All rights reserved.
//  Signleton manager which is suppose to manage your sliding up panel

import UIKit


// The panel states
enum SLIDE_UP_PANEL_STATE {
    case CLOSED
    case OPENED
    case DOCKED
}

// When the panel state is changed, the following delegate is called
// slidingUpPanelNewState: new state
// yPos: Y poisition of the panel at new state
protocol TSSlidingUpPanelStateDelegate: class {
    func slidingUpPanelStateChanged(slidingUpPanelNewState: SLIDE_UP_PANEL_STATE, yPos: CGFloat)
}

//These delegates are called when the UI Animation, which is responsbile to move the layouts, start and finish
protocol TSSlidingUpPanelAnimationDelegate: class {
    // withDuration: how long does the animation take
    // slidingUpCurrentPanelState: at what state the animation is going to take place
    // yPos: at what Y Position the animation is going to take place
    func slidingUpPanelAnimationStart(withDuration: TimeInterval, slidingUpCurrentPanelState: SLIDE_UP_PANEL_STATE, yPos: CGFloat)
    
    // withDuration: how long did it take
    // slidingUpCurrentPanelState: at what state the animation is finished
    // yPos: at what Y Position the animation is finished
    func slidingUpPanelAnimationFinished(withDuration: TimeInterval, slidingUpCurrentPanelState: SLIDE_UP_PANEL_STATE, yPos: CGFloat)
}

protocol TSSlidingUpPanelDraggingDelegate: class {
    // when panel is began to be dragging by user
    // startYPos at what Y Position user began to drag the panel
    func slidingUpPanelStartDragging(startYPos: CGFloat)
    
    // When panel in being dragged by user
    // yPos: the center position of the panel
    func slidingUpPanelDraggingVertically(yPos: CGFloat)
    
    // When user is done by dragging
    // Delta: if it's positive , it means panel was being dragged to the bottom of the screen
    //        if it's negative , it means panel was being dragged to the top of the screen
    func slidingUpPanelDraggingFinished(delta:  CGFloat)
}

class TSSlidingUpPanelManager: NSObject {
    static let with = TSSlidingUpPanelManager()
    
    var slideUpPanelState:               SLIDE_UP_PANEL_STATE!
    var slidingUpPanelStateDelegate:     TSSlidingUpPanelStateDelegate?
    var slidingUpPanelAnimationDelegate: TSSlidingUpPanelAnimationDelegate?
    var slidingUpPanelDraggingDelegate:  TSSlidingUpPanelDraggingDelegate?
    
    // parent view
    var view:                 UIView!
    
    // slidingUp panel view
    var slidingUpPanelView:   UIView!
    
    // tabBar
    var tabBar:               UITabBar!
    
    // Position of the beginning of dragging panel
    var dragStartYPos:        CGFloat!
    
    // Height the view
    var viewFrameHeight:      CGFloat!
    
    // Minimum Y Position of the panel
    var minOverlayYPos:       CGFloat!
    
    // The origin of tabbar
    var originTabBarYPos:     CGFloat!
    
    // tabbar height
    var tabBarFrameHeight:    CGFloat      = 0
    
    // Panel header
    var headerSize:           CGFloat      = 49
    
    // Animation duration
    var animationDuration:    TimeInterval = 0.35
    
    // if it's true, tabbar won't be affected by animation or dragging
    var stickyTabBar:         Bool         = false
    
    private override init() {
    }
    
    func initPanelWithTabBar(inView: UIView, tabBar: UITabBar, slidingUpPanelView: UIView, slidingUpPanelHeaderSize: CGFloat) {
        
        self.tabBar = tabBar
        tabBarFrameHeight = tabBar.frame.height
        initlizeParams(inView: inView, slidingUpPanelView: slidingUpPanelView, slidingUpPanelHeaderSize: slidingUpPanelHeaderSize)
        
        view.insertSubview(slidingUpPanelView, belowSubview: tabBar)
        setSlideUpPanelState()
    }

    func changeSlideUpPanelStateTo(toState: SLIDE_UP_PANEL_STATE) {
        var toSlideUpYPos: CGFloat!
        var toTabBarYPos:  CGFloat!
        
        switch toState {
        case .CLOSED:
            toSlideUpYPos = viewFrameHeight
            toTabBarYPos  = originTabBarYPos
            break
            
        case .OPENED:
            toSlideUpYPos = 0
            toTabBarYPos  = viewFrameHeight
            break
        case .DOCKED:
            toSlideUpYPos = minOverlayYPos
            toTabBarYPos  = originTabBarYPos
            break
        }
        
        animatePanel(toSlideUpYPos: toSlideUpYPos, toTabBarYPos: toTabBarYPos)
    }
    
    func getSlideUpPanelState() -> SLIDE_UP_PANEL_STATE {
        return slideUpPanelState
    }
    
    func scaleNumber(oldValue: CGFloat, newMin: CGFloat, newMax:CGFloat) -> CGFloat {
        let min = view.frame.height / 2
        let max = view.frame.height + min  - tabBarFrameHeight + headerSize
        let oldRange = min - max
        let newRange = newMax - newMin
        return (((oldValue - min) * newRange) / oldRange) + newMin
        
    }
    
    private func initlizeParams(inView: UIView, slidingUpPanelView: UIView, slidingUpPanelHeaderSize: CGFloat) {
        self.view               = inView
        self.slidingUpPanelView = slidingUpPanelView
        self.headerSize         = slidingUpPanelHeaderSize
        self.minOverlayYPos     = view.frame.height - (tabBarFrameHeight + headerSize)
        self.originTabBarYPos   = self.tabBar != nil ? tabBar.frame.origin.y : view.frame.height
        self.viewFrameHeight    = view.frame.height
        slidingUpPanelView.frame = CGRect(x: 0, y: viewFrameHeight, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        let overlayPanGR: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panSlideUpView))
        
        slidingUpPanelView.addGestureRecognizer(overlayPanGR)
    }
    
    
    @objc private func panSlideUpView(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.view)
        let min         = sender.view!.frame.height / 2
        let max         = sender.view!.frame.height + min  - (tabBarFrameHeight + headerSize)
        var yPos        = sender.view!.center.y + translation.y
        yPos            = yPos > max ? max : (yPos <= min ? min : yPos)
        let tabBarYPos  = scaleNumber(oldValue: yPos, newMin: viewFrameHeight, newMax: viewFrameHeight + 49)
        
        if sender.state == .began {
            
            dragStartYPos = yPos
            
            if slidingUpPanelDraggingDelegate != nil {
                slidingUpPanelDraggingDelegate?.slidingUpPanelStartDragging(startYPos: dragStartYPos)
            }
            
        } else if sender.state == .changed {
            
            if slidingUpPanelDraggingDelegate != nil {
                slidingUpPanelDraggingDelegate?.slidingUpPanelDraggingVertically(yPos: yPos)
            }
            if tabBar != nil && !stickyTabBar {
                tabBar.frame.origin.y = CGFloat(tabBarYPos)
            }
            sender.view!.center   = CGPoint(x: sender.view!.center.x, y: yPos)
            
            sender.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
            
        } else if sender.state == .ended {
            
            let delta = yPos - dragStartYPos
            
            if slidingUpPanelDraggingDelegate != nil {
                slidingUpPanelDraggingDelegate?.slidingUpPanelDraggingFinished(delta: delta)
            }
            
            if delta > 0 {
                changeSlideUpPanelStateTo(toState: .DOCKED)
            } else {
                changeSlideUpPanelStateTo(toState: .OPENED)
            }
            
        }
    }
    
    private func animatePanel(toSlideUpYPos: CGFloat, toTabBarYPos: CGFloat) {
        
        UIView.animate(withDuration: animationDuration, animations: {
            
            if self.slidingUpPanelAnimationDelegate != nil {
                self.slidingUpPanelAnimationDelegate?.slidingUpPanelAnimationStart(withDuration: self.animationDuration, slidingUpCurrentPanelState: self.slideUpPanelState, yPos: self.slidingUpPanelView.frame.origin.y)
            }
            
            self.slidingUpPanelView.frame.origin.y = toSlideUpYPos
            
            if self.tabBar != nil && !self.stickyTabBar {
                self.tabBar.frame.origin.y         = toTabBarYPos
            }
            
        }, completion: { completed in
            
            self.setSlideUpPanelState()
            if self.slidingUpPanelAnimationDelegate != nil {
                self.slidingUpPanelAnimationDelegate?.slidingUpPanelAnimationFinished(withDuration: self.animationDuration, slidingUpCurrentPanelState: self.slideUpPanelState, yPos: self.slidingUpPanelView.frame.origin.y)
            }
            
        })
    }
    
    private func setSlideUpPanelState() {
        let y = slidingUpPanelView.frame.origin.y
        
        if y == viewFrameHeight {
            slideUpPanelState = .CLOSED
        } else if y == minOverlayYPos {
            slideUpPanelState = .DOCKED
        } else {
            slideUpPanelState = .OPENED
        }
        
        if slidingUpPanelStateDelegate != nil {
            slidingUpPanelStateDelegate?.slidingUpPanelStateChanged(slidingUpPanelNewState: slideUpPanelState, yPos: y)
        }
    }
}











