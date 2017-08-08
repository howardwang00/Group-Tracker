//
//  UIColor.swift
//  Group-Connect
//
//  Created by Howard Wang on 8/2/17.
//  Copyright © 2017 Howard Wang. All rights reserved.
//

import UIKit

extension UIColor {
    enum Color: Int {
        case green = 0x0DFFAC,
        blueGreen = 0x0CE8DB,
        skyBlue = 0x00CAFF,
        lightBlue = 0x0C81E8,
        blue = 0x0D4EFF
    }
    
    convenience init(color: Color, opaque: CGFloat = 1.0) {
        let color = color.rawValue
        let red = (color & 0xFF0000) >> 16
        let green = (color & 0x00FF00) >> 8
        let blue = color & 0x0000FF
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: opaque)
    }
    
}
