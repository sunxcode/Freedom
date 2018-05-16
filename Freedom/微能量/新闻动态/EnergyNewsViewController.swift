//
//  EnergyNewsViewController.swift
//  Freedom
import UIKit
import BaseFile
import XExtension
import XCarryOn
class EnergyNewsViewCell:BaseTableViewCell{
    override func initUI() {
        accessoryType = .disclosureIndicator
        self.icon = UIImageView(frame: CGRect(x: 10, y: 10, width: 50, height:50))
        self.title = UILabel(frame: CGRect(x:XW(obj: self.icon)+20, y: (70-20)/2.0, width: APPW-XW(obj: self.icon), height: 20))
        self.line = UIView(frame: CGRect(x: 10, y: 69, width: APPW-20, height: 1))
        self.addSubviews([self.title,self.icon,self.line])
        self.title.text = "name"
        self.icon.image = UIImage(named:"taobaomini3")
    }
}
class EnergyNewsViewController: EnergyBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "新闻动态";
    self.tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH-TopHeight))
        self.cellHeight = 70
        self.tableView.dataArray = NSMutableArray(array: ["人人店分销团队如何持续裂变","微营销流量引入的几点思考","”微时代 新电商“邀您对话千万资产","养出80%的回购率","0.2元低成本吸粉的玩法","阿罗古堡人人店，上线当月销量近60万","高潮迭起 微巴人人店征战中国","微营销对话微市场，新时代的迭起"])
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    view.addSubview(tableView)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: EnergyNewsViewCell.getTableCellIdentifier()) as? EnergyNewsViewCell
        if cell == nil{
            cell = EnergyNewsViewCell.getInstance() as? EnergyNewsViewCell
        }
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = self.tableView.dataArray[indexPath.row]
        _ = self.push(EnergyNewsDetailViewController(), withInfo: "", withTitle: value as! String, withOther: value)
    }

}
