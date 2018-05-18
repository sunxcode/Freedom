//
//  JFWatchRecordViewController.swift
//  Freedom

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
