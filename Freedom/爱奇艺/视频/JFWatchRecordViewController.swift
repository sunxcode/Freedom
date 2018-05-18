//
//  JFWatchRecordViewController.swift
//  Freedom
//
//  Created by htf on 2018/5/17.
//  Copyright © 2018年 薛超. All rights reserved.
//

import UIKit

class JFWatchRecordViewController: IqiyiBaseViewController {
    func initNav() {
        title = "观看纪录"
        navigationController?.navigationBar.isHidden = false
        let leftBarButtonItem = UIBarButtonItem(normalImage: "ic_player_back", target: self, action: #selector(self.leftBarButtonItemClick), width: 35, height: 35)
        navigationItem?.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func leftBarButtonItemClick() {
        navigationController?.popViewController(animated: true)
}
}
