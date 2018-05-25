//
//  UIRectangleView.swift
//  Rectangles
//
//  Created by Jacopo Mangiavacchi on 5/24/18.
//  Copyright © 2018 Jacopo Mangiavacchi. All rights reserved.
//

import UIKit

class UIRectangleView : UIView {
    override func draw(_ rect: CGRect) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left

        let attributes = [
            NSAttributedStringKey.paragraphStyle: paragraphStyle,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0),
            NSAttributedStringKey.foregroundColor: UIColor.black
        ]

        let attributedString = NSAttributedString(string: String(format: "%d", self.tag + 1),
                                                  attributes: attributes)

        attributedString.draw(in: self.bounds)
    }
}
