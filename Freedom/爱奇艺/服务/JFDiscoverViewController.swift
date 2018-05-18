//
//  JFDiscoverViewController.swift
//  Freedom
//
//  Created by htf on 2018/5/17.
//  Copyright © 2018年 薛超. All rights reserved.
//

import UIKit
import BaseFile
import XExtension
class JFDiscoverModel: NSObject {
    var group_number: NSNumber?
    var title = ""
    var items = [AnyHashable]()
    var skip_url = ""
    var sub_title = ""
    var module_icon = ""
    var sub_type = ""
    var group_location: NSNumber?
}
class JFDiscoverCell:BaseTableViewCell{
    convenience init(tableView: UITableView?) {
        let ID = "JFDiscoverCell"
        var cell = tableView?.dequeueReusableCell(withIdentifier: ID) as? JFDiscoverCell
        if cell == nil {
            cell = JFDiscoverCell(style: .default, reuseIdentifier: ID)
        }
        cell?.selectionStyle = .none
        return cell ?? JFDiscoverCell()
    }
    
    func setDiscoverModel(_ discoverModel: JFDiscoverModel?) {
        self.discoverModel = discoverModel
        textLabel?.text = discoverModel?.title
        imageView?.sd_setImage(with: URL(string: discoverModel?.module_icon ?? ""), placeholderImage: UIImage(named: PcustomService_y))
    }

}
class JFDiscoverViewController: IqiyiBaseViewController {
    //  The converted code is limited to 1 KB.
    //  Please Sign Up (Free!) to remove this limitation.
    //
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    func viewDidLoad() {
        super.viewDidLoad()
        let w: CGFloat = APPW * 0.8
        let searchButton = UIButton(type: .custom)
        searchButton.imageView?.contentMode = .center
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        searchButton.setTitleColor(UIColor.black, for: .normal)
        searchButton.frame = CGRect(x: 0, y: 0, width: w, height: 30)
        searchButton.setBackgroundImage(UIImage(named: "GroupCell"), for: .normal)
        searchButton.setImage(UIImage(named: Psearch_small), for: .normal)
        searchButton.setTitle("请输入：港囧，夏洛特烦恼，徐峥等", for: .normal)
        searchButton.addTarget(self, action: #selector(self.searchButtonClick), for: .touchUpInside)
        searchButton.setTitleColor(UIColor.gray, for: .normal)
        navigationItem?.leftBarButtonItem = UIBarButtonItem(customView: searchButton)
        let rightItem = UIBarButtonItem(normalImage: Pwnavi, target: self, action: nil, width: 25, height: 25)
        navigationItem?.rightBarButtonItem = rightItem
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH - 64), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        //将系统的Separator左边不留间隙
        tableView.separatorInset = UIEdgeInsetsZero
        discoverTableView = tableView
        view.addSubview(discoverTableView)
        discoverTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {() -> Void in
            dataSource = [AnyHashable]()
            imageArray = [AnyHashable]()
            let urlStr = FreedomTools.shared().urlWithDiscoverData()
        })
        discoverTableView.mj_header.beginRefreshing()
    }
    func searchButtonClick() {
        let searchVC = JFSearchHistoryViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 280
        } else {
            return 40
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = JFImageScrollCell(tableView: tableView, frame: CGRect(x: 0, y: 0, width: APPW, height: 280))
            cell.imageArray = imageArray
            cell.imageScrollView.delegate = self
            return cell
        } else {
            let cell = JFDiscoverCell(tableView: tableView)
            cell.discoverModel = dataSource[indexPath.row]
            return cell
        }
        return nil
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            let webVC = JFWebViewController()
            webVC.urlStr = FreedomTools.shared().urlWithJianShuData()
            navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    // MARK: - JFImageScrollViewDelegate
    func didSelectImage(at index: Int) {
        let disM: JFDiscoverModel? = dataSource[0]
        let code = disM?.items[index]["video_id"] as? String
        let videoVC = JFVideoDetailViewController()
        videoVC.iid = code
        navigationController?.pushViewController(videoVC, animated: true)
    }

        
}
