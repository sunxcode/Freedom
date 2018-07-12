//
//  LookViewController.swift
//  Freedom
import UIKit
import BaseFile
import XExtension
class KugouLookViewCell:BaseTableViewCell{
    override func initUI() {
        self.icon = UIImageView(frame: CGRect(x:0, y:0, width:0, height:120))
        self.title = UILabel(frame: CGRect(x:0, y:0, width:0, height: 20))
        self.addSubviews([self.title,self.icon])
        self.title.text = "name"
        self.icon.image = UIImage(named:"taobaomini2")
    }
}
class KugouLookViewController: KugouBaseViewController {
    var titlesArr = [Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        titlesArr = ["繁星MV", "明星在线", "线下演出"]
        setupTableView()
    }
    var headerView: UIView? {
        let headerView1 = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 100))
        headerView1.backgroundColor = UIColor.white
        view.addSubview(headerView1)
        let banner = UIImageView(frame: CGRect(x: 0, y: 0, width: APPW, height: 150))
        banner.image = UIImage(named: "bj")
        headerView1.addSubview(banner)
        let btnW: CGFloat = 80
        let btnH: CGFloat = 100
        let magin: CGFloat = (APPW - 3 * btnW) / 4.0
        let titleArr = ["MV", "繁星直播", "酷狗LIVE"]
        for i in 0..<3 {
            let btnX: CGFloat = magin + (magin + btnW) * CGFloat(i)
            let btn = UIButton(frame: CGRect(x: btnX, y: banner.frameHeight + 15, width: btnW, height: btnH))
            btn.imageView?.contentMode = .scaleAspectFit
            btn.titleLabel?.textAlignment = .center
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.setImage(UIImage(named: "n\(i + 1)"), for: .normal)
            btn.setTitle(titleArr[i], for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            headerView1.addSubview(btn)
        }
        return headerView1
    }
    func setupTableView() {
        self.tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: Int(APPW), height: Int(APPH - TabBarH) + 2), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = headerView
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        view.addSubview(tableView)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mainCellID = "mainID"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: mainCellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: mainCellID)
        }
        cell?.imageView?.image = UIImage(named: "music")
        cell?.textLabel?.text = titlesArr[indexPath.row] as? String
        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
