//
//  KugouBaseViewController.swift
//  Freedom

import UIKit
import XExtension
class KugouBaseViewController: XBaseViewController {
    var navBar: UIView!
    var backItem: UIImageView = UIImageView()
    var leftItem: UIImageView = UIImageView()
    var rightItem: UIImageView = UIImageView()
    var leftButton: UIButton = UIButton()
    var rightButton: UIButton = UIButton()
    private(set) var titleLabel: UILabel!
    private(set) var titleLine: UILabel!

    let ItemImagewidth = 20.0
    let ItemButtonwidth = 50.0
    override  func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = UIColor.white
        initUI()
        setNavBar()
    }
    func initUI(){
        backItem.image = UIImage(named: "backButton")
        backItem.contentMode = .scaleAspectFit
        backItem.isUserInteractionEnabled = true
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.backItemTouched(_:)))
        backItem.addGestureRecognizer(backTap)
        navBar.addSubview(backItem)
        backItem.frame = CGRect(x: 5, y: 30, width: CGFloat(ItemImagewidth), height: CGFloat(ItemImagewidth))
        leftItem.image = UIImage(named: "")
        leftItem.isUserInteractionEnabled = true
        navBar.addSubview(leftItem)
        leftItem.frame = CGRect(x: 5, y: 28, width: CGFloat(ItemImagewidth), height: CGFloat(ItemImagewidth))
        rightItem.image = UIImage(named: "")
        rightItem.isUserInteractionEnabled = true
        navBar.addSubview(rightItem)
        rightItem.frame = CGRect(x: APPW - 35, y: 28, width: CGFloat(ItemImagewidth), height: CGFloat(ItemImagewidth))
        leftButton.addTarget(self, action: #selector(self.leftButtonClick(_:)), for: .touchUpInside)
        leftButton.titleLabel?.font = fontSmallTitle
        leftButton.setTitleColor(UIColor.white, for: [])
        navBar.addSubview(leftButton)
        leftButton.frame = CGRect(x: 5, y: 28, width: CGFloat(ItemButtonwidth), height: CGFloat(ItemImagewidth))
        rightButton = UIButton()
        rightButton.addTarget(self, action: #selector(self.rightButtonClick(_:)), for: .touchUpInside)
        rightButton.titleLabel?.font = fontSmallTitle
        rightButton.setTitleColor(UIColor.white, for: [])
        navBar.addSubview(rightButton)
        rightButton.frame = CGRect(x: APPW - 55, y: 28, width: CGFloat(ItemButtonwidth), height: CGFloat(ItemImagewidth))
    }
    /*添加NavBar*/
    func setNavBar() {
        navBar = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 64))
        titleLabel = UILabel()
        titleLine = UILabel()
        titleLine.backgroundColor = UIColor.gray
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.numberOfLines = 1
        titleLabel.textColor = whitecolor
        titleLabel.textAlignment = .center
        titleLabel.font = BoldFont(17)
        navBar.addSubview(titleLabel)
        navBar.addSubview(titleLine)
        navBar.backgroundColor = RGBAColor(51, 124, 200 ,1)
        titleLabel.frame = CGRect(x: 0, y: 20, width: APPW, height: 64 - 20)
        titleLine.frame = CGRect(x: 0, y: 64, width: APPW, height: 0.26)
        titleLabel?.text = title
        view.addSubview(navBar)
    }


    func backItemTouched(_ sender: Any?) {
        goBack()
    }

    func leftItemTouched(_ sender: Any?) {
        print("用到图片的时候重写leftItemTouched方法")
    }

    func rightItemTouched(_ sender: Any?) {
        print("用到图片的时候重写rightItemTouched方法")
    }
    func leftButtonClick(_ sender: Any?) {
        print("用到按钮的时候重写leftButtonClick方法")
    }
    func rightButtonClick(_ sender: Any?) {
        print("用到按钮的时候重写rightButtonClick方法")
    }

    func goBack() {
        let vcarr = navigationController?.viewControllers
        if (vcarr?.count ?? 0) > 1 {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }

}
