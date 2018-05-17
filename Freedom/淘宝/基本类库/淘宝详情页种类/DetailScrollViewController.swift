//
//  DetailScrollViewController.swift
//  Freedom
//
//  Created by htf on 2018/5/17.
//  Copyright © 2018年 薛超. All rights reserved.
//

import UIKit

class DetailScrollViewController: TaobaoBaseViewController {
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    private var titles = ["图文详情", "商品评论", "店铺推荐"]
    private var urls = ["http://m.b5m.com/item.html?tid=2614676&mps=____&type=content", "http://m.b5m.com/item.html?tid=2614676&mps=____&type=comment", "http://m.baidu.com"]
    var detailView: DetailView?
    var scrollView: UIScrollView?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        scrollView
        if let aView = detailView() {
            view.addSubview(aView)
        }
        view.backgroundColor = UIColor.lightGray
        detailView()?.reloadData()
        scrollView.contentSize = CGSize(width: view.bounds.size.width, height: (view.bounds.size.height - 64) * 2)
    }
    
    func detailView() -> DetailView? {
        if !detailView {
            detailView = DetailView(frame: CGRect(x: 0, y: 64, width: view.bounds.size.width, height: view.bounds.size.height - 64))
            detailView.delegate = self
            detailView.topScrollPageView.delegate = self
        }
        return detailView
    }
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    var scrollView: UIScrollView {
        if !scrollView {
            scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height - 64))
            scrollView.contentSize = CGSize(width: view.bounds.size.width, height: (view.bounds.size.height - 64) * 1 + 1.0)
            var label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height - 64))
            label.backgroundColor = UIColor(white: 0.7, alpha: 0.4)
            label.text = "Label 1"
            label.textAlignment = .center
            scrollView.addSubview(label)
            label = UILabel(frame: CGRect(x: 0, y: view.bounds.size.height - 64, width: view.bounds.size.width, height: view.bounds.size.height - 64))
            label.backgroundColor = UIColor.red
            label.text = "Label 2"
            label.textAlignment = .center
            scrollView.addSubview(label)
            label = UILabel(frame: CGRect(x: 0, y: view.bounds.size.height - 64, width: view.bounds.size.width, height: view.bounds.size.height - 64))
            label.backgroundColor = UIColor.red
            label.text = "Label 2"
            label.textAlignment = .center
            scrollView.addSubview(label)
        }
        return scrollView
    }
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
    func numberOf(_ control: UIScrollPageControlView?) -> Int {
        return 10
    }
    
    // MARK: DetailViewSectionDelegate
    func viewAtTop() -> UIView? {
        return scrollView
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

}
