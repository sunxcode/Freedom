//
//  BooksTabBarController.swift
//  Freedom
//
import UIKit
class BooksTabBarController: XBaseTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = .white
        hidesBottomBarWhenPushed = true
    }
}
