//
//  SDDiscoverTableViewController.swift
//  Freedom
import UIKit
import BaseFile
import XExtension
class SDDiscoverTableViewHeaderItemButton: UIButton {
    var imageName = ""
    var title = ""
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(UIColor.black, for: .normal)
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        imageView?.contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let x: CGFloat = contentRect.size.width * 0.2
        let y: CGFloat = contentRect.size.height * 0.15
        let w: CGFloat = contentRect.size.width - x * 2
        let h: CGFloat = contentRect.size.height * 0.5
        let rect = CGRect(x: x, y: y, width: w, height: h)
        return rect
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = CGRect(x: 0, y: contentRect.size.height * 0.65, width: contentRect.size.width, height: contentRect.size.height * 0.3)
        return rect
    }
    func setTitle(_ title: String?) {
        self.title = title!
        setTitle(title, for: .normal)
    }
    func setImageName(_ imageName: String?) {
        self.imageName = imageName!
        setImage(UIImage(named: imageName ?? ""), for: .normal)
    }
}
class SDDiscoverTableViewHeader: UIView {
    var headerItemModelsArray = [Any]()
    var buttonClickedOperationBlock: ((_ index: Int) -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setHeaderItemModelsArray(_ headerItemModelsArray: [Any]?) {
        self.headerItemModelsArray = headerItemModelsArray!
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if subviews.count == 0 {
            return
        }
//        let w = frame.size.width / subviews.count
        let h: CGFloat = frameHeight
    }
    
    func buttonClickd(_ button: SDDiscoverTableViewHeaderItemButton?) {
        if (buttonClickedOperationBlock != nil) {
            buttonClickedOperationBlock!((button?.tag)!)
        }
    }
}

class SDDiscoverTableViewHeaderItemModel: NSObject {
    var imageName = ""
    var title = ""
    var destinationControllerClass: AnyClass?
    convenience init(title: String?, imageName: String?, destinationControllerClass: AnyClass) {
        self.init()
        self.title = title!
        self.imageName = imageName!
        self.destinationControllerClass = destinationControllerClass
    }
}
class SDDiscoverTableViewControllerCell:BaseTableViewCell{
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
class SDDiscoverTableViewController: AlipayBaseViewController {
    var dataArray = [[SDAssetsTableViewControllerCellModel]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "口碑"
//        cellClass = SDDiscoverTableViewControllerCell.self
        setupHeader()
        setupModel()
//        sectionsNumber = dataArray.count
    }
    func setupHeader() {
        let model0 = SDDiscoverTableViewHeaderItemModel(title: "红包", imageName: "adw_icon_apcoupon_normal", destinationControllerClass: BaseTableView.self)
        let model1 = SDDiscoverTableViewHeaderItemModel(title: "电子券", imageName: "adw_icon_coupon_normal", destinationControllerClass: BaseTableView.self)
        let model2 = SDDiscoverTableViewHeaderItemModel(title: "行程单", imageName: "adw_icon_travel_normal", destinationControllerClass: BaseTableView.self)
        let model3 = SDDiscoverTableViewHeaderItemModel(title: "会员卡", imageName: "adw_icon_membercard_normal", destinationControllerClass: BaseTableView.self)
        let headerDataArray = [model0, model1, model2, model3]
        let header = SDDiscoverTableViewHeader(frame: CGRect.zero)
        header.frameHeight = 90
        header.headerItemModelsArray = headerDataArray
        header.buttonClickedOperationBlock = {(_ index: Int) -> Void in
            let vc: UIViewController? = UIViewController()//model?.destinationControllerClass
            vc?.title = ""// model?.title
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        tableView.tableHeaderView = header
    }
    func setupModel() {
        // section 0 的model
        let model01 = SDAssetsTableViewControllerCellModel(title: "淘宝电影", iconImageName: "adw_icon_movie_normal", destinationControllerClass: BaseTableView.self)
        let model02 = SDAssetsTableViewControllerCellModel(title: "快抢", iconImageName: "adw_icon_flashsales_normal", destinationControllerClass: BaseTableView.self)
        let model03 = SDAssetsTableViewControllerCellModel(title: "快的打车", iconImageName: "adw_icon_taxi_normal", destinationControllerClass: BaseTableView.self)
        // section 1 的model
        let model11 = SDAssetsTableViewControllerCellModel(title: "我的朋友", iconImageName: "adw_icon_contact_normal", destinationControllerClass: BaseTableView.self)
        dataArray = [[model01, model02, model03], [model11]]
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
