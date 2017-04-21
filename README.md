# SlidingUpPanel
iOS: Simple Sliding Up Panel With TabBar.

# Installation
There is only one way to install it to your project
Just copy TSSlidingUpPanelManager.swift into your project

Cocopods coming soon

# Usage
1- You need an UITabBarController in order to have UITabBar instance and also an instance of TSSlidingUpPanelManager
```swift
class SUTabBarController: UITabBarController, TSSlidingUpPanelStateDelegate {
    @IBOutlet weak var suTabBar: UITabBar!
    let slideUpPanelManager: TSSlidingUpPanelManager = TSSlidingUpPanelManager.with
    .
    .
    .
}
```
2- Design your slidingUp view in your story board

3- You need UIView instance of it, Don't forget to set proper identifier for your slidingUp view controller
```swift
let slidingUpVC = (storyboard?.instantiateViewController(withIdentifier: "SUSlidingUp"))! as! SUSlidingUpVC
let slidingUpView = slidingUpVC.view
```

4- Initilize view
```swift
slideUpPanelManager.initPanelWithTabBar(inView: view, tabBar: suTabBar, slidingUpPanelView: slidingUpVC.view,   slidingUpPanelHeaderSize: 49)
```
# TSSlidingUpPanelManager
TSSldingUpPanelManager is a singleton manager which provides the following features

## Methods
### initPanelWithTabBar
inView: UIView                     - Parent view, which sliding panel is going to be there, in my case it's my UITabBarController view

tabBar: UITabBar                   - UITabBar as it says

slidingUpPanelView: UIView         - UIView of your sliding up panel view

slidingUpPanelHeaderSize: CGFloat  - Size of the slidingUpPanel header

### changeSlideUpPanelStateTo
You can change slidingUpPanel state by it.
toState: SLIDE_UP_PANEL_STATE
```swift
enum SLIDE_UP_PANEL_STATE {
    case CLOSED
    case OPENED
    case DOCKED
}
```

### getSlideUpPanelState
return slideUpPanelState

### scaleNumber
If you want to scale the number, it's mostly used when user is dragging the slidingUpPanel and you want to adjust your views according to position of slidingUpPanel

## Properties

### animationDuration
You can change animation duration , default is 0.35

### stickyTabBar
If it's true, tabbar won't be affected by animation or dragging , default is false


## Delegates
### TSSlidingUpPanelStateDelegate
When SlidingUpPanel state is changed the following delegate is called
```swift
// slidingUpPanelNewState: new state
// yPos: Y poisition of the panel at new state
func slidingUpPanelStateChanged(slidingUpPanelNewState: SLIDE_UP_PANEL_STATE, yPos: CGFloat)
```
#### Usage
```swift
class SUTabBarController: ..., TSSlidingUpPanelStateDelegate {
...
    override func viewDidLoad() {
      ...
      slideUpPanelManager.slidingUpPanelStateDelegate = self
      ...
    }
    func slidingUpPanelStateChanged(slidingUpPanelNewState: SLIDE_UP_PANEL_STATE, yPos: CGFloat) {
      ...
    }
}
```
### TSSlidingUpPanelAnimationDelegate
These delegates are called when the UI Animation, which is responsbile to move the layouts (panel & tabbar), starts and finished
```swift
// withDuration: how long does the animation take
// slidingUpCurrentPanelState: at what state the animation is going to take place
// yPos: at what Y Position the animation is going to take place
func slidingUpPanelAnimationStart(withDuration: TimeInterval, slidingUpCurrentPanelState: SLIDE_UP_PANEL_STATE, yPos: CGFloat)

// withDuration: how long did it take
// slidingUpCurrentPanelState: at what state the animation is finished
// yPos: at what Y Position the animation is finished
func slidingUpPanelAnimationFinished(withDuration: TimeInterval, slidingUpCurrentPanelState: SLIDE_UP_PANEL_STATE, yPos: CGFloat)
```
#### Usage
```swift
class ViewController: UIViewController,...,TSSlidingUpPanelAnimationDelegate {
...
    override func viewDidLoad() {
        ...
        slideUpPanelManager.slidingUpPanelAnimationDelegate = self
        ...
    }
    
    func slidingUpPanelAnimationStart(withDuration: TimeInterval, slidingUpCurrentPanelState: SLIDE_UP_PANEL_STATE, yPos: CGFloat) {
        ...
    }

    func slidingUpPanelAnimationFinished(withDuration: TimeInterval, slidingUpCurrentPanelState: SLIDE_UP_PANEL_STATE, yPos: CGFloat) {
        ...
    }
...
}
```
### TSSlidingUpPanelDraggingDelegate
These delegates are called when user begins to drag the view

```swift
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
```

#### Usage
```swift
class ViewController: UIViewController,...,TSSlidingUpPanelDraggingDelegate {

    override func viewDidLoad() {
        ...
        slideUpPanelManager.slidingUpPanelDraggingDelegate = self
        ...
    }

    func slidingUpPanelStartDragging(startYPos: CGFloat) {
        ...
    }

    func slidingUpPanelDraggingVertically(yPos: CGFloat) {
        ...
    }
    func slidingUpPanelDraggingFinished(delta:  CGFloat) {
        ...
    } 
}
```


## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

