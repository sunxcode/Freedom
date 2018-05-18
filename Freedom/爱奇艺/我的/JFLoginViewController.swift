//
//  JFLoginViewController.swift
//  Freedom
//
//  Created by htf on 2018/5/17.
//  Copyright © 2018年 薛超. All rights reserved.
//

import UIKit
import BaseFile
import XExtension
class JFLoginBtnCell:BaseTableViewCell{
    convenience init(tableView: UITableView?) {
        let ID = "JFLoginBtnCell"
        var cell = tableView?.dequeueReusableCell(withIdentifier: ID) as? JFLoginBtnCell
        if cell == nil {
            // 从xib中加载cell
            cell = JFLoginBtnCell(style: .default, reuseIdentifier: ID)
            cell?.backgroundColor = UIColor.red
        }
        cell?.selectionStyle = .none
        return cell ?? JFLoginBtnCell()
    }
    
    @objc func loginBtnClick(_ sender: Any?) {
        if delegate.responds(to: Selector("loginBtnClick:")) {
            delegate.loginBtnClick(sender)
        }
    }
    
    func xinlanWeiboBtnClick(_ sender: Any?) {
        if delegate.responds(to: Selector("loginBtnClick:")) {
            delegate.loginBtnClick(sender)
        }
    }

}
class JFLoginViewController: IqiyiBaseViewController {
    func initView() {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        //将系统的Separator左边不留间隙
        tableView.separatorInset = UIEdgeInsetsZero
        loginTableView = tableView
        loginTableView.separatorStyle = .none
        view.addSubview(loginTableView)
        view.backgroundColor = RGBCOLOR(249, 249, 249)
    }
    
    func initNav() {
        navigationController?.navigationBar.isHidden = false
        title = "登陆"
        let leftBarButtonItem = UIBarButtonItem(normalImage: PcellLeft, target: self, action: #selector(self.leftBarButtonItemClick), width: 35, height: 35)
        navigationItem?.leftBarButtonItem = leftBarButtonItem
    }
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    func leftBarButtonItemClick() {
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70
        } else {
            return 180
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = JFTextFieldCell(tableView: tableView)
            return cell
        } else {
            let cell = JFLoginBtnCell(tableView: tableView)
            cell.delegate = self
            return cell
        }
    }
}
