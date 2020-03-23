//
//  UIColor+Extension.swift
//  KMLive
//
//  Created by momo on 2020/3/19.
//  Copyright © 2020 kimReboot. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) {
        self.init(red:r/255.0, green:g/255.0, blue:b/255.0, alpha:a)
    }
}
