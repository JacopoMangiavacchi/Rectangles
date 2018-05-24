//
//  Engine.swift
//  Rectangles
//
//  Created by Jacopo Mangiavacchi on 5/23/18.
//  Copyright © 2018 Jacopo Mangiavacchi. All rights reserved.
//

import Foundation

//Engine Data
struct Engine {
    private var rectangleArray = [Rectangle]()
    private var intersectionArray: [Rectangle]?
    
    var delegate: EngineEvents?
}

//Engine Queries
extension Engine {
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
extension Engine {
    mutating func reset() {
        rectangleArray.removeAll()
        intersectionArray = nil
        _fireAsyncRefreshRender()
    }
    
    mutating func addRectangle(_ rect: Rectangle) {
        rectangleArray.append(rect)
        _checkIntersections()
        _fireAsyncRefreshRender()
    }

    mutating func resizeRectangle(pos: Int, to: Rectangle) {
        rectangleArray[pos] = to
        _checkIntersections()
        _fireAsyncRefreshRender()
    }
}

//Engine Private Methods
extension Engine {
    private mutating func _checkIntersections() {
        intersectionArray = rectangleArray.intersections
    }
}

//Engine Events
protocol EngineEvents {
    func refreshRender()
}

//Engine Events Async Fires
extension Engine {
    private func _fireAsyncRefreshRender() {
        DispatchQueue.main.async { [self] in
            self.delegate?.refreshRender()
        }
    }
}
