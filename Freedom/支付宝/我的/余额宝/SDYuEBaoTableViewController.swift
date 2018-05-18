//
//  SDYuEBaoTableViewController.swift
//  Freedom
//
//  Created by htf on 2018/5/18.
//  Copyright © 2018年 薛超. All rights reserved.
//

import UIKit
class SDYuEBaoTableViewCellModel: NSObject {
    var yesterdayIncome: Float = 0.0
    var totalMoneyAmount: Float = 0.0
}
class SDYuEBaoTableViewCellContentView: UIView {
    var yesterdayIncome: Float = 0.0
    var totalMoneyAmount: Float = 0.0
    
    var yesterdayIncomeLabel: UILabel?
    var totalMoneyAmountLabel: UILabel?
    
    private var yesterdayIncomeLabelAnimationTimer: Timer?
    private var totalMoneyAmountLabelAnimationTimer: Timer?
    
    //  The converted code is limited to 1 KB.
    //  Please Sign Up (Free!) to remove this limitation.
    //
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    init(frame: CGRect) {
        super.init(frame: frame)
        let yestodayView = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 180))
        let IncomeView = UIView(frame: CGRect(x: 0, y: 200, width: APPW, height: 100))
        let shouyiView = UIView(frame: CGRect(x: 0, y: YH(IncomeView), width: APPW, height: 150))
        yestodayView.backgroundColor = RGBCOLOR(255, 80, 2)
        shouyiView.backgroundColor = UIColor.lightGray
        let yI = UIImageView(frame: CGRect(x: 15, y: 20, width: 10, height: 10))
        let yl = UILabel(frame: CGRect(x: XW(yI), y: 15, width: 100, height: 20))
        let yesIncomeL = UILabel(frame: CGRect(x: 10, y: 30, width: APPW, height: 120))
        yI.image = UIImage(named: "calendar")
        yl.text = "昨日收益 (元)"
        yl.textColor = UIColor.white
        yl.font = fontnomal
        yesIncomeL.font = BoldFont(48)
        yesIncomeL.textColor = UIColor.white
        yesterdayIncomeLabel = yesIncomeL
        totalMoneyAmountLabel = UILabel(frame: CGRect(x: 10, y: 50, width: APPW - 20, height: 80))
        let totalL = UILabel(frame: CGRect(x: 10, y: 10, width: APPW - 20, height: 20))
        totalL.textColor = UIColor.lightGray
        totalL.font = fontnomal
        totalL.text = "总金额（元）"
        totalMoneyAmountLabel.textColor = UIColor.red
        totalMoneyAmountLabel.font = BoldFont(38)
        yesterdayIncomeLabel.text = "0.00"
        totalMoneyAmountLabel.text = "0.00"
        let a = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 20))
        let av = UILabel(frame: CGRect(x: 10, y: 30, width: 100, height: 20))
        let b = UILabel(frame: CGRect(x: APPW / 2, y: 10, width: 100, height: 20))
        let bv = UILabel(frame: CGRect(x: APPW / 2, y: 30, width: 100, height: 20))
        let c = UILabel(frame: CGRect(x: 10, y: 60, width: 100, height: 20))
        let cv = UILabel(frame: CGRect(x: 10, y: 80, width: 100, height: 20))
        let d = UILabel(frame: CGRect(x: APPW / 2, y: 60, width: 100, height: 20))
        let dv = UILabel(frame: CGRect(x: APPW / 2, y: 80, width: 100, height: 20))
        d.textColor = UIColor.gray
        c.textColor = d.textColor
        b.textColor = c.textColor
        a.textColor = b.textColor
        dv.textColor = UIColor.black
        cv.textColor = dv.textColor
        bv.textColor = cv.textColor
        av.textColor = bv.textColor
        dv.font = Font(14)
        cv.font = dv.font
        bv.font = cv.font
        av.font = bv.font
        d.font = av.font
        c.font = d.font
        b.font = c.font
        a.font = b.font
        a.text = "万份收益（元）"
        av.text = "1.0876"
        b.text = "累计收益（元）"
        bv.text = "1.0876"
        c.text = "近一周收益（元）"
        cv.text = "1.823"
        d.text = "近一月收益（元）"
        dv.text = "2.023"
        yestodayView.addSubviews(yI, yl, yesIncomeL, nil)
        IncomeView.addSubviews(totalL, totalMoneyAmountLabel, nil)
        shouyiView.addSubviews(a, av, b, bv, c, cv, d, dv, nil)
        addSubviews(yestodayView, IncomeView, shouyiView, nil)
    }
    func setYesterdayIncome(_ yesterdayIncome: Float) {
        self.yesterdayIncome = yesterdayIncome
        setNumberTextOfLabel(yesterdayIncomeLabel, withAnimationForValueContent: yesterdayIncome)
    }
    
    func setTotalMoneyAmount(_ totalMoneyAmount: Float) {
        self.totalMoneyAmount = totalMoneyAmount
        setNumberTextOfLabel(totalMoneyAmountLabel, withAnimationForValueContent: totalMoneyAmount)
    }
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    func setNumberTextOf(_ label: UILabel?, withAnimationForValueContent value: CGFloat) {
        let lastValue = CGFloat(Float(label?.text ?? "") ?? 0.0)
        let delta: CGFloat = value - lastValue
        if delta == 0 {
            return
        }
        if delta > 0 {
            let ratio: CGFloat = value / 60.0
            let userInfo = ["label": label, "value": value, "ratio": ratio]
            let timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: Selector("setupLabel:"), userInfo: userInfo, repeats: true)
            if label == yesterdayIncomeLabel {
                yesterdayIncomeLabelAnimationTimer = timer
            } else {
                totalMoneyAmountLabelAnimationTimer = timer
            }
        }
    }
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    func setupLabel(_ timer: Timer?) {
        var timer = timer
        let userInfo = timer?.userInfo as? [AnyHashable: Any]
        let label = userInfo["label"] as? UILabel
        let value = CGFloat(Float(userInfo["value"]))
        let ratio = CGFloat(Float(userInfo["ratio"]))
        var flag: Int = 1
        let lastValue = CGFloat(Float(label?.text ?? "") ?? 0.0)
        let randomDelta: CGFloat = (arc4random_uniform(2) + 1) * ratio
        let resValue: CGFloat = lastValue + randomDelta
        if (resValue >= value) || (flag == 50) {
            label?.text = String(format: "%.2f", value)
            flag = 1
            timer?.invalidate()
            timer = nil
            return
        } else {
            label?.text = String(format: "%.2f", resValue)
        }
        flag += 1
    }

    

}
class SDYuEBaoTableViewCell {
    private var cellContentView: SDYuEBaoTableViewCellContentView?
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let contentView = SDYuEBaoTableViewCellContentView()
        self.contentView.addSubview(contentView)
        cellContentView = contentView
        selectionStyle = .none
        
    }
    func setModel(_ model: NSObject?) {
        super.setModel(model)
        let cellModel = model as? SDYuEBaoTableViewCellModel
        cellContentView.totalMoneyAmount = cellModel?.totalMoneyAmount
        cellContentView.yesterdayIncome = cellModel?.yesterdayIncome
    }

}

class SDYuEBaoTableViewController: AlipayBaseViewController {
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    func viewDidLoad() {
        super.viewDidLoad()
        cellClass = SDYuEBaoTableViewCell.self
        let model = SDYuEBaoTableViewCellModel()
        model.totalMoneyAmount = 8060.68
        model.yesterdayIncome = 1.12
        dataArray = [model]
        refreshMode = BaseTableViewRefeshModeHeaderRefresh
        tableView.separatorStyle = .none
    }
    
    // 加载数据方法
    func pullDownRefreshOperation() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((int64_t)(2.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {() -> Void in
            self.refreshControl?.endRefreshing()
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 550
    }

}
