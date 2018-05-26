//
//  UIRectangleView.swift
//  Rectangles
//
//  Created by Jacopo Mangiavacchi on 5/24/18.
//  Copyright © 2018 Jacopo Mangiavacchi. All rights reserved.
//

import UIKit

class UIRectangleView : UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tagLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("UIRectangleView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
