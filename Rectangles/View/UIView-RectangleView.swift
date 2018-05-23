//
//  UIView-RectangleView.swift
//  Rectangles
//
//  Created by Jacopo Mangiavacchi on 5/23/18.
//  Copyright © 2018 Jacopo Mangiavacchi. All rights reserved.
//

import UIKit

extension UIView : RectangleView {
    var rectangle: Rectangle {
        get {
            return Rectangle(leftX: Float(self.frame.origin.x),
                             topY: Float(self.frame.origin.y),
                             width: Float(self.frame.width),
                             height: Float(self.frame.height))
        }
        set(rect) {
            self.frame = CGRect(x: CGFloat(rect.leftX),
                                y: CGFloat(rect.topY),
                                width: CGFloat(rect.width),
                                height: CGFloat(rect.height))
        }
    }
}
