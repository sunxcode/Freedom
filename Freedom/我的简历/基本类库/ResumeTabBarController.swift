//
//  ResumeTabBarController.swift
//  Freedom
//
//  Created by htf on 2018/5/15.
//  Copyright © 2018年 薛超. All rights reserved.
//

import UIKit
class ResumeTabBarController: XBaseTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = .white
        let barItem = UITabBarItem.appearance()
        barItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.gray,NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 12)], for: .normal)
        barItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.red,NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 12)], for: .selected)
        for vc in self.childViewControllers{
            vc.tabBarItem.image = vc.tabBarItem.image?.withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.selectedImage = vc.tabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal)
        }
    }
}
