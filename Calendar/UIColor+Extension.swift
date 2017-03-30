//
//  UIColor+Extension.swift
//  Calendar
//
//  Created by hzf on 16/11/1.
//  Copyright © 2016年 hzf. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    
    convenience init(rgb: UInt) {
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let green = CGFloat((rgb & 0xFF00) >> 8) / 255
        let blue = CGFloat((rgb & 0xFF)) / 255
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    convenience init(rgba: UInt) {
        let red     = CGFloat((rgba & 0xFF000000) >> 24) / 255
        let green   = CGFloat((rgba & 0xFF0000) >> 16) / 255
        let blue    = CGFloat((rgba & 0xFF00) >> 8) / 255
        let alpha   = CGFloat((rgba & 0xFF)) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
