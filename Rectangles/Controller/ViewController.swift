//
//  ViewController.swift
//  Rectangles
//
//  Created by Jacopo Mangiavacchi on 5/23/18.
//  Copyright © 2018 Jacopo Mangiavacchi. All rights reserved.
//

import UIKit

let maxRectView = 2
let minRectSize:CGFloat = 100

class ViewController: UIViewController {
    var rectViewArray = [UIView]()
    var gestureArray = [UIGestureRecognizer]()
    var firstTouchPoint: CGPoint?
    
    lazy var intersectionView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.backgroundColor = .orange
        view.isHidden = true
        self.view.addSubview(view)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let colors:[UIColor] = [.yellow, .red]
    
    //random color func needed for eventually support maxRectView > colors.count
    func color(_ i: Int) -> UIColor {
        return i < colors.count ? colors[i] : UIColor(red: CGFloat(arc4random() % 256) / 256,
                                                      green: CGFloat(arc4random() % 256) / 256,
                                                      blue: CGFloat(arc4random() % 256) / 256,
                                                      alpha: 1.0)
    }
    
    //add a rectView to the view.subView collection and to the rectViewArray
    func addRectView(frame: CGRect, color: UIColor) {
        let rectView = UIView(frame: frame)
        rectView.backgroundColor = color
        self.view.addSubview(rectView)
        self.rectViewArray.append(rectView)
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Shake to reset!
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        removeAllRectViews()
        intersectionView.isHidden = true
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
        
        if intersections.isEmpty {
            intersectionView.isHidden = true
        }
        else {
            intersectionView.rectangle = intersections.first!
            intersectionView.isHidden = false
            self.view.bringSubview(toFront: intersectionView)
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


//Touches Events to Draw new Rectangles (up to maxRectView)
extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if rectViewArray.count < maxRectView, let touch = touches.first {
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
        if rectViewArray.count == maxRectView {
            enableAllGestureRecognizers()
        }
    }
}


