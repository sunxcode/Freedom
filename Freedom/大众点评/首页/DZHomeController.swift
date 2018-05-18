//
//  DZHomeController.swift
//  Freedom
import UIKit
import BaseFile
import XExtension
class DZHomeViewCell1:BaseCollectionViewCell{
    override func initUI() {//120
        icon = UIImageView(frame: CGRect(x: 10, y: 60, width: W(self) / 2 - 10, height: 60))
        let view: UIView? = getViewWithFrame(CGRect(x: 0, y: 0, width: APPW / 2 - 10, height: 55))
        let view2: UIView? = getViewWithFrame(CGRect(x: APPW / 2, y: 0, width: APPW / 2 - 10, height: 55))
        let view3: UIView? = getViewWithFrame(CGRect(x: X(view2), y: YH(view2) + 10, width: W(view2), height: H(view2)))
        let image1 = UIImageView(frame: CGRect(x: W(view2) - 40, y: 0, width: 40, height: H(view2)))
        image1.image = UIImage(named: "image1.jpg")
        let image2 = UIImageView(frame: CGRect(x: W(view2) - 40, y: 0, width: 40, height: H(view2)))
        image2.image = UIImage(named: "image2.jpg")
        view2?.addSubview(image1)
        view3?.addSubview(image2)
        line = UIView(frame: CGRect(x: 0, y: 198, width: APPW, height: 2))
        line.backgroundColor = .white
        addSubviews([view!, view2!, icon, view3!])
    }

    func getViewWithFrame(_ rect: CGRect) -> UIView {
        let view = UIView(frame: rect)
        let a = UILabel(frame: CGRect(x: 10, y: 0, width: APPW / 2 - 20, height: 18), font: fontnomal, color: redcolor, text: "外卖贺新春")
        let b = UILabel(frame: CGRect(x: X(a), y: YH(a), width: W(a), height: H(a)), font: fontnomal, color: blacktextcolor, text: "省事省力又省心")
        let c = UILabel(frame: CGRect(x: X(a), y: YH(b), width: 100, height: 15), font: fontnomal, color: yellowcolor, text: "用外卖订年夜饭")
        c?.layer.cornerRadius = 7
        c?.layer.borderWidth = 1
        c?.layer.borderColor = redcolor.cgColor
        view.addSubviews([a!, b, c!])
        return view
    }

    func setCollectionDataWithDic(_ dict: [AnyHashable: Any]?) {
        icon.image = UIImage(named: "image4.jpg")
    }

}
class DZHomeViewCell2:BaseCollectionViewCell{
    override func initUI() {//100
        icon = UIImageView(frame: CGRect(x: 0, y: 0, width: APPW / 4, height: 60))
        title = UILabel(frame: CGRect(x: 20, y: YH(icon), width: W(icon), height: 20))
        script = UILabel(frame: CGRect(x: X(title), y: YH(title), width: W(title), height: H(title)))
        script.font = fontnomal
        title.font = fontSmallTitle
        script.textColor = gradtextcolor
        addSubviews([icon, title, script])
    }

    func setCollectionDataWithDic(_ dict: [AnyHashable: Any]?) {
        title.text = "全球贺新年"
        script.text = "春节专享"
        icon.image = UIImage(named: "taobaomini2")
    }
}
class DZHomeViewCell3:BaseCollectionViewCell{
    override func initUI() {//80
        icon = UIImageView(frame: CGRect(x: 0, y: 0, width: APPW / 4 - 11, height: 50))
        icon.clipsToBounds = true
        icon.layer.cornerRadius = 10
        title = UILabel(frame: CGRect(x: 0, y: YH(icon), width: W(icon), height: 18))
        script = UILabel(frame: CGRect(x: X(title), y: YH(title), width: W(title), height: 15))
        script.font = Font(12)
        title.font = fontnomal
        script.textColor = gradtextcolor
        title.textAlignment = .center
        script.textAlignment = .center
        addSubviews([icon, title, script])
    }
    func setCollectionDataWithDic(_ dict: [AnyHashable: Any]?) {
        title.text = "爱车"
        script.text = "9.9元洗车"
        icon.image = UIImage(named: "taobaomini1")
    }
}
class DZHomeViewCell4:BaseCollectionViewCell{
    override func initUI() {//100
        icon = UIImageView(frame: CGRect(x: 10, y: 0, width: APPW / 4, height: 80))
        title = UILabel(frame: CGRect(x: XW(icon) + 10, y: Y(icon), width: APPW - XW(icon) - 20, height: 20))
        script = UILabel(frame: CGRect(x: X(title), y: YH(title), width: W(title), height: 40))
        let a = UILabel(frame: CGRect(x: APPW - 80, y: Y(title), width: 70, height: H(title)))
        a.textAlignment = .right
        let b = UILabel(frame: CGRect(x: X(title), y: YH(script), width: W(title), height: H(title)))
        let d = UILabel(frame: CGRect(x: X(a), y: Y(b), width: W(a), height: H(a)))
        d.textAlignment = .right
        d.font = fontnomal
        a.font = d.font
        script.font = a.font
        script.numberOfLines = 0
        d.textColor = graycolor
        a.textColor = d.textColor
        script.textColor = a.textColor
        b.textColor = redcolor
        a.text = "575m"
        b.text = "￥69"
        d.text = "已售50000"
        let ling = UIView(frame: CGRect(x: 10, y: 99, width: APPW - 20, height: 1))
        ling.backgroundColor = whitecolor
        addSubviews([icon, title, a, script, b, d, ling])
    }
    func setCollectionDataWithDic(_ dict: [AnyHashable: Any]?) {
        title.text = "上海海洋水族馆(4A)"
        script.text = "[陆家嘴]4.2分|门票、套餐、线路游 等优惠，欢迎上门体验"
        icon.image = UIImage(named:"userLogo")
    }

}
class DZHomeHeadView1: UICollectionReusableView {
    var DZtoutiaoV: BaseScrollView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initUI() {
        DZtoutiaoV = BaseScrollView(viewBanner: CGRect(x: 20, y: 0, width: APPW - 40, height: 60), viewsNumber: 5, viewOfIndex: {(_ index: Int) -> UIView in
            let view = UIView(frame: CGRect(x: 0, y: 0, width: APPW - 50, height: 60))
            let icon = UIImageView(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
            icon.clipsToBounds = true
            icon.layer.cornerRadius = 20
            icon.image = UIImage(named: "userLogo")
            let label1 = UILabel(frame: CGRect(x: XW(icon) + 10, y: 10, width: APPW / 2, height: 40), font: fontnomal, color: blacktextcolor, text: "好友蜂蜜绿茶，吃完这家，还有下一家。地点中环广场店")
            label1?.numberOfLines = 0
            view.addSubviews([icon, label1!])
            view.backgroundColor = redcolor
            if index % 2 != 0 {
                view.backgroundColor = yellowcolor
            }
            return view
        }, vertically: true, setFire: true)
        addSubview(DZtoutiaoV!)
    }

}
class DZHomeHeadView2: UICollectionReusableView {
    var titleLabel: UILabel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initUI() {
        titleLabel = UILabel(frame: CGRect(x: 0, y: 5, width: APPW, height: 20))
        titleLabel?.textColor = redcolor
        titleLabel?.textAlignment = .center
        titleLabel?.text = "为你优选BEST"
        backgroundColor = whitecolor
        if let aLabel = titleLabel {
            addSubview(aLabel)
        }
    }
}
class DZHomeController: DianpingBaseViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        let more = UIBarButtonItem(image: UIImage(renderingOriginalName: "u_add_y"), style: .plain, actionBlick: {() -> Void in
        })
        navigationItem.rightBarButtonItem = more
        let map = UIBarButtonItem(title: "北京", style: .plain, actionBlick: {() -> Void in
        })
        navigationItem.leftBarButtonItem = map
        let searchBar = UISearchBar()
        searchBar.placeholder = "输入商户名、地点"
        navigationItem.titleView = searchBar
        let titles = ["美食", "电影", "酒店", "休闲娱乐", "外卖", "机票/火车票", "丽人", "周边游", "亲子", "KTV", "高端酒店", "足疗按摩", "结婚", "家族", "学习培训", "景点", "游乐园", "生活服务", "洗浴", "全部分类"]
        let icons = ["taobaomini1", "taobaomini2", "taobaomini3", "taobaomini4", "taobaomini5", "taobaomini1", "taobaomini2", "taobaomini3", "taobaomini4", "taobaomini5", "taobaomini1", "taobaomini2", "taobaomini3", "taobaomini4", "taobaomini5", "taobaomini1", "taobaomini2", "taobaomini3", "taobaomini4", "taobaomini5"]
        let itemScrollView = BaseScrollView(scrollItem: CGRect(x: 0, y: 60, width: APPW, height: 200), icons: icons, titles: titles, size: CGSize(width: APPW / 5.0, height: 70), hang: 2, round: true)
        itemScrollView.backgroundColor = whitecolor
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (APPW - 50) / 4, height: 90)
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionView = BaseCollectionView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH - 110), collectionViewLayout: layout)
        collectionView?.register(DZHomeViewCell2.self, forCellWithReuseIdentifier: "DZHomeViewCell2")
        collectionView?.register(DZHomeViewCell3.self, forCellWithReuseIdentifier: "DZHomeViewCell3")
        collectionView?.register(DZHomeViewCell4.self, forCellWithReuseIdentifier: "DZHomeViewCell4")
        collectionView?.register(DZHomeHeadView1.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headview1")
        collectionView?.register(DZHomeHeadView2.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headview2")
        collectionView?.addSubview(itemScrollView)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        if let aView = collectionView {
            view.addSubview(aView)
        }
    }
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if section == 0 {
                return 1
            }
            if section == 1 {
                return 6
            }
            if section == 2 {
                return 8
            }
            return 20
        }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            var cell: BaseCollectionViewCell? = nil
            if indexPath.section == 0 {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath) as? BaseCollectionViewCell
            } else if indexPath.section == 1 {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DZHomeViewCell2", for: indexPath) as? BaseCollectionViewCell
            } else if indexPath.section == 2 {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DZHomeViewCell3", for: indexPath) as? BaseCollectionViewCell
            } else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DZHomeViewCell4", for: indexPath) as? BaseCollectionViewCell
            }
            if let aCell = cell {
                return aCell
            }
            return UICollectionViewCell()
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if indexPath.section == 0 {
                return CGSize(width: APPW, height: 130)
            } else if indexPath.section == 1 {
                return CGSize(width: APPW / 3 - 15, height: 100)
            } else if indexPath.section == 2 {
                return CGSize(width: APPW / 4 - 15, height: 90)
            } else {
                return CGSize(width: APPW, height: 100)
            }
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            if section == 0 {
                return CGSize(width: APPW, height: 60)
            } else if section == 1 {
                return CGSize(width: APPW, height: 30)
            } else if section == 2 {
                return CGSize(width: APPW, height: 60)
            } else if section == 3 {
                return CGSize(width: APPW, height: 30)
            }
            return CGSize(width: APPW, height: 30)
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            return CGSize.zero
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            if section == 0 {
                return UIEdgeInsetsMake(160, 10, 0, 10)
            } else {
                return UIEdgeInsetsMake(10, 10, 0, 10)
            }
        }
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            if kind == UICollectionElementKindSectionHeader {
                if indexPath.section == 0 {
                    return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headview1", for: indexPath)
                } else if indexPath.section == 1 {
                    return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headview2", for: indexPath)
                } else if indexPath.section == 2 {
                    return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headview1", for: indexPath)
                } else {
                    return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headview2", for: indexPath)
                }
            }
    }
            func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                let log = "你选择的是\(indexPath.section)，\(indexPath.row)"
                Dlog(log)
            }

}
