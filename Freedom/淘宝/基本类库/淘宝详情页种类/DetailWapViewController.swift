//
//  DetailWapViewController.swift
//  Freedom
//
//  Created by htf on 2018/5/17.
//  Copyright © 2018年 薛超. All rights reserved.
//

import UIKit

class DetailWapViewController: TaobaoBaseViewController {
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    private var __totalNumber: Int = 3
    private var images = ["1.jpg", "l.jpg", "w.jpg", "xt.jpg"]
    private var titles = ["图文详情", "商品评论", "百度"]
    private var urls = ["http://m.b5m.com/item.html?tid=2614676&mps=____&type=content", "http://m.b5m.com/item.html?tid=2614676&mps=____&type=comment", "http://m.baidu.com"]
    var detailView: DetailView?
    var topWebView: UIWebView?
    var control: MFullScreenControl?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(detailView)
        view.backgroundColor = UIColor.lightGray
        if let aString = URL(string: "http://m.b5m.com/item.html?tid=2614676&mps=____&type=index") {
            topWebView.loadRequest(URLRequest(url: aString))
        }
        detailView.reloadData()
    }
    func detailView() -> DetailView? {
        if !detailView {
            detailView = DetailView(frame: CGRect(x: 0, y: 64, width: view.bounds.size.width, height: view.bounds.size.height - 64))
            detailView.delegate = self
            detailView.startYPosition = 0.0
            detailView.topScrollViewTopInset = 300.0
            detailView.topScrollPageView.delegate = self
        }
        return detailView
    }
    
    func topWebView() -> UIWebView? {
        if !topWebView {
            topWebView = UIWebView(frame: detailView.bounds)
            topWebView.scrollView.showsVerticalScrollIndicator = false
            topWebView.backgroundColor = UIColor.white
            topWebView.opaque = false
        }
        return topWebView
    }
    func control() -> MFullScreenControl? {
        if control == nil {
            control = detailView.fullScreencontrol
            control?.screenPageView.delegate = self
        }
        return control
    }
    
    // MARK: UIScrollPageControlViewDelegate
    func numberOf(_ control: UIScrollPageControlView?) -> Int {
        return 4
    }
    func configBannerItemOfControl(_ control: UIScrollPageControlView?, at index: Int) -> UIView? {
        var cellItem = control?.dequeueReusableView(withIdentifier: "reuse") as? UIImageView
        if cellItem == nil {
            cellItem = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: detailView.topScrollViewTopInset))
            cellItem?.isUserInteractionEnabled = true
            cellItem?.clipsToBounds = true
            cellItem?.contentMode = .scaleAspectFill
            cellItem?.backgroundColor = UIColor(white: 0.7, alpha: 0.4)
            //        cellItem.reuseIdentifier = @"reuse";
            cellItem?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("imageViewDidTaped:")))
        }
        let image = UIImage(named: images[index % 4])
        cellItem?.image = image
        return cellItem
    }
    func configFullItemOfControl(_ control: UIScrollPageControlView?, at index: Int) -> UIView? {
        var cellItem = control?.dequeueReusableView(withIdentifier: "reuse") as? MFullScreenView
        if cellItem == nil {
            cellItem = MFullScreenView(frame: UIScreen.main.bounds)
            cellItem?.isUserInteractionEnabled = true
            //        cellItem.reuseIdentifier = @"reuse";
            cellItem?.enableDoubleTap(true)
            weak var blockSelf = self
            cellItem?.singleTapBlock = {(_ recognizer: UIGestureRecognizer?) -> Void in
                blockSelf.detailView.hideFullScreen(on: recognizer?.view)
            }
        }
        cellItem?.imageView.image = UIImage(named: images[index % 4])
        cellItem?.reloadData()
        return cellItem
    }
    func reconfigItemOfControl(_ control: UIScrollPageControlView?, at index: Int, with view: UIView?) {
        if control == self.control.screenPageView {
            let cellItem = view as? MFullScreenView
            cellItem?.reloadData()
        }
    }
    
    func configItemOfControl(_ control: UIScrollPageControlView?, at index: Int) -> UIView? {
        if control == self.control.screenPageView {
            return configFullItemOfControl(self.control.screenPageView, at: index)
        }
        return configBannerItemOfControl(control, at: index)
    }
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    func minimumRowSpacing(_ control: UIScrollPageControlView?) -> CGFloat {
        return (control == self.control.screenPageView) ? 20.0 : 0.0
    }
    
    func imageViewDidTaped(_ recognizer: UIGestureRecognizer?) {
        if control.isAppear {
            detailView.hideFullScreen(on: recognizer?.view)
            return
        }
        detailView.showFullScreen(on: recognizer?.view)
    }
    
    // MARK: DetailViewSectionDelegate
    func viewAtTop() -> UIView? {
        return topWebView
    }
    
    var numberOfSections: Int {
        return __totalNumber
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
