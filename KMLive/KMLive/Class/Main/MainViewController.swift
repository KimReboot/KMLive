//
//  MainViewController.swift
//  KMLive
//
//  Created by momo on 2020/3/16.
//  Copyright © 2020 kimReboot. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildVC(stroyboadName: "Home")
        addChildVC(stroyboadName: "Live")
        addChildVC(stroyboadName: "Follow")
        addChildVC(stroyboadName: "Profile")
    }
    
    func addChildVC(stroyboadName:String) -> Void {
        let childVC = UIStoryboard(name: stroyboadName, bundle: nil).instantiateInitialViewController()!
        addChild(childVC)
    }
}
