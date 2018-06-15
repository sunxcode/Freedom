//
//  LibraryCollectionViewController.swift
//  Freedom
//
//  Created by Super on 6/15/18.
//  Copyright © 2018 薛超. All rights reserved.
//
import UIKit
import ElasticTransitionObjC
import BaseFile
import XExtension
import SVProgressHUD
class LibraryCollectionViewCell: BaseCollectionViewCell {
    override func initUI() {
        super.initUI()
        icon.frame = CGRect(x: 0, y: 0, width: APPW / 5, height: 80)
        icon.layer.cornerRadius = 40
        icon.clipsToBounds = true
        title.frame = CGRect(x: 0, y: YH(icon), width: W(icon), height: 20)
        title.textAlignment = .center
        backgroundColor = UIColor.clear
        addSubviews([icon, title])
    }
}
class LibraryCollectionViewController: UICollectionViewController,ElasticMenuTransitionDelegate {
    var contentLength:CGFloat = APPW
    var dismissByBackgroundTouch = true
    var dismissByBackgroundDrag = true
    var dismissByForegroundDrag = true
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: APPW / 5, height: 100)
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsetsMake(30, 10, 0, 10)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH - 110), collectionViewLayout: layout)
        collectionView?.backgroundColor = UIColor.white
        let backView = UIImageView(frame: CGRect(x: 0, y: 100, width: APPW, height: APPH - 100))
        backView.image = UIImage(named: "")
        collectionView?.backgroundView = backView
        let ET = transitioningDelegate as? ElasticTransition
        print("\ntransition.edge = \(HelperFunctions.type(toStringOf: (ET?.edge)!))\ntransition.transformType = \(String(describing: ET?.transformTypeToString()))\ntransition.sticky = \(String(describing:  ET?.sticky))\ntransition.showShadow = \(String(describing: ET?.showShadow))")
        collectionView?.register(LibraryCollectionViewCell.self, forCellWithReuseIdentifier: LibraryCollectionViewCell.getColloctionCellIdentifier())
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FreedomItems.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: LibraryCollectionViewCell.getColloctionCellIdentifier(), for: indexPath) as? LibraryCollectionViewCell
        if cell == nil {
            cell = LibraryCollectionViewCell(frame: CGRect(x: 0, y: 0, width: APPW / 5, height: 100))
        }
        let dict = FreedomItems[indexPath.row]
        cell?.title.text = dict["title"]
        cell?.icon.image = UIImage(named: dict["icon"]!)
        if let aCell = cell {
            return aCell
        }
        return UICollectionViewCell()
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controlName = FreedomItems[indexPath.row]["control"]!
        UIApplication.shared.isStatusBarHidden = false
        if !(controlName == "Sina") {
            let StoryBoard = UIStoryboard(name: controlName, bundle: nil)
            show(StoryBoard.instantiateViewController(withIdentifier: "\(controlName)TabBarController"), sender: self)
            return
        }
        let s = "\(controlName)TabBarController"
        print(s)
        let con: UIViewController = UIViewController()//NSClassFromString(s)
        let animation = CATransition()
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        view.window?.layer.add(animation, forKey: nil)
        present(con, animated: false) {
            SVProgressHUD.showSuccess(withStatus: FreedomItems[indexPath.row]["title"])
        }
    }
}
