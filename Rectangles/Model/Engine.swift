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
    var rectangleArray = [Rectangle]()
    var intersectionArray: [Rectangle]?
    var delegate: EngineEvents?
}

//Engine Intents
extension Engine {
    mutating func reset() {
        rectangleArray.removeAll()
        intersectionArray = nil
        _fireRefreshRender()
    }
    
    mutating func addRectangle(_ rect: Rectangle) {
        rectangleArray.append(rect)
        _checkIntersections()
        _fireRefreshRender()
    }

    mutating func moveRectangle(pos: Int, to: Rectangle) {
        rectangleArray[pos] = to
        _checkIntersections()
        _fireRefreshRender()
    }
}

//Engine Private Methods
extension Engine {
    mutating func _checkIntersections() {
        intersectionArray = rectangleArray.intersections
    }
}

//Engine Events
protocol EngineEvents {
    func refreshRender()
}

//Engine Events Async Fires
extension Engine {
    func _fireRefreshRender() {
        DispatchQueue.main.async { [self] in
            self.delegate?.refreshRender()
        }
    }
}
