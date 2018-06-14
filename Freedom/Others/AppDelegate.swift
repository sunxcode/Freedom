//
//  AppDelegate.swift
//  Tes
//
//  Created by Super on 6/14/18.
//  Copyright © 2018 Super. All rights reserved.
//

import UIKit
import AVFoundation
import SDWebImage
//#import <ShareSDK/ShareSDK.h>
//＝＝＝＝＝＝＝＝＝＝以下是各个平台SDK的头文件，根据需要继承的平台添加＝＝＝
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/QQApiInterface.h>
//以下是腾讯SDK的依赖库：
//libsqlite3.dylib
//微信SDK头文件
//#import "WXApi.h"
//新浪微博SDK头文件
//#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
//人人SDK头文件
//#import <RennSDK/RennSDK.h>
//支付宝SDK
//#import "APOpenAPI.h"
//易信SDK头文件
//#import "YXApi.h"
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let taskID :UIBackgroundTaskIdentifier = 0
    let launchView: UIImageView = UIImageView()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        launchView.frame = (self.window?.bounds)!
        launchView.image = UIImage(named:"LaunchImage-700-568h")
        launchView.alpha = 1;
        self.window?.addSubview(launchView)
        self.window?.bringSubview(toFront: launchView)
        UIView.animate(withDuration: 1, delay: 1, options: UIViewAnimationOptions.transitionCurlDown, animations: {
            self.launchView.frame = CGRect(x: -80, y: -140, width: (self.window?.bounds.size.width)! + 160, height: (self.window?.bounds.size.height)! + 320)
            self.launchView.alpha = 0
        }) { (finished) in
            self.launchView.removeFromSuperview()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // 设置音频会话类型
//        let session :AVAudioSession = AVAudioSession.sharedInstance()
//        session.setActive(true)
//        session.setCategory(AVAudioSessionCategoryPlayback)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //禁止横屏
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        let mgr = SDWebImageManager.shared()
        mgr?.cancelAll()
        mgr?.imageCache.clearMemory()
    }

}

