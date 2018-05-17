//
//  DZDealController.swift
//  Freedom
//
//  Created by htf on 2018/5/17.
//  Copyright © 2018年 薛超. All rights reserved.
//

import UIKit

class DZDealController: DianpingBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        func buildUI() {
            view.backgroundColor = UIColor.white
            let map = UIBarButtonItem(title: "北京", style: .plain, actionBlick: {() -> Void in
            })
            navigationItem?.leftBarButtonItem = map
            navigationItem?.title = "团购"
            let titles = ["精选", "享美食", "点外卖", "看电影", "趣休闲"]
            let controllers = ["DZDealListViewController", "DZDealListViewController", "DZDealListViewController", "DZDealListViewController", "DZDealListViewController"]
            contentScrollView = BaseScrollOCView.sharedContentTitleView(withFrame: CGRect(x: 0, y: 0, width: APPW, height: APPH - 100), titles: titles, controllers: controllers, inViewController: self)
            contentScrollView.selectBlock = {(_ index: Int, _ dict: [AnyHashable: Any]?) -> Void in
                DLog("点击了%ld,%@", index, dict)
            }
        }

    }

}
