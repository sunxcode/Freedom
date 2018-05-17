//
//  DZDiscoverController.swift
//  Freedom
//
//  Created by htf on 2018/5/17.
//  Copyright © 2018年 薛超. All rights reserved.
//

import UIKit

class DZDiscoverController: DianpingBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func buildUI() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "输入商户名、地点"
        navigationItem?.titleView = searchBar
        view.backgroundColor = UIColor.white
        let map = UIBarButtonItem(title: "北京", style: .plain, actionBlick: {() -> Void in
        })
        navigationItem?.leftBarButtonItem = map
        let titles = ["精选", "嗨周末", "变漂亮", "潮餐厅", "出去浪", "探店报告"]
        let controllers = ["DZDealListViewController", "DZDealListViewController", "DZDealListViewController", "DZDealListViewController", "DZDealListViewController", "DZDealListViewController"]
        contentScrollView = BaseScrollOCView.sharedContentTitleView(withFrame: CGRect(x: 0, y: 0, width: APPW, height: APPH - 55), titles: titles, controllers: controllers, inViewController: self)
        contentScrollView.selectBlock = {(_ index: Int, _ dict: [AnyHashable: Any]?) -> Void in
            DLog("点击了%ld,%@", index, dict)
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
