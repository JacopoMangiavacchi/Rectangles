//
//  RectangleEngine.swift
//  Rectangles
//
//  Created by Jacopo Mangiavacchi on 5/23/18.
//  Copyright © 2018 Jacopo Mangiavacchi. All rights reserved.
//

import Foundation

//Engine Data
struct RectangleEngine : Engine {
    private var rectangleArray = [Rectangle]()
    private var intersectionArray: [Rectangle]? {
        didSet {
            DispatchQueue.main.async { [self] in
                self.delegate?.refreshRender()
            }
        }
    }
    
    var delegate: EngineEvents?

    let smallRectSize:Float = 100
    let bigRectSize:Float = 200

    
    mutating func fullFill(intent: String, parameters: [String : Any]?, completition: ((_ sayText: String, _ displayText: String, _ forceClose: Bool) -> Void)?) {
        switch intent {
        case "reset":
            reset()
            completition?("Ok", "Ok", true)
        case "addRectangle":
            let left = parameters!["left"] as! Float
            let top = parameters!["top"] as! Float
            var width = smallRectSize
            var height = smallRectSize

            if let w = parameters!["left"] as? Float, let h = parameters!["height"] as? Float {
                width = w
                height = h
            }
            else if let type = parameters!["type"] as? String {
                switch type {
                case "small":
                    //nop
                    break
                case "big":
                    width = bigRectSize
                    height = bigRectSize
                    break
                default:
                    //nop
                    break
                }
            }
            else {
                //nop
            }
            
            addRectangle(Rectangle(leftX: left, topY: top, width: width, height: height))
            completition?("New rectangle added", "New rectangle added", true)

        default:
            break
        }
    }
}

//Engine Queries
extension RectangleEngine {
    var rectangleCount: Int {
        get {
            return rectangleArray.count
        }
    }
    
    var allIntersections: [Rectangle] {
        get {
            return intersectionArray ?? [Rectangle]()
        }
    }

    var allRectangles: [Rectangle] {
        get {
            return rectangleArray
        }
    }
}
    
//Engine Intents
extension RectangleEngine {
    mutating func reset() {
        rectangleArray.removeAll()
        intersectionArray = nil
    }
    
    mutating func addRectangle(_ rect: Rectangle) {
        rectangleArray.append(rect)
        _checkIntersections()
    }

    mutating func resizeRectangle(pos: Int, to: Rectangle) {
        rectangleArray[pos] = to
        _checkIntersections()
    }
}

//Engine Private Methods
extension RectangleEngine {
    private mutating func _checkIntersections() {
        intersectionArray = rectangleArray.intersections
    }
}

//Engine Events
protocol EngineEvents {
    func refreshRender()
}



