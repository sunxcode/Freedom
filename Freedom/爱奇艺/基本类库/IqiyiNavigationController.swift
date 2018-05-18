//
//  IqiyiNavigationController.swift
//  Freedom

import UIKit

class IqiyiNavigationController: XBaseNavigationViewController {
    view.backgroundColor = UIColor.white
    navigationBar.isTranslucent = false
    //不是半透明
    navigationBar.titleTextAttributes = [
    NSForegroundColorAttributeName : UIColor.white,
    NSFontAttributeName : Font(16)
    ]
    navigationBar.barTintColor = RGBCOLOR(47, 47, 47)
    if (Double(UIDevice.current.systemVersion) ?? 0.0 >= 7.0) {
    edgesForExtendedLayout = []
    //视图控制器，四条边不指定
    extendedLayoutIncludesOpaqueBars = false
    //不透明的操作栏
    modalPresentationCapturesStatusBarAppearance = false
    UINavigationBar.appearance().setBackgroundImage(UIImage(named: ""), for: .top, barMetrics: .default)
    } else {
    navigationBar.setBackgroundImage(UIImage(named: ""), for: .default)
    }

}
