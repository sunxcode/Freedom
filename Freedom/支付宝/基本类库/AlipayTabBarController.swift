//
//  AlipayTabBarController.swift
//  Freedom
//
//  Created by htf on 2018/5/17.
//  Copyright © 2018年 薛超. All rights reserved.
//

import UIKit

class AlipayTabBarController: XBaseTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        for vc in self.childViewControllers{
            vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.red,NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 12)], for: .selected)
            vc.tabBarItem.image = vc.tabBarItem.image?.withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.selectedImage = vc.tabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
