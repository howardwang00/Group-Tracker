//
//  UIColor.swift
//  Group-Connect
//
//  Created by Howard Wang on 8/2/17.
//  Copyright © 2017 Howard Wang. All rights reserved.
//

import UIKit

extension UIColor {
    enum Blue: Int {
        case bright = 0x00CAFF,
        medBright = 0x00B6E5,
        medium = 0x0098BF,
        medDark = 0x00657F,
        dark = 0x003340
    }
    
    convenience init(blueTint: Blue, opaque: CGFloat = 1.0) {
        let color = blueTint.rawValue
        let red = (color & 0xFF0000) >> 16
        let green = (color & 0x00FF00) >> 8
        let blue = color & 0x0000FF
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: opaque)
    }
    
}
