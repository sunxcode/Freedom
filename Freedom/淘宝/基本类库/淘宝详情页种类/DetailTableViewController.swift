//
//  DetailTableViewController.swift
//  Freedom

import UIKit
import BaseFile
import XExtension
class DetailTableViewController: TaobaoBaseViewController,DetailViewSectionDelegate {
    private var titles = ["图文详情", "商品评论", "店铺推荐"]
    private var urls = ["http://m.b5m.com/item.html?tid=2614676&mps=____&type=content", "http://m.b5m.com/item.html?tid=2614676&mps=____&type=comment", "http://m.baidu.com"]
    var detailView :DetailView!
    var data :[[String:Any]]!
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        data = [["title": "Wap商品详情", "author": "伯光", "class": "DetailWapViewController"],["title": "TableView商品详情", "author": "伯光", "class": "DetailTableViewController"],["title": "ScrollView商品详情", "author": "伯光", "class": "DetailScrollViewController"],["title": "Wap商品详情", "author": "伯光", "class": "DetailWapViewController"],["title": "TableView商品详情", "author": "伯光", "class": "DetailTableViewController"],["title": "ScrollView商品详情", "author": "伯光", "class": "DetailScrollViewController"]]
        
            detailView = DetailView(frame: CGRect(x: 0, y: 64, width: view.bounds.size.width, height: view.bounds.size.height - 64))
            detailView.delegate = self
        detailView.topScrollPageView.delegate = self as! UIScrollPageControlViewDelegate
            tableView = BaseTableView(frame: detailView.bounds)
            tableView.delegate = self
            tableView.dataSource = self
        if let aView = detailView {
            view.addSubview(aView)
        }
        view.backgroundColor = UIColor.lightGray
        tableView.reloadData()
        detailView?.reloadData()
    }
    // MARK: UIScrollPageControlViewDelegate
    func numberOf(_ control: UIScrollPageControlView?) -> Int {
        return 8
    }
    func configItemOfControl(_ control: UIScrollPageControlView?, at index: Int) -> UIView? {
        var cellItem = control?.dequeueReusableView(withIdentifier: "reuse") as? UIImageView
        var reuse = "复用来的"
        var label: UILabel? = nil
        if cellItem == nil {
            cellItem = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 370))
            cellItem?.isUserInteractionEnabled = true
            cellItem?.backgroundColor = UIColor(white: 0.7, alpha: 0.4)
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
    func viewAtTop() -> UIView! {
        return tableView
    }
    func numberOfSections() -> UInt {
        return 3
    }
    func titleOfSection(at index: UInt) -> String! {
        return "titles[index]"
    }
    private func viewOfSection(at index: Int) -> UIView? {
        let webview = UIWebView(frame: CGRect.zero)
        return webview
    }
    
    private func didChange(toSection index: Int, view: UIView?) {
        let url = urls[index]
        let webView = view as? UIWebView
        if webView?.request == nil {
            webView?.stopLoading()
            if let anUrl = URL(string: url) {
                webView?.loadRequest(URLRequest(url: anUrl))
            }
        }
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeueReusableCellWithIdentifier = "dequeueReusableCellWithIdentifier"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: dequeueReusableCellWithIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: dequeueReusableCellWithIdentifier)
            cell?.accessoryType = .disclosureIndicator
        }
        cell?.textLabel?.text = data[indexPath.row]["title"] as? String
        cell?.detailTextLabel?.text = data[indexPath.row]["author"] as? String
        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = data[indexPath.row]["class"]
navigationController?.pushViewController(UIViewController(), animated: true)
    }


}
