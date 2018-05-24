//
//  Rectangle.swift
//  Rectangles
//
//  Created by Jacopo Mangiavacchi on 5/23/18.
//  Copyright © 2018 Jacopo Mangiavacchi. All rights reserved.
//

import Foundation

struct Rectangle: CustomStringConvertible, Equatable, Hashable {
    // coordinates from top left corner
    let leftX: Float
    let topY: Float
    
    // dimensions
    let width: Float
    let height: Float
    
    init(leftX: Float, topY: Float, width: Float, height: Float) {
        self.leftX = leftX
        self.topY = topY
        self.width = width
        self.height = height
    }
    
    init() {
        self.init(leftX: 0, topY: 0, width: 0, height: 0)
    }
    
    //failable init intersection
    init?(rect1: Rectangle, rect2: Rectangle) {
        struct Overlap {
            let startingPoint: Float
            let length: Float
        }
        
        func _getOverlap(pos1: Float, length1: Float, pos2: Float, length2: Float) -> Overlap? {
            let maxPos = max(pos1, pos2)
            let minLength = min(pos1 + length1, pos2 + length2)
            
            guard maxPos < minLength else { return nil }
            
            return Overlap(startingPoint: maxPos, length: minLength - maxPos)
        }
        
        guard let x = _getOverlap(pos1: rect1.leftX, length1: rect1.width, pos2: rect2.leftX, length2: rect2.width) else { return nil }
        guard let y = _getOverlap(pos1: rect1.topY, length1: rect1.height, pos2: rect2.topY, length2: rect2.height) else { return nil }
        
        self.leftX = x.startingPoint
        self.topY = y.startingPoint
        self.width = x.length
        self.height = y.length
    }
    
    var description: String {
        return String(format: "(left=%d, top=%d, width=%d, height=%d)", leftX, topY, width, height)
    }
}


extension Array where Element == Rectangle {
    var intersections: [Rectangle] {
        get {
            var intersectionsSet = Set<Rectangle>()
            for i1 in 0..<self.count {
                for i2 in i1+1..<self.count {
                    if let intersection = Rectangle(rect1: self[i1], rect2: self[i2]) {
                        intersectionsSet.insert(intersection)
                    }
                }
            }
            
            return Array(intersectionsSet)
        }
    }
}


protocol RectangleViewProtocol {
    var rectangle: Rectangle {get set}
}


