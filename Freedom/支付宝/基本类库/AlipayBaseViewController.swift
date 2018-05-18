//
//  AlipayBaseViewController.swift
//  Freedom
import UIKit
class AlipayBaseViewController: XBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 5)], for: .normal)
    }
}
