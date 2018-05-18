//
//  DianpingTabBarController.swift
//  Freedom
import UIKit
class DianpingTabBarController: XBaseTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        for vc in self.childViewControllers{
            vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.red,NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 12)], for: .selected)
            vc.tabBarItem.image = vc.tabBarItem.image?.withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.selectedImage = vc.tabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal)
        }
    }

}
