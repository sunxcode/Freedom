//
//  SDAssetsTableViewController.swift
//  Freedom

import UIKit
import BaseFile
import XExtension
class SDAssetsTableViewControllerCell:BaseTableViewCell{
    required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textLabel?.textColor = UIColor.darkGray
        textLabel?.font = UIFont.systemFont(ofSize: 15)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setModel(_ model: NSObject?) {
        let cellModel = model as? SDAssetsTableViewControllerCellModel
        textLabel?.text = cellModel?.title
        imageView?.image = UIImage(named: cellModel?.iconImageName ?? "")
        accessoryType = .disclosureIndicator
    }

}
class SDAssetsTableViewController: AlipayBaseViewController {
    var dataArray = [[SDAssetsTableViewControllerCellModel]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "我的"
        setupModel()
        let header = UIView()
        tableView.tableHeaderView = header
    }
    func setupModel() {
        // section 0 的model
        let model01 = SDAssetsTableViewControllerCellModel(title: "余额宝", iconImageName: "20000032Icon", destinationControllerClass: SDYuEBaoTableViewController.self)
        let model02 = SDAssetsTableViewControllerCellModel(title: "招财宝", iconImageName: "20000059Icon", destinationControllerClass: BaseTableView.self)
        let model03 = SDAssetsTableViewControllerCellModel(title: "娱乐宝", iconImageName: "20000077Icon", destinationControllerClass: BaseTableView.self)
        // section 1 的model
        let model11 = SDAssetsTableViewControllerCellModel(title: "芝麻信用分", iconImageName: "20000118Icon", destinationControllerClass: BaseTableView.self)
        let model12 = SDAssetsTableViewControllerCellModel(title: "随身贷", iconImageName: "20000180Icon", destinationControllerClass: BaseTableView.self)
        let model13 = SDAssetsTableViewControllerCellModel(title: "我的保障", iconImageName: "20000110Icon", destinationControllerClass: BaseTableView.self)

        let model21 = SDAssetsTableViewControllerCellModel(title: "爱心捐赠", iconImageName: "09999978Icon", destinationControllerClass: BaseTableView.self)
        dataArray = [[model01, model02, model03], [model11, model12, model13], [model21]]
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArray[indexPath.section][indexPath.row] as? SDAssetsTableViewControllerCellModel
        let vc: UIViewController? = UIViewController()// model?.destinationControllerClass
        vc?.title = model?.title
        if let aVc = vc {
            navigationController?.pushViewController(aVc, animated: true)
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (section == dataArray.count - 1) ? 10 : 0
    }
}
