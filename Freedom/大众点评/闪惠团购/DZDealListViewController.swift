//
//  DZDealListViewController.swift
//  Freedom
//
//  Created by htf on 2018/5/17.
//  Copyright © 2018年 薛超. All rights reserved.
//

import UIKit
import BaseFile
import XExtension
class DZDealListViewTransverseCell:BaseTableViewCell{
    override func initUI() {
        self.icon = UIImageView(frame: CGRect(x:0, y:0, width:0, height:120))
        self.title = UILabel(frame: CGRect(x:0, y:0, width:0, height: 20))
        self.addSubviews([self.title,self.icon])
        self.title.text = "name"
        self.icon.image = UIImage(named:"taobaomini2")
    }
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    func initUI() {
        super.initUI()
        icon.frame = CGRect(x: 10, y: 0, width: APPW - 20, height: 60)
        title.frame = CGRect(x: X(icon), y: YH(icon), width: W(icon), height: 30)
        script.frame = CGRect(x: X(title), y: YH(title), width: W(title), height: 13)
        title.numberOfLines = 0
        title.font = fontnomal
        script.font = Font(11)
        line.frame = CGRect(x: 0, y: 100 - 1, width: APPW, height: 1)
    }
    
    func setDataWithDict(_ dict: [AnyHashable: Any]?) {
        icon.image = UIImage(named: "image4.jpg")
        title.text = "与爱齐名，为有初心不变，小编为大家收集了超多好文好店，从手工匠人到原型设计，他们并没有忘记"
        script.text = "地道风味 精选外卖优惠"
    }

}
class DZDealListViewVerticalCell:BaseTableViewCell{
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    func initUI() {
        super.initUI()
        icon.frame = CGRect(x: 10, y: 10, width: 70, height: 70)
        name = UILabel(frame: CGRect(x: XW(icon) + 10, y: 10, width: APPW - XW(icon) - 30, height: 20), font: fontSmallTitle, color: RGBCOLOR(0, 111, 255), text: nil)
        times = UILabel(frame: CGRect(x: APPW - 100, y: Y(name), width: 80, height: 15), font: Font(11), color: graycolor, text: nil)
        times.textAlignment = .right
        title.frame = CGRect(x: X(name), y: YH(name) + 5, width: W(name), height: 20)
        title.font = fontnomal
        script.frame = CGRect(x: X(title), y: YH(title) + 5, width: 80, height: 20)
        sees = UILabel(frame: CGRect(x: X(times), y: Y(script), width: W(times), height: 15), font: Font(11), color: graycolor, text: nil)
        sees.textAlignment = .right
        line.frame = CGRect(x: 0, y: 100 - 1, width: APPW, height: 1)
        script.backgroundColor = redcolor
        script.textColor = whitecolor
        addSubviews(name, times, sees, nil)
    }
    func setDataWithDict(_ dict: [AnyHashable: Any]?) {
        icon.image = UIImage(named: "image2.jpg")
        name.text = "传说张无忌肉夹馍"
        times.text = "2.3km"
        picV.image = UIImage(named: "image4.jpg")
        title.text = "49分钟送达|起送￥20.0|配送￥3.0"
        script.text = "满20减10"
        sees.text = "月售1000"
    }

    
}
class DZDealListViewController: DianpingBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
        func viewDidLoad() {
            super.viewDidLoad()
            tableView = UITableView(frame: CGRect(x: 0, y: 0, width: APPW, height: view.frameHeight - 20), style: .plain)
            dataArray = ["b", "a", "v", "f", "d", "a", "w", "u", "n", "o", "b", "a", "v", "f", "d", "a", "w", "u", "n", "o", "b", "a", "v", "f", "d", "a", "w", "u", "n", "o", "2"]
            tableView.dataSource = self
            tableView.delegate = self
            view.addSubview(tableView)
        }

        // Do any additional setup after loading the view.
    }
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: BaseTableViewOCCell?
        if indexPath.row % 5 != 0 {
            //竖着的
            cell = tableView.dequeueReusableCell(withIdentifier: DZDealListViewVerticalCell.getTableCellIdentifier())
            if cell == nil {
                cell = DZDealListViewVerticalCell.getInstance()
            }
        } else {
            //横着的
            cell = tableView.dequeueReusableCell(withIdentifier: DZDealListViewTransverseCell.getTableCellIdentifier())
            if cell == nil {
                cell = DZDealListViewTransverseCell.getInstance()
            }
        }
        cell?.dataWithDict = nil
        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushController(DZDealDetailViewController.self, withInfo: nil, withTitle: "详情", withOther: nil)
    }


}
