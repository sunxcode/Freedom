//
//  ToutiaoTabBarController.swift
//  Freedom
//
//  Created by htf on 2018/5/16.
//  Copyright © 2018年 薛超. All rights reserved.
//

import UIKit

class ToutiaoTabBarController: XBaseTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .default
        for vc in self.childViewControllers{
            vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.red,NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 12)], for: .selected)
            vc.tabBarItem.image = vc.tabBarItem.image?.withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.selectedImage = vc.tabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal)
        }
    }
    


}
