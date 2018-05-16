//
//  MicroEnergyTabBarController.swift
//  Freedom
import UIKit
import XExtension
import BaseFile
class MicroEnergyTabBarController: XBaseTabBarController,UITabBarControllerDelegate {
    let myTabBar = EnergySuperMarketTabBarController.sharedRootViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = RGBAColor(R: 59, G: 59, B: 59, A: 1);
        myTabBar.hidesBottomBarWhenPushed = true
        myTabBar.superTabbar = self;
       var i=0
        for vc in self.childViewControllers{
             vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.red,NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 12)], for: .selected)
            vc.tabBarItem.image = vc.tabBarItem.image?.withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.selectedImage = vc.tabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.tag = i;
            i += 1
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag != 3{
            myTabBar.backTab = item.tag
        }else if let navi:EnergyNavigationController = childViewControllers[3] as? EnergyNavigationController{
            navi.pushViewController(myTabBar, animated: true)
        }
    }
}
