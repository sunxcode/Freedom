//
//  TaobaoMeViewController.swift
//  Freedom
//
//  Created by htf on 2018/5/17.
//  Copyright © 2018年 薛超. All rights reserved.
//

import UIKit
import BaseFile
import XExtension
class TaobaoMeViewCell1:BaseCollectionViewCell{
    func initUI() {
        icon = UIImageView(frame: CGRect(x: 10, y: 0, width: APPW / 5 - 20, height: 40))
        title = UILabel(frame: CGRect(x: 0, y: YH(icon), width: APPW / 5 - 10, height: 20))
        title.font = fontnomal
        title.textAlignment = .center
        addSubviews(title, icon, nil)
    }
    
    func setCollectionDataWithDic(_ dict: [AnyHashable: Any]?) {
        title.text = "待收货"
        icon.image = UIImage(named: "taobaomini2")
    }

}
class TaobaoMeViewCell1:BaseCollectionViewCell{
    func initUI() {
        icon = UIImageView(frame: CGRect(x: 10, y: 0, width: APPW / 5 - 20, height: 40))
        title = UILabel(frame: CGRect(x: 0, y: YH(icon), width: APPW / 5 - 12, height: 20))
        title.font = fontnomal
        title.textAlignment = .center
        addSubviews(title, icon, nil)
    }
    
    func setCollectionDataWithDic(_ dict: [AnyHashable: Any]?) {
        title.text = "蚂蚁花呗"
        icon.image = UIImage(named: "taobaomini1")
    }

}
//  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
class TaobaoMeHeadView: UICollectionReusableView {
    var titleLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
        
    }
    
    func initUI() {
        titleLabel = UILabel(frame: CGRect(x: 10, y: 5, width: APPW / 2, height: 20))
        titleLabel?.textColor = redcolor
        titleLabel?.text = "必备工具"
        let more = UILabel(frame: CGRect(x: XW(titleLabel), y: Y(titleLabel), width: APPW - XW(titleLabel) - 10, height: 20))
        more.textColor = graycolor
        more.textAlignment = .right
        more.font = fontnomal
        more.text = "查看更多 >"
        backgroundColor = whitecolor
        if let aLabel = titleLabel {
            addSubview(aLabel)
        }
        addSubview(more)
    }
}
class TaobaoMeViewController: TaobaoBaseViewController {
    //  The converted code is limited to 1 KB.
    //  Please Sign Up (Free!) to remove this limitation.
    //
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    func viewDidLoad() {
        super.viewDidLoad()
        title = "我的淘宝"
        navigationController?.navigationBar.tintColor = redcolor
        let image = UIImage(named: "Taobaomessage@2x")?.withRenderingMode(.alwaysOriginal)
        let `left` = UIBarButtonItem(title: "设置", style: .plain, actionBlick: {() -> Void in
        })
        let right1 = UIBarButtonItem(image: UIImage(named: "TaobaoScanner@2x"), style: .done, actionBlick: {() -> Void in
        })
        let right2 = UIBarButtonItem(image: image, style: .done, actionBlick: {() -> Void in
        })
        navigationItem?.leftBarButtonItem = `left`
        navigationItem?.rightBarButtonItems = [right1, right2]
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 100))
        headView.backgroundColor = RGBCOLOR(252, 50, 50)
        let icon = UIImageView(frame: CGRect(x: APPW / 2 - 30, y: 0, width: 60, height: 60))
        icon.layer.cornerRadius = 30
        icon.image = UIImage(named: PuserLogo)
        icon.clipsToBounds = true
        let name = UILabel(frame: CGRect(x: 10, y: YH(icon), width: APPW - 20, height: 20), font: fontSmallTitle, color: whitecolor, text: "杨越光", textAlignment: .center)
        let taoqi = UILabel(frame: CGRect(x: APPW / 2 - 40, y: YH(name), width: 80, height: 15), font: fontnomal, color: redcolor, text: "淘气值：710", textAlignment: .center)
        taoqi.clipsToBounds = true
        taoqi.layer.cornerRadius = 7
        taoqi.backgroundColor = yellowcolor
        headView.addSubviews(icon, name, taoqi, nil)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (APPW - 50) / 4, height: 90)
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.headerReferenceSize = CGSize(width: APPW, height: 30)
        layout.footerReferenceSize = CGSize.zero
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH - 110), collectionViewLayout: layout)
        dataArray = [["name": "流量充值", "pic": PuserLogo]]
        collectionView?.register(TaobaoMeViewCell2.self, forCellWithReuseIdentifier: "TaobaoMeViewCell2")
        collectionView?.register(TaobaoMeHeadView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headview")
        collectionView?.register(TaobaoMeHeadView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footview")
        collectionView?.addSubview(headView)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        if let aView = collectionView {
            view.addSubview(aView)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }
        if section == 1 {
            return 12
        }
        if section == 2 {
            return 4
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: BaseCollectionViewOCCell? = nil
        if indexPath.section == 0 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath)
            cell?.collectionDataWithDic = nil
        } else if indexPath.section == 1 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaobaoMeViewCell2", for: indexPath)
            cell?.collectionDataWithDic = nil
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaobaoMeViewCell2", for: indexPath)
            cell?.collectionDataWithDic = nil
        }
        if let aCell = cell {
            return aCell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: APPW / 5 - 12, height: 60)
        } else if indexPath.section == 1 {
            return CGSize(width: APPW / 5 - 5, height: 60)
        } else {
            return CGSize(width: APPW / 5 - 5, height: 60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headview", for: indexPath)
        }
        return nil
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let log = "你选择的是\(indexPath.section)，\(indexPath.row)"
        SVProgressHUD.showSuccess(withStatus: log)
        DLog("%@", log)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsetsMake(80, 10, 0, 10)
        } else {
            return UIEdgeInsetsMake(10, 10, 0, 10)
        }
    }

    
}
