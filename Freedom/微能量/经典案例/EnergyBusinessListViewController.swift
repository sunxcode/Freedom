//
//  EnergyBusinessListViewController.swift
//  Freedom
import UIKit
import BaseFile
import XExtension
import XCarryOn
class EnergyBusinessViewCell:BaseTableViewCell{
    override func initUI() {
        accessoryType = .disclosureIndicator
        self.icon = UIImageView(frame: CGRect(x: 10, y: 10, width:50, height:50))
        self.title = UILabel(frame: CGRect(x:XW( self.icon)+20, y:(70-20)/2.0, width: APPW-XW( self.icon), height: 20))
        self.line = UIView(frame: CGRect(x: 10, y: 69, width: APPW-20, height: 1))
        self.addSubviews([self.title,self.icon,self.line])
        self.title.text = "name"
        self.icon.image = UIImage(named:"taobaomini3")
    }
}
class EnergyBusinessListViewController: EnergyBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
self.tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH-TopHeight))
        self.cellHeight = 70
        self.tableView.dataArray = NSMutableArray(array: ["桌上美食","真心真艺","音响科技有限公司","智联招聘","前程无忧","百度百科","雅虎中国","360","布丁酒店","如家","莫泰168","宜家家居","微软中国","苹果公司","IBM"])
     self.tableView.delegate = self;
    self.tableView.dataSource = self;
        view.addSubview(self.tableView)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: EnergyBusinessViewCell.getTableCellIdentifier()) as? EnergyBusinessViewCell
        if cell == nil{
            cell = EnergyBusinessViewCell.getInstance() as? EnergyBusinessViewCell
        }
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = self.tableView.dataArray[indexPath.row]
        _ = self.push(EnergyBusinessDetailViewController(), withInfo: "", withTitle: value as! String, withOther: value)
    }

}
