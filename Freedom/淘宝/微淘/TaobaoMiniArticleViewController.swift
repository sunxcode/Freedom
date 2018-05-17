//
//  TaobaoMiniArticleViewController.swift
//  Freedom
//
//  Created by htf on 2018/5/17.
//  Copyright © 2018年 薛超. All rights reserved.
//

import UIKit
import BaseFile
import XExtension
class TEMPBASEC:BaseTableViewCell{
    override func initUI() {
        self.icon = UIImageView(frame: CGRect(x:0, y:0, width:0, height:120))
        self.title = UILabel(frame: CGRect(x:0, y:0, width:0, height: 20))
        self.addSubviews([self.title,self.icon])
        self.title.text = "name"
        self.icon.image = UIImage(named:"taobaomini2")
    }
}
class TaobaoMiniArticleViewController: TaobaoBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: APPW, height: view.frameHeight - 20), style: .plain)
        dataArray = ["b", "a", "v", "f", "d", "a", "w", "u", "n", "o", "2"]
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }

}
