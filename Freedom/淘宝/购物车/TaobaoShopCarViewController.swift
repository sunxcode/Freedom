//
//  TaobaoShopCarViewController.swift
//  Freedom

import UIKit
import BaseFile
import XExtension
import XCategory
class TaobaoShopCarViewCell:BaseTableViewCell{
    override func initUI() {
        icon = UIImageView()
        icon.contentMode = .scaleToFill
        title = UILabel()
        title.font = fontTitle
        title.numberOfLines = 0
        script = UILabel()
        script.font = fontnomal
        title.textColor = blacktextcolor
        script.textColor = title.textColor
        line = UIView(frame: CGRect(x: 0, y: 99, width: APPW, height: 1))
        line.backgroundColor = gradcolor
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 20))
        let selecth = UIButton(frame: CGRect(x: 10, y: 2.5, width: 15, height: 15))
        selecth.setImage(UIImage(named: "taobaono"), for: .normal)
        selecth.setImage(UIImage(named: "taobaoon"), for: .selected)
        let headTitle = UILabel(frame: CGRect(x: XW(selecth), y: 0, width: APPW - 150, height: 20), font: fontnomal, color: gradtextcolor, text: "中华精品城 >")
        let lingquan = UIButton(frame: CGRect(x: APPW - 100, y: 0, width: 40, height: 20))
        lingquan.setTitle("领券", for: .normal)
        let edit = UIButton(frame: CGRect(x: XW(lingquan) + 10, y: 0, width: 40, height: 20))
        edit.setTitle("编辑", for: .normal)
        edit.titleLabel?.font = fontnomal
        lingquan.titleLabel?.font = edit.titleLabel?.font
        headView.addSubviews([selecth, headTitle!, lingquan, edit])
        let contentV = UIView(frame: CGRect(x: 0, y: YH(headView), width: APPW, height: 80))
        let selectc = UIButton(frame: CGRect(x: 10, y: 32, width: 15, height: 15))
        selectc.setImage(UIImage(named: "taobaono"), for: .normal)
        selectc.setImage(UIImage(named: "taobaoon"), for: .selected)
        icon.frame = CGRect(x: XW(selectc) + 10, y: 5, width: 60, height: 70)
        title.frame = CGRect(x: XW(icon) + 10, y: Y(icon), width: APPW - XW(icon) - 20, height: 30)
        title.numberOfLines = 0
        title.font = fontnomal
        script.textColor = graycolor
        script.frame = CGRect(x: X(title), y: YH(title), width: W(title), height: 20)
        let newPrice = UILabel(frame: CGRect(x: X(script), y: YH(script), width: 60, height: 20), font: fontnomal, color: redcolor, text: "￥199")
        let oldPrice = UILabel(frame: CGRect(x: XW(newPrice), y: Y(newPrice!), width: 80, height: H(newPrice)), font: fontnomal, color: graycolor, text: "￥299")
        let num = UILabel(frame: CGRect(x: APPW - 50, y: Y(newPrice!), width: 40, height: 20), font: fontnomal, color: graycolor, text: "x1")
        num?.textAlignment = .right
        contentV.addSubviews([selectc, icon, title, script, newPrice!, oldPrice!, num!])
        addSubviews([headView, contentV, line])
        icon.image = UIImage(named: "05.jpg")
        title.text = "冬季外套女装学生韩版棉衣女中长款面包服女加厚棉服宽松冬装棉袄"
        script.text = "颜色分类:红色;尺码:M"
    }

}
class TaobaoShopCarViewController: TaobaoBaseViewController {
    func buildUI() {
        title = "购物车(10)"
        let more = UIBarButtonItem(barButtonSystemItem: .action, target:nil, action:nil)
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target:nil, action:nil)
        navigationItem.rightBarButtonItems = [edit, more]
        tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: Int(APPW), height: Int(APPH - TabBarH) - 44 - 50), style: .plain)
        tableView.dataArray = ["b", "a", "v", "f", "d", "a", "w", "u", "n", "o", "2"]
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        let totalView = UIView(frame: CGRect(x: 0, y: APPH - 50 - TabBarH - 44, width: APPW, height: 40))
        let totalb = UIButton(frame: CGRect(x: 10, y: 12, width: 56, height: 16))
        totalb.setTitle("全选", for: .normal)
        totalb.setImage(UIImage(named: "taobaono"), for: .normal)
        totalb.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40)
        totalb.setImage(UIImage(named: "taobaoon"), for: .selected)
        let heji = UILabel(frame: CGRect(x: XW(totalb) + 20, y: 10, width: 200, height: 20))
        heji.text = "合计：￥100 不含运费"
        heji.font = fontTitle
        let pay = UIButton(frame: CGRect(x: APPW - 80, y: 0, width: 80, height: 40))
        pay.setTitle("结算(0)", for: .normal)
        pay.backgroundColor = RGBAColor(252, 74, 1)
        totalView.addSubviews([totalb, heji, pay])
        view.addSubview(totalView)
    }


}
