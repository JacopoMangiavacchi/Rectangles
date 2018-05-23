//
//  ViewController.swift
//  Rectangles
//
//  Created by Jacopo Mangiavacchi on 5/23/18.
//  Copyright © 2018 Jacopo Mangiavacchi. All rights reserved.
//

import UIKit

let minRectSize:CGFloat = 100

class ViewController: UIViewController {
    var rectViewArray = [UIView]()
    var intersectionViewArray = [UIView]()
    var gestureArray = [UIGestureRecognizer]()
    var firstTouchPoint: CGPoint?
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var addRectButton: UIBarButtonItem!
    
    let colors:[UIColor] = [.yellow, .red]
    
    //random color func needed for supporting more than 2 rectViews
    func color(_ i: Int) -> UIColor {
        return i < colors.count ? colors[i] : UIColor(red: CGFloat(arc4random() % 256) / 256,
                                                      green: CGFloat(arc4random() % 256) / 256,
                                                      blue: CGFloat(arc4random() % 256) / 256,
                                                      alpha: 1.0)
    }
    
    //add a rectView to the backGroundView.subView collection and to the rectViewArray
    func addRectView(frame: CGRect, color: UIColor) {
        //create and add rect view to the view.subView collection and to the rectViewArray
        let rectView = UIView(frame: CGRect(origin: frame.origin, size: CGSize(width: 0, height: 0)))
        rectView.backgroundColor = color
        rectView.alpha = 0
        self.backGroundView.addSubview(rectView)
        self.rectViewArray.append(rectView)
        
        //animate first apparence of the new rectView with minimal dimension
        UIView.animate(withDuration: 0.5, animations: {
            rectView.alpha = 1
            rectView.frame = frame
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
        self.backGroundView.addSubview(intersectionView)
        intersectionView.isUserInteractionEnabled = false
        self.intersectionViewArray.append(intersectionView)
    }

    //remove all intersectionView in the rectViewArray from the view.subView collection and from array itself
    func removeAllIntersectionViews() {
        for intersectionView in intersectionViewArray {
            intersectionView.removeFromSuperview()
        }
        
        intersectionViewArray.removeAll()
    }
    
    //remove all rectView in the rectViewArray from the view.subView collection and from array itself
    func removeAllRectViews() {
        for rectView in rectViewArray {
            rectView.removeFromSuperview()
        }
        
        rectViewArray.removeAll()
        
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //set minimum size for rectView
    func setMinimumSize(view: UIView) {
        view.frame = CGRect(x: view.frame.origin.x,
                            y: view.frame.origin.y,
                            width: max(minRectSize, view.frame.width),
                            height: max(minRectSize, view.frame.height))
    }
    
    //check if there is an intersection between rectViews in rectViewArray
    func checkIntersection() {
        let intersections = rectViewArray.map{$0.rectangle}.intersections
        
        removeAllIntersectionViews()
        
        for intersection in intersections {
            addIntersectionView(rectangle: intersection)
        }
    }
    
    @IBAction func addRect(_ sender: Any) {
        addRectButton.isEnabled = false
        disableAllGestureRecognizers()
    }
    
    func _reset() {
        removeAllRectViews()
        removeAllIntersectionViews()
        addRectButton.isEnabled = true
    }
    
    @IBAction func restart(_ sender: Any) {
        _reset()
    }
    
    //Shake to reset!
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        _reset()       
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
                checkIntersection()
            }
        }
    }
    
    @objc func panHandler(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed, let gestureView = gestureRecognizer.view {
            let translation = gestureRecognizer.translation(in: self.view.superview)
            gestureView.center = CGPoint(x: gestureView.center.x + translation.x, y: gestureView.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
            checkIntersection()
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
            addRectView(frame: CGRect(origin: firstTouchPoint!, size: CGSize(width: minRectSize, height: minRectSize)), color: color(rectViewArray.count))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouchPoint = firstTouchPoint, let touch = touches.first {
            let currentPoint = touch.location(in: view)
            let frame = CGRect(x: min(firstTouchPoint.x, currentPoint.x),
                               y: min(firstTouchPoint.y, currentPoint.y),
                               width: abs(firstTouchPoint.x - currentPoint.x),
                               height: abs(firstTouchPoint.y - currentPoint.y))
            if frame.width > 0 && frame.height > 0, let last = rectViewArray.last {
                last.frame = frame
                setMinimumSize(view: last)
                checkIntersection()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        firstTouchPoint = nil
        if !addRectButton.isEnabled {
            enableAllGestureRecognizers()
            addRectButton.isEnabled = true
        }
    }
}


