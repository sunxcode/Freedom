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
import Realm
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
    var apps = [XAPP]()
    static let radialView:CKRadialMenu = CKRadialMenu(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    lazy var items:[[String:String]] = {
        let path = Bundle.main.path(forResource: "FreedomItems", ofType: "plist")!
        let tempItems = NSMutableArray(contentsOfFile: path) as! [[String : String]]
        return tempItems
    }()
    func configRadialView() {
        for i in 0..<items.count {
            let a = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            a.image = UIImage(named: items[i]["icon"]!)
            AppDelegate.radialView.addPopoutView(a, withIndentifier: "\(i)")
        }
        AppDelegate.radialView.didSelectBlock = {(menu : CKRadialMenu, didExpand:Bool, didRetract:Bool,identifier:String?) -> Void in
            if didExpand{
            }else if didRetract{
            }else{
                print("代理通知发现点击了控制器\(identifier!)")
                let a: Int = Int(identifier!)!
                if a >= 100{
                    let app = self.apps[a - 100];
                    let appman = AppManager.sharedInstance()
                    appman?.openApp(withBundleIdentifier: app.bundleId)
                }else{
                    menu.retract()
                    UIApplication.shared.isStatusBarHidden = false
                    let controlName:String = self.items[a]["control"]!
                    let StoryBoard = UIStoryboard(name: controlName, bundle: nil)
                    let con = StoryBoard.instantiateViewController(withIdentifier:"\(controlName)TabBarController")
                    let animation = CATransition()
                    animation.duration = 0.5
                    animation.type = "cube"
                    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    self.window?.layer.add(animation, forKey: nil)
                    self.window?.rootViewController = con
                    self.window?.makeKeyAndVisible()
                }
            }
        }
    }
    @objc func showRadialMenu() {
        if AppDelegate.radialView.superview == nil {
            AppDelegate.radialView.center = (window?.center)!
            window?.addSubview(AppDelegate.radialView)
            window?.bringSubview(toFront:AppDelegate.radialView)
        } else {
            AppDelegate.radialView.removeFromSuperview()
        }
    }
    
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
        self.firstInit()
        return true
    }
    func firstInit(){
        let appInfo = Bundle.main.infoDictionary
        let versionStr = (appInfo!["CFBundleVersion"] as! String).replacingOccurrences(of: ".", with: "")
        let version = UInt64(versionStr)
        let config : RLMRealmConfiguration = RLMRealmConfiguration.default()
        config.schemaVersion = version!;
        config.migrationBlock = {(migration:RLMMigration,oldSchemaVersion:UInt64) in
            if oldSchemaVersion < 1{
                print("OK")
            }
        }
        RLMRealmConfiguration.setDefault(config)
        RLMRealm.default()
        configRadialView()
        let userDefault = UserDefaults.standard
        let isNotFirst = false//userDefault.bool(forKey: "first")
        if !isNotFirst {
            var allAPPids = [String]();
//            userDefault.set(true, forKey: "first")
//            userDefault.synchronize()
//            let path = Bundle.main.path(forResource: "app", ofType: "plist")
//            let allAPPDict :[String:String] = NSDictionary(contentsOfFile: path!) as! [String : String]
//            for (key,value) in allAPPDict{
//                autoreleasepool {
//                    let application = UIApplication.shared
//                    let url = URL(string:value)
//                    if let urla = url{
//                        if application.canOpenURL(urla){
//                            allAPPids.append(key)
//                        }
//                    }
//                }
//            }
            print(allAPPids)
            allAPPids = ["472208016", "481294264", "512166629", "547166701", "444934666", "310633997", "461703208", "416789970", "398453262", "333206289", "577130046", "284882215", "525463029", "454638411", "364787363", "518966501", "1110145109", "414478124", "364709193", "414706506", "932723216", "466122094", "376101648", "861891048", "414245413"]
            let appMan = AppManager.sharedInstance()
            appMan?.gotiTunesInfo(withTrackIds: allAPPids, completion: { apps in
//                let realm = RLMRealm.default()
//                realm.beginWriteTransaction()
//                realm.addOrUpdateObjects(apps! as NSFastEnumeration)
                DispatchQueue.main.async {
                    self.apps = apps!
                var popoutViews = [UIView]()
                for xapp in self.apps{
                        let a = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                        a.image = xapp.icon
                        popoutViews.append(a)
                    print(xapp.trackName)
                }
                AppDelegate.radialView.addPopoutViews(popoutViews)

                }
            })
//            let real = try! RLMRealm()
//            real.addObjects([RLMObject()])
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // 设置音频会话类型
//        let session :AVAudioSession = AVAudioSession.sharedInstance()
//        session.setActive(true)
//        session.setCategory(AVAudioSessionCategoryPlayback)
    }
    func applicationDidEnterBackground(_ application: UIApplication) {

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
