//
//  JFWebViewController.swift
//  Freedom
import UIKit
import BaseFile
import XExtension
class JFWebViewController: IqiyiBaseViewController {
    func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        isFirstIn = 0
        //返回
        let backBtn = UIButton(type: .custom)
        backBtn.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
        backBtn.setImage(UIImage(named: PcellLeft), for: .normal)
        backBtn.addTarget(self, action: Selector("OnBackBtn:"), for: .touchUpInside)
        navigationItem?.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        webView = UIWebView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH - 64))
        webView?.delegate = self
        webView?.scalesPageToFit = true
        if let aView = webView {
            view.addSubview(aView)
        }
        Dlog("webview URL:\( self.urlStr)")
        let urlStr = self.urlStr.addingPercentEscapes(using: .utf8)
        var request: URLRequest? = nil
        if let aStr = URL(string: urlStr ?? "") {
            request = URLRequest(url: aStr)
            webView?.load(request)
            activityView = UIActivityIndicatorView(frame: CGRect(x: APPW / 2 - 15, y: APPH / 2 - 15, width: 30, height: 30))
            activityView.activityIndicatorViewStyle = .gray
            activityView.hidesWhenStopped = true
            view.addSubview(activityView)
            view.bringSubview(toFront: activityView)
        }
    }
        func onBackBtn(_ sender: UIButton?) {
            Dlog("_isFirstIn:\(isFirstIn)")
            if isFirstIn <= 1 {
                navigationController?.popViewController(animated: true)
            } else {
                isFirstIn = isFirstIn - 2
                webView?.goBack()
            }
        }
        
        // MARK: - UIWebViewDelegate
        func webViewDidStartLoad(_ webView: UIWebView) {
            Dlog("开始加载webview")
        }
        
        func webViewDidFinishLoad(_ webView: UIWebView) {
            Dlog("加载webview完成")
            let theTitle = webView.stringByEvaluatingJavaScript(from: "document.title")
            title = theTitle
            activityView.stopAnimating()
        }
        
        func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
            Dlog("加载webview失败")
        }

        func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
            activityView.startAnimating()
            isFirstIn += 1
            Dlog("第几次加载:%d", isFirstIn)
            return true
        }
}
