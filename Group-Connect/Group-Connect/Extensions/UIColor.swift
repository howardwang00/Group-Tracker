//
//  UIColor.swift
//  Group-Connect
//
//  Created by Howard Wang on 8/2/17.
//  Copyright © 2017 Howard Wang. All rights reserved.
//

import UIKit

extension UIColor {
    enum Green: Int {
        case bright = 0x27FF55,
        medBright = 0x23E54C,
        medium = 0x1DBF3F,
        medDark = 0x137F2A,
        dark = 0x0A4015
    }
    
    convenience init(tint: Green, opaque: CGFloat = 1.0) {
        let color = tint.rawValue
        let red = (color & 0xFF0000) >> 16
        let green = (color & 0x00FF00) >> 8
        let blue = color & 0x0000FF
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: opaque)
    }
    
}
