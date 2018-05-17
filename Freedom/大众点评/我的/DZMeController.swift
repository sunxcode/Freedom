//
//  DZMeController.swift
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
class DZMeController: DianpingBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func buildTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        //增加底部额外的滚动区域
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
        //去掉cell分割线
        //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //24bit颜色 RGB（红绿蓝）
        //32bit颜色 ARGB
    }
    func loadPlist() {
        //1.获取路径
        let url: URL? = Bundle.main.url(forResource: "DianpingWo", withExtension: "plist")
        //2.读取数据
        if let anUrl = url {
            data = NSArray(contentsOf: anUrl)
        }
    }
    func buildUI() {
        title = "我的"
        //设置右上角按钮
        let send = UIBarButtonItem(image: UIImage(renderingOriginalName: "personal_icon_send@2x"), style: .plain, target: self, action: #selector(self.sendMessage))
        navigationItem?.rightBarButtonItem = send
        //设置左上角按钮
        let service = UIBarButtonItem(title: "联系客服", style: .plain, target: self, action: #selector(self.serviceAction))
        navigationItem?.leftBarButtonItem = service
    }
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    func sendMessage() {
        DLog("消息")
    }
    
    // MARK: 联系客服
    func serviceAction() {
        DLog("联系客服")
    }
    
    // MARK: - Table View data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count()
    }
    
    //设置tableView每组头部的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 75
        } else {
            return 0
        }
    }
    //  The converted code is limited to 1 KB.
    //  Please Sign Up (Free!) to remove this limitation.
    //
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 5))
            //        headerView.backgroundColor = [UIColor greenColor];
            if let aNamed = UIImage(named: "bg_login") {
                headerView.backgroundColor = UIColor(patternImage: aNamed)
            }
            //头像
            let userImage = UIImageView(frame: CGRect(x: 10, y: 10, width: 55, height: 55))
            userImage.layer.masksToBounds = true
            userImage.layer.cornerRadius = 27
            userImage.image = UIImage(named: PuserLogo)
            headerView.addSubview(userImage)
            //用户名
            let userNameLabel = UILabel(frame: CGRect(x: 10 + 55 + 5, y: 15, width: 200, height: 30))
            userNameLabel.font = UIFont.systemFont(ofSize: 13)
            //账户余额
            let moneyLabel = UILabel(frame: CGRect(x: 10 + 55 + 5, y: 40, width: 200, height: 30))
            moneyLabel.font = UIFont.systemFont(ofSize: 13)
            moneyLabel.text = "余额：0.00元"
            headerView.addSubview(moneyLabel)
            let arrowImg = UIImageView(frame: CGRect(x: APPW - 10 - 24, y: 30, width: 12, height: 24))
            arrowImg.image = UIImage(named: "icon_mine_accountViewRightArrow")
            headerView.addSubview(arrowImg)
            return headerView
        } else {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 5))
            headerView.backgroundColor = RGBCOLOR(239, 239, 244)
            return headerView
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        //forIndexPath:indexPath 跟 storyboard 配套使用
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        //Configure the cell ...
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        //取出这一行对应的字典数据
        let dict = data[indexPath.section][indexPath.row]
        cell?.textLabel?.text = dict["name"] as? String
        cell?.imageView?.image = UIImage(named: dict["icon"] as? String ?? "")
        cell?.textLabel?.backgroundColor = UIColor.clear
        cell?.selectionStyle = .none
        cell?.accessoryType = .disclosureIndicator
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
        }
    
    
}
