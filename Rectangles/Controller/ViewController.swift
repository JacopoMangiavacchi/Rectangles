//
//  ViewController.swift
//  Rectangles
//
//  Created by Jacopo Mangiavacchi on 5/23/18.
//  Copyright © 2018 Jacopo Mangiavacchi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var engine = RectangleEngine()
    var forceFullRefresh = false

    var gestureArray = [UIGestureRecognizer]()
    var firstTouchPoint: CGPoint?
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var addRectButton: UIBarButtonItem!
    
    lazy var rectsView: UIView = {
        let view = UIView(frame: backGroundView.bounds)
        view.backgroundColor = .clear
        backGroundView.addSubview(view)
        backGroundView.bringSubview(toFront: intersectionsView)
        return view
    }()
    
    lazy var intersectionsView: UIView = {
        let view = UIView(frame: backGroundView.bounds)
        view.backgroundColor = .clear
        view.alpha = 1
        view.isUserInteractionEnabled = false
        backGroundView.addSubview(view)
        return view
    }()

    
    let colors:[UIColor] = [.yellow, .red]
    
    //random color func needed for supporting more than 2 rectViews
    func color(_ i: Int) -> UIColor {
        return i < colors.count ? colors[i] : UIColor(red: CGFloat(10 + (arc4random() % 246)) / 256,
                                                      green: CGFloat(10 + (arc4random() % 246)) / 256,
                                                      blue: CGFloat(10 + (arc4random() % 246)) / 256,
                                                      alpha: 1.0)
    }
    
    //create and add rect view to the rectsView.subView collection and to the engine
    func addRectView(rectangle: Rectangle) {
        let rectView = UIRectangleView()
        rectView.rectangle = Rectangle(leftX: rectangle.leftX, topY: rectangle.topY, width: 0, height: 0)
        rectView.tag = engine.rectangleCount
        rectView.backgroundColor = color(engine.rectangleCount)
        rectView.alpha = 0
        self.rectsView.addSubview(rectView)
        self.engine.addRectangle(rectView.rectangle)
        
        //animate first apparence of the new rectView with minimal dimension
        UIView.animate(withDuration: 0.5, animations: {
            rectView.alpha = 1
            rectView.rectangle = rectangle
        })
        
        //add UIPinchGestureRecognizer for resizing rectView
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchHandler))
        pinchGesture.isEnabled = false
        pinchGesture.delegate = self
        pinchGesture.cancelsTouchesInView = false
        rectView.addGestureRecognizer(pinchGesture)
        gestureArray.append(pinchGesture)
        
        //add UIPanGestureRecognizer for moving rectView
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panHandler))
        panGesture.isEnabled = false
        panGesture.delegate = self
        panGesture.cancelsTouchesInView = false
        rectView.addGestureRecognizer(panGesture)
        gestureArray.append(panGesture)
    }
    
    //add an intersectionView
    func addIntersectionView(rectangle: Rectangle) {
        let intersectionView = UIView()
        intersectionView.rectangle = rectangle
        intersectionView.backgroundColor = .orange
        self.intersectionsView.addSubview(intersectionView)
    }

    //remove all intersectionView in the intersectionsView.subviews
    func removeAllIntersectionViews() {
        for intersectionView in intersectionsView.subviews {
            intersectionView.removeFromSuperview()
        }
    }
    
    //remove all rectView in the rectsView.subview
    func removeAllRectViews() {
        for rectView in rectsView.subviews {
            rectView.removeFromSuperview()
        }
        gestureArray.removeAll()
    }
    
    //enable all gesture recognizers for rectViews
    func enableAllGestureRecognizers() {
        for gesture in gestureArray {
            gesture.isEnabled = true
        }
    }
    
    //disable all gesture recognizers for rectViews while in add Rect mode
    func disableAllGestureRecognizers() {
        for gesture in gestureArray {
            gesture.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        engine.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //set minimum size for rectView
    func setMinimumSize(view: UIView) {
        view.frame = CGRect(x: view.frame.origin.x,
                            y: view.frame.origin.y,
                            width: max(CGFloat(engine.smallRectSize), view.frame.width),
                            height: max(CGFloat(engine.smallRectSize), view.frame.height))
    }
    
    @IBAction func addRect(_ sender: Any) {
        self.navigationItem.prompt = nil
        addRectButton.isEnabled = false
        disableAllGestureRecognizers()
    }
    
    func _reset() {
        self.navigationItem.title = "Rectangles"
        engine.reset()
        removeAllRectViews()
        removeAllIntersectionViews()
        addRectButton.isEnabled = true
    }
    
    @IBAction func restart(_ sender: Any) {
        _reset()
    }
    
    @IBAction func siriAction(_ sender: Any) {
        //TODO: NLU Intents/Query understanding from Engine Intents and Queries
        //Forced recognition of RectangleEngine "reset" Intent with no parameters
        forceFullRefresh = true
        engine.fullFill(intent: "reset", parameters: nil) {(sayText, displayText, forceClose) in
            print(sayText)
            if forceClose {
                print("close Siri")
            }
        }
        //engine.fullFill(intent: "addRectangle", parameters: ["left" : 50, "top" : 100, "type" : "small"])
    }
    
    //Shake to reset!
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        _reset()       
    }
}

// implement refresh view event from the Engine
extension ViewController : EngineEvents {
    func refreshRender() {
        removeAllIntersectionViews()

        if forceFullRefresh {
            forceFullRefresh = false
            
            removeAllRectViews()
            for rectangle in engine.allRectangles {
                addRectView(rectangle: rectangle)
            }

            if engine.allRectangles.isEmpty {
                self.navigationItem.title = "Rectangles"
            }
            else {
                self.navigationItem.title = "\(engine.allRectangles.count) Rectangles"
            }
        }
        
        for intersection in engine.allIntersections {
            addIntersectionView(rectangle: intersection)
        }
        
        if engine.allIntersections.isEmpty {
            navigationController?.navigationBar.barTintColor = UIColor.white
        }
        else {
            navigationController?.navigationBar.barTintColor = UIColor.orange
        }
    }
}

//Gesture recognizers to move and resize rectViews
extension ViewController: UIGestureRecognizerDelegate {
    @objc func pinchHandler(_ gestureRecognizer: UIPinchGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed, let gestureView = gestureRecognizer.view {
            if gestureRecognizer.numberOfTouches == 2 {
                let firstPoint = gestureRecognizer.location(ofTouch: 0, in: gestureView)
                let secondPoint = gestureRecognizer.location(ofTouch: 1, in: gestureView)
                
                var scaleX = gestureRecognizer.scale
                var scaleY = gestureRecognizer.scale
                
                let absHorizontal = abs(firstPoint.x - secondPoint.x)
                let absVertical = abs(firstPoint.y - secondPoint.y)
                
                if absVertical == 0 || absHorizontal / absVertical > 2 {
                    scaleY = 1
                }
                else {
                    scaleX = 1
                }
                
                gestureView.transform = gestureView.transform.scaledBy(x: scaleX, y: scaleY)
                gestureRecognizer.scale = 1
                setMinimumSize(view: gestureView)
                engine.resizeRectangle(pos: gestureView.tag, to: gestureView.rectangle)
            }
        }
    }
    
    @objc func panHandler(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed, let gestureView = gestureRecognizer.view {
            let translation = gestureRecognizer.translation(in: self.view.superview)
            gestureView.center = CGPoint(x: gestureView.center.x + translation.x, y: gestureView.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
            engine.resizeRectangle(pos: gestureView.tag, to: gestureView.rectangle)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}


//Touches Events to Draw new Rectangles
extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !addRectButton.isEnabled, let touch = touches.first {
            firstTouchPoint = touch.location(in: self.view)
            addRectView(rectangle: Rectangle(leftX: Float(firstTouchPoint!.x),
                                             topY: Float(firstTouchPoint!.y),
                                             width: Float(CGFloat(engine.smallRectSize)),
                                             height: Float(CGFloat(engine.smallRectSize))))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouchPoint = firstTouchPoint, let touch = touches.first {
            let currentPoint = touch.location(in: view)
            let frame = CGRect(x: min(firstTouchPoint.x, currentPoint.x),
                               y: min(firstTouchPoint.y, currentPoint.y),
                               width: abs(firstTouchPoint.x - currentPoint.x),
                               height: abs(firstTouchPoint.y - currentPoint.y))
            if frame.width > 0 && frame.height > 0, let last = rectsView.subviews.last {
                last.frame = frame
                setMinimumSize(view: last)
                engine.resizeRectangle(pos: last.tag, to: last.rectangle)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        firstTouchPoint = nil
        if !addRectButton.isEnabled {
            enableAllGestureRecognizers()
            addRectButton.isEnabled = true
            self.navigationItem.title = "\(engine.allRectangles.count) Rectangles"
        }
    }
}

