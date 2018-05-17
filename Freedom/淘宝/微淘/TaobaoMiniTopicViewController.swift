//
//  TaobaoMiniTopicViewController.swift
//  Freedom
//
//  Created by htf on 2018/5/17.
//  Copyright © 2018年 薛超. All rights reserved.
//

import UIKit
import BaseFile
import XExtension
class TaobaoMiniTopicViewCell:BaseTableViewCell{
    func initUI() {
        super.initUI()
        icon.frame = CGRect(x: 10, y: 10, width: 70, height: 70)
        title.frame = CGRect(x: XW(icon) + 10, y: Y(icon), width: APPW - XW(icon) - 10, height: 20)
        script.frame = CGRect(x: X(title), y: YH(title) + 10, width: W(title), height: 20)
        sees = UILabel(frame: CGRect(x: X(script), y: YH(script), width: W(script), height: 15), font: Font(12), color: graycolor, text: nil)
        line.frame = CGRect(x: 0, y: 90 - 1, width: APPW, height: 1)
        DLog("==%lf", H(self))
        addSubviews(sees, nil)
    }
    func setDataWithDict(_ dict: [AnyHashable: Any]?) {
        icon.image = UIImage(named: "mini5")
        title.text = "韩国年度榜"
        script.text = "主持人：全球购买手小队长"
        sees.text = "热度：79570  参与人：100"
    }

}
class TaobaoMiniTopicViewController: TaobaoBaseViewController {
    func viewDidLoad() {
        super.viewDidLoad()
        let banner = BaseScrollOCView(frame: CGRect(x: 0, y: 0, width: APPW, height: 120))
        let param = [
            "type" : "1"
        ]
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: APPW, height: view.frameHeight - 20), style: .plain)
        dataArray = ["b", "a", "v", "f", "d", "a", "w", "u", "n", "o", "2"]
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
}
