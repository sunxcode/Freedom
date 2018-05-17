//
//  JFClassifyViewController.swift
//  Freedom
//
//  Created by htf on 2018/5/17.
//  Copyright © 2018年 薛超. All rights reserved.
//

import UIKit
import BaseFile
import XExtension
class JFClassifyModel: NSObject {
    var normal_icon_for_ipad_v_4 = ""
    var top_state: NSNumber?
    var selected_icon_for_v_4 = ""
    var tabs = [AnyHashable]()
    var image_at_bottom = ""
    var the_whole_state: NSNumber?
    var display_flag: NSNumber?
    var selected_icon = ""
    var label_top_state: NSNumber?
    var selected_icon_for_apad_v_4 = ""
    var normal_icon_for_apad_v_4 = ""
    var choiceness_state: NSNumber?
    var is_listing: NSNumber?
    var redirect_type = ""
    var channel_order_for_pad: NSNumber?
    var icon = ""
    var image_at_top = ""
    var show_operation: NSNumber?
    var display_flag_bak: NSNumber?
    var selected_icon_for_ipad_v_4_1_plus = ""
    var tagType: NSNumber?
    var label_tops = [AnyHashable]()
    var tabs_state: NSNumber?
    var young_app_launcher = ""
    var normal_icon_for_v_4 = ""
}
class JFClassifyCell: UITableViewCell {
    var classifyModel: JFClassifyModel?
    
    convenience init(tableView: UITableView?) {
        let ID = "JFClassifyCell"
        var cell = tableView?.dequeueReusableCell(withIdentifier: ID) as? JFClassifyCell
        if cell == nil {
            // 从xib中加载cell
            cell = JFClassifyCell(style: .default, reuseIdentifier: ID)
        }
        cell?.selectionStyle = .none
        if let aCell = cell {
            return aCell
        }
        return JFClassifyCell()
    }
}
func setClassifyModel(_ classifyModel: JFClassifyModel?) {
    self.classifyModel = classifyModel
    imageView?.sd_setImage(with: URL(string: classifyModel?.image_at_bottom ?? ""), placeholderImage: UIImage(named: "home_GaoXiao"))
    textLabel?.text = classifyModel?.name
}


class TEMPBASEC:BaseTableViewCell{
    override func initUI() {
        self.icon = UIImageView(frame: CGRect(x:0, y:0, width:0, height:120))
        self.title = UILabel(frame: CGRect(x:0, y:0, width:0, height: 20))
        self.addSubviews([self.title,self.icon])
        self.title.text = "name"
        self.icon.image = UIImage(named:"taobaomini2")
    }
}
class JFClassifyViewController: IqiyiBaseViewController {
    func viewDidLoad() {
        super.viewDidLoad()
        urlStr = FreedomTools.shared().urlWithclassifyData()
        dataSource = [AnyHashable]()
        initView()
        setUpRefresh()
    }
    
    // MARK: - 设置普通模式下啦刷新
    func setUpRefresh() {
        classifyTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {() -> Void in
            self.initData()
        })
        classifyTableView.mj_header.beginRefreshing()
    }
    func initView() {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH - 64), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        //将系统的Separator左边不留间隙
        tableView.separatorInset = UIEdgeInsetsZero
        classifyTableView = tableView
        view.addSubview(classifyTableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource {
            return dataSource.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JFClassifyCell(tableView: tableView)
        if dataSource {
            cell.classifyModel = dataSource[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = JFWebViewController()
        webVC.urlStr = FreedomTools.shared().urlWithJianShuData()
        navigationController?.pushViewController(webVC, animated: true)
    }


}
