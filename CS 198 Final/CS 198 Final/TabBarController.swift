//
//  TabBarController.swift
//  CS 198 Final
//
//  Created by Abril & Aquino on 11/12/2018.
//  Copyright © 2018 Abril & Aquino. All rights reserved.
//

import UIKit

class TabBarController : UITabBarController {
    
    override func viewDidLoad() {
        self.tabBar.items![1].isEnabled = false
        self.tabBar.items![2].isEnabled = false
    }
    
}
