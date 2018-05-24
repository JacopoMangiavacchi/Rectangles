//
//  RectanglesTests.swift
//  RectanglesTests
//
//  Created by Jacopo Mangiavacchi on 5/23/18.
//  Copyright © 2018 Jacopo Mangiavacchi. All rights reserved.
//

import XCTest
@testable import Rectangles

class RectanglesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRectangle() {
        let a = Rectangle(leftX: 1, topY: 1, width: 3, height: 2)
        
        XCTAssertEqual(Rectangle(rect1: a, rect2: Rectangle(leftX: 3, topY: 2, width: 2, height: 3)),
                       Rectangle(leftX: 3, topY: 2, width: 1, height: 1))
        
        XCTAssertEqual(Rectangle(rect1: a, rect2: Rectangle(leftX: 3, topY: 0, width: 2, height: 2)),
                       Rectangle(leftX: 3, topY: 1, width: 1, height: 1))
        
        XCTAssertEqual(Rectangle(rect1: a, rect2: Rectangle(leftX: 2, topY: 0, width: 1, height: 2)),
                       Rectangle(leftX: 2, topY: 1, width: 1, height: 1))
        
        XCTAssertEqual(Rectangle(rect1: a, rect2: a), a)
        
        XCTAssertEqual(Rectangle(rect1: a, rect2: Rectangle(leftX: 2, topY: 3, width: 2, height: 2)), nil)
        
        XCTAssertEqual(Rectangle(rect1: a, rect2: Rectangle(leftX: 1, topY: 1, width: 0, height: 0)), nil)
        
        XCTAssertEqual(Rectangle(rect1: Rectangle(leftX: 1, topY: 1, width: 0, height: 0),
                                 rect2: Rectangle(leftX: 1, topY: 1, width: 3, height: 2)), nil)
        
        XCTAssertEqual(Rectangle(rect1: Rectangle(leftX: 0, topY: 0, width: 2, height: 2),
                                 rect2: Rectangle()), nil)
        
        XCTAssertEqual(Rectangle(rect1: Rectangle(),
                                 rect2: Rectangle(leftX: 0, topY: 0, width: 2, height: 2)), nil)
        
        XCTAssertEqual(Rectangle(rect1: Rectangle(), rect2: Rectangle()), nil)
    }
    
    
    func testEngine() {
        var engine = Engine()
        
        engine.addRectangle(Rectangle(leftX: 1, topY: 1, width: 3, height: 2))
        engine.addRectangle(Rectangle(leftX: 3, topY: 2, width: 1, height: 1))
        engine.addRectangle(Rectangle(leftX: 3, topY: 1, width: 1, height: 1))
        
        XCTAssertEqual(engine.rectangleCount, 3)
        XCTAssertEqual(engine.allIntersections.count, 2)
        
        XCTAssertEqual(engine.allIntersections[0], Rectangle(leftX: 3, topY: 1, width: 1, height: 1))
        XCTAssertEqual(engine.allIntersections[1], Rectangle(leftX: 3, topY: 2, width: 1, height: 1))
        
        engine.resizeRectangle(pos: 2, to: Rectangle(leftX: 5, topY: 3, width: 1, height: 1))
        
        XCTAssertEqual(engine.rectangleCount, 3)
        XCTAssertEqual(engine.allIntersections.count, 1)
        
        XCTAssertEqual(engine.allIntersections[0], Rectangle(leftX: 3, topY: 2, width: 1, height: 1))
    }
}
