//
//  XBaseViewController.swift
//  Freedom
//
//  Created by Super on 2018/5/15.
//  Copyright © 2018年 Super. All rights reserved.
//

import UIKit
import BaseFile
import XExtension
import SVProgressHUD
class XBaseViewController: BaseViewController,CKRadialMenuDelegate{
    var cellHeight:CGFloat = 0.0
    let radialView:CKRadialMenu = CKRadialMenu(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    var items:[[String:String]] = FreedomItems
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        edgesForExtendedLayout = UIRectEdge.all;
        let appearance = UINavigationBar.appearance()
        appearance.backIndicatorImage = UIImage(named:"u_cellLeft")?.withRenderingMode(.alwaysOriginal);
        appearance.backIndicatorTransitionMaskImage = UIImage(named:"u_cellLeft")?.withRenderingMode(.alwaysOriginal);
        let backItem: UIBarButtonItem = UIBarButtonItem()
        backItem.title = "返回"
        self.navigationItem.backBarButtonItem = backItem;
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    func radialMenu(_ radialMenu: CKRadialMenu!, didSelectPopoutWithIndentifier identifier: String!) {
        print("代理通知发现点击了控制器%@", identifier)
        radialMenu.didTapCenterView(nil)
        UIApplication.shared.isStatusBarHidden = false
        let a: Int = Int(identifier)!
        let controlName:String = items[a]["control"]!
        let StoryBoard = UIStoryboard(name: controlName, bundle: nil)
        let con = StoryBoard.instantiateViewController(withIdentifier:"\(controlName)TabBarController")
        let animation = CATransition()
        animation.duration = 0.5
        animation.type = "cube"
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        view.window?.layer.add(animation, forKey: nil)
        let win: UIWindow? = UIApplication.shared.keyWindow
        win?.rootViewController = con
        win?.makeKeyAndVisible()
        SVProgressHUD.showSuccess(withStatus: "\(items[a]["title"]!)")
    }
    func configRadialView() {
        for i in 0..<items.count {
            let a = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            a.image = UIImage(named: items[i]["icon"]!)
            radialView.addPopoutView(a, withIndentifier: "\(i)")
        }
        radialView.enableDevelopmentMode()
        radialView.distanceBetweenPopouts = 2 * 180 / CGFloat(items.count)
        radialView.delegate = self
    }
    func showRadialMenu() {
        if radialView.superview == nil {
            if radialView.delegate == nil {
                configRadialView()
            }
            radialView.center = view.center
            let win: UIWindow? = UIApplication.shared.keyWindow
            win?.addSubview(radialView)
            win?.bringSubview(toFront: radialView)
        } else {
            radialView.removeFromSuperview()
        }
    }
    // 开始摇一摇
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        showRadialMenu()
    }
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion != .motionShake {
            return
        }
        print("结束摇一摇")
    }
    override func motionCancelled(_ motion: UIEventSubtype, with event: UIEvent?) {
        print("取消摇一摇")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
//    常见变换类型（type）
//    kCATransitionFade//淡出
//    kCATransitionMoveIn//覆盖原图
//    kCATransitionPush  //推出
//    kCATransitionReveal//底部显出来
//SubType:
//    kCATransitionFromRight
//    kCATransitionFromLeft// 默认值
//    kCATransitionFromTop
//    kCATransitionFromBottom
//(type):
//    pageCurl   向上翻一页
//    pageUnCurl 向下翻一页
//    rippleEffect 滴水效果
//    suckEffect 收缩效果
//    cube 立方体效果
//    oglFlip 上下翻转效果
