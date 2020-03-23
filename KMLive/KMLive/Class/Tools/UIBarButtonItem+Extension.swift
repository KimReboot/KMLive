//
//  UIBarButtonItem+Extension.swift
//  KMLive
//
//  Created by momo on 2020/3/18.
//  Copyright © 2020 kimReboot. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    // 扩展类方法
//    class func creatItem(imageName: String, highImageName: String, size: CGSize) {
//
//    }
    
    // 扩展构造函数
    convenience init(imageName: String, highImageName: String = "", size: CGSize = CGSize()) {
        
        let button = UIButton()
        button.setImage(UIImage(named: imageName), for: .normal)
        button.setImage(UIImage(named: highImageName), for: .highlighted)
        button.frame = CGRect(origin: CGPoint(), size: size)
                
        self.init(customView: button)
    }
}


