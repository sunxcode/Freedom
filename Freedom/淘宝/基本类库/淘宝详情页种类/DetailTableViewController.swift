//
//  DetailTableViewController.swift
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
class DetailTableViewController: TaobaoBaseViewController {
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    private var titles = ["图文详情", "商品评论", "店铺推荐"]
    private var urls = ["http://m.b5m.com/item.html?tid=2614676&mps=____&type=content", "http://m.b5m.com/item.html?tid=2614676&mps=____&type=comment", "http://m.baidu.com"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        if let aView = detailView() {
            view.addSubview(aView)
        }
        view.backgroundColor = UIColor.lightGray
        tableView.reloadData()
        detailView()?.reloadData()
    }
    
    func detailView() -> DetailView? {
        if !detailView {
            detailView = DetailView(frame: CGRect(x: 0, y: 64, width: view.bounds.size.width, height: view.bounds.size.height - 64))
            detailView.delegate = self
            detailView.topScrollPageView.delegate = self
        }
        return detailView
    }
    var tableView: UITableView! {
        if !tableView {
            tableView = UITableView(frame: detailView.bounds)
            tableView.delegate = self
            tableView.dataSource = self
        }
        return tableView
    }
    
    // MARK: UIScrollPageControlViewDelegate
    func numberOf(_ control: UIScrollPageControlView?) -> Int {
        return 8
    }
    //  The converted code is limited to 1 KB.
    //  Please Sign Up (Free!) to remove this limitation.
    //
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    func configItemOfControl(_ control: UIScrollPageControlView?, at index: Int) -> UIView? {
        var cellItem = control?.dequeueReusableView(withIdentifier: "reuse") as? UIImageView
        var reuse = "复用来的"
        var label: UILabel? = nil
        if cellItem == nil {
            cellItem = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 370))
            cellItem?.isUserInteractionEnabled = true
            cellItem?.backgroundColor = UIColor(white: 0.7, alpha: 0.4)
            //        cellItem.reuseIdentifier = @"reuse";
            label = UILabel(frame: CGRect(x: 0, y: 50, width: view.bounds.size.width, height: 100))
            reuse = "=====新生成的"
            label?.textAlignment = .center
            label?.tag = 1000
            if let aLabel = label {
                cellItem?.addSubview(aLabel)
            }
        } else {
            label = cellItem?.viewWithTag(1000) as? UILabel
        }
        var image = UIImage(named: "pic_\((index + 1) % 4)")
        image = image?.imageScaled(toSizeEx: CGSize(width: (cellItem?.frame.size.width ?? 0.0) * 2, height: (cellItem?.frame.size.height ?? 0.0) * 2))
        cellItem?.image = image
        label?.text = "item = \(index) || reuse = \(reuse)"
        return cellItem
    }
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    func viewAtTop() -> UIView? {
        return tableView
    }
    
    var numberOfSections: Int {
        return 3
    }
    
    func titleOfSection(at index: Int) -> String? {
        return titles[index]
    }
    
    func viewOfSection(at index: Int) -> UIView? {
        let webview = UIWebView(frame: CGRect.zero)
        return webview
    }
    
    func didChange(toSection index: Int, view: UIView?) {
        let url = urls[index]
        let webView = view as? UIWebView
        if webView?.request == nil {
            webView?.stopLoading()
            if let anUrl = URL(string: url) {
                webView?.loadRequest(URLRequest(url: anUrl))
            }
        }
    }
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    func data() -> [AnyHashable]? {
        if !data {
            data = [AnyHashable]()
            data.append(["title": "Wap商品详情", "author": "伯光", "class": "DetailWapViewController"])
            data.append(["title": "TableView商品详情", "author": "伯光", "class": "DetailTableViewController"])
            data.append(["title": "ScrollView商品详情", "author": "伯光", "class": "DetailScrollViewController"])
            data.append(["title": "Wap商品详情", "author": "伯光", "class": "DetailWapViewController"])
            data.append(["title": "TableView商品详情", "author": "伯光", "class": "DetailTableViewController"])
            data.append(["title": "ScrollView商品详情", "author": "伯光", "class": "DetailScrollViewController"])
        }
        return data
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeueReusableCellWithIdentifier = "dequeueReusableCellWithIdentifier"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: dequeueReusableCellWithIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: dequeueReusableCellWithIdentifier)
            cell?.accessoryType = .disclosureIndicator
        }
        cell?.textLabel?.text = data[indexPath.row]["title"]
        cell?.detailTextLabel?.text = data[indexPath.row]["author"]
        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let classString = data[indexPath.row]["class"]
        let newClass: AnyClass = NSClassFromString(classString)
        let controller = newClass() as? UIViewController
        controller?.title = data[indexPath.row]["title"]
        if controller != nil {
            if let aController = controller {
                navigationController?.pushViewController(aController, animated: true)
            }
        }
    }


}
