//
//  TaobaoMiniViewController.swift
//  Freedom
//
//  Created by htf on 2018/5/17.
//  Copyright © 2018年 薛超. All rights reserved.
//

import UIKit

class TaobaoMiniViewController: TaobaoBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //  The converted code is limited to 1 KB.
    //  Please Sign Up (Free!) to remove this limitation.
    //
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    func viewDidLoad() {
        super.viewDidLoad()
        let leftI = UIBarButtonItem(image: UIImage(named: "TaobaoScanner@2x"), style: .done, actionBlick: {() -> Void in
        })
        let rightI = UIBarButtonItem(image: UIImage(named: "TaobaoScanner@2x"), style: .done, actionBlick: {() -> Void in
        })
        let rightII = UIBarButtonItem(image: UIImage(named: "TaobaoScanner@2x"), style: .done, actionBlick: {() -> Void in
        })
        navigationItem?.leftBarButtonItem = leftI
        navigationItem?.rightBarButtonItems = [rightI, rightII]
        title = "微淘"
        let titles = ["动态", "上新", "视频", "热文", "话题榜"]
        let icons = ["taobaomini1", "taobaomini2", "taobaomini3", "taobaomini4", "taobaomini5"]
        let controllers = ["TaobaoMiniDynamicViewController", "TaobaoMiniNewViewController", "TaobaoMiniVideoViewController", "TaobaoMiniArticleViewController", "TaobaoMiniTopicViewController"]
        TaobaoMiniScrollV = BaseScrollOCView.sharedContentIconView(withFrame: CGRect(x: 0, y: 0, width: APPW, height: Int(APPH - TabBarH) - 55), titles: titles, icons: icons, controllers: controllers, inViewController: self)
        TaobaoMiniScrollV.selectBlock = {(_ index: Int, _ dict: [AnyHashable: Any]?) -> Void in
            DLog("点击了%ld,%@", index, dict)
        }
        TaobaoMiniScrollV.selectThePage(3)
    }

}
