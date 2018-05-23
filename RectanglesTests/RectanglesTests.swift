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
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
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
    
}
