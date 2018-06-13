//
//  EnergyContactUSViewController.swift
//  Freedom
import UIKit
import BaseFile
import XExtension
import XCarryOn
class EnergyContactUSViewCell:BaseTableViewCell{
    override func initUI() {
        accessoryType = .disclosureIndicator
        self.icon = UIImageView(frame: CGRect(x: 10, y: 10, width:60, height: 60))
        self.title = UILabel(frame: CGRect(x: XW( self.icon)+20, y: (80-20)/2.0, width: APPW-XW( self.icon), height: 20))
        self.line = UIView(frame:CGRect(x: 10, y: 79, width: APPW-20, height: 1))
        self.addSubviews([self.title,self.icon,line])
        self.title.text = ""
        self.icon.image = UIImage(named:"taobaomini3")
    }
}
class EnergyContactUSViewController: EnergyBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    self.title = "联系我们"
    let banner = BaseScrollView(banner: CGRect(x: 0, y: 0, width: APPW, height: 120), icons: ["",""])
        banner.backgroundColor = .red
        self.tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH-TopHeight))
        self.cellHeight = 80
        self.tableView.dataArray = NSMutableArray(array: ["一键导航","关注公众号","查看历史消息","微信营销交流","客服聊天","诚聘精英"])
    self.tableView.tableHeaderView = banner
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    view.addSubview(tableView)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: EnergyContactUSViewCell.getTableCellIdentifier()) as? EnergyContactUSViewCell
        if cell == nil{
            cell = EnergyContactUSViewCell.getInstance() as? EnergyContactUSViewCell
        }
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let value = self.tableView.dataArray[indexPath.row];
        _ = self.push(EnergyContactDetailViewController(), withInfo: "", withTitle: value as! String, withOther: value)
    }
}
