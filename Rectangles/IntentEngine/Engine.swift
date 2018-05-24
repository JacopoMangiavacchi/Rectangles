//
//  Engine.swift
//  Rectangles
//
//  Created by Jacopo Mangiavacchi on 5/24/18.
//  Copyright © 2018 Jacopo Mangiavacchi. All rights reserved.
//

import Foundation

protocol Engine {
    mutating func fullFill(intent: String, parameters: [String : Any]?, completition: ((_ sayText: String, _ displayText: String, _ forceClose: Bool) -> Void)?)
}
