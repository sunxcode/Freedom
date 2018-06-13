//
//  JFLoginViewController.swift
//  Freedom

import UIKit
import BaseFile
import XExtension
class JFLoginBtnCell:BaseTableViewCell{


}
class JFLoginViewController: IqiyiBaseViewController {
    func initView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH), style: .plain) as! BaseTableView
        tableView.delegate = self
        tableView.dataSource = self
        //将系统的Separator左边不留间隙
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        view.backgroundColor = RGBAColor(249, 249, 249,1)
    }
    
    func initNav() {
        navigationController?.navigationBar.isHidden = false
        title = "登陆"
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"cellLeft"), style: .plain) {

            self.navigationController?.popViewController(animated: true)
        }
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70
        } else {
            return 180
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let ID = "JFLoginBtnCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID) as? JFLoginBtnCell
            if cell == nil {
                // 从xib中加载cell
                cell = JFLoginBtnCell(style: .default, reuseIdentifier: ID)
                cell?.backgroundColor = UIColor.red
            }
            cell?.selectionStyle = .none
        return cell!

    }
}
