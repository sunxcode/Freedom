//
//  SDServiceTableViewController.swift
//  Freedom

import UIKit
import BaseFile
import XExtension
import MJRefresh
class SDServiceTableViewCellModel: NSObject {
    var title = ""
    var detailString = ""
    var iconImageURLString = ""
}
class SDServiceTableViewCell:BaseTableViewCell{
    required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        icon = UIImageView(frame: CGRect(x: 10, y: 10, width: 100, height: 80))
        title = UILabel(frame: CGRect(x: 120, y: 10, width: 200, height: 20))
        script = UILabel(frame: CGRect(x: 120, y: 40, width: 200, height: 20))
        icon.layer.cornerRadius = 4
        icon.clipsToBounds = true
        title.font = Font(16)
        script.font = Font(14)
        script.textColor = UIColor.gray
        addSubviews([icon, title, script])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setModel(_ model: NSObject?) {
        let cellModel = model as? SDServiceTableViewCellModel
        title.text = cellModel?.title
        script.text = cellModel?.detailString
        icon.sd_setImage(with: URL(string: cellModel?.iconImageURLString ?? ""), placeholderImage: nil)
    }
}
class SDServiceTableViewHeader : UIView,UITextFieldDelegate{
    var textField = UITextField()
    var textFieldSearchIcon = UIImageView()
    let textFieldPlaceholderLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        let textField = UITextField()
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        textField.backgroundColor = UIColor.white
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.addTarget(self, action: Selector("textFieldValueChanged:"), for: .editingChanged)
        textField.clearButtonMode = .always
        textField.delegate = self as! UITextFieldDelegate
        addSubview(textField)
        self.textField = textField
        let searchIcon = UIImageView(image: UIImage(named: "search"))
        searchIcon.contentMode = .scaleAspectFill
        self.textField.addSubview(searchIcon)
        textFieldSearchIcon = searchIcon
        textFieldPlaceholderLabel.font = self.textField.font
        textFieldPlaceholderLabel.textColor = UIColor.lightGray
        textField.addSubview(textFieldPlaceholderLabel)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setPlaceholderText(_ placeholderText: String?) {
        textFieldPlaceholderLabel.text = placeholderText
    }
    
    override func layoutSubviews() {
        let margin: CGFloat = 8
        layoutTextFieldSubviews()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: textFieldSearchIcon.frameHeight * 1.4, height: textFieldSearchIcon.frameHeight))
        textField.leftViewMode = .always
    }
    func layoutTextFieldSubviews() {
        let rect: CGRect = CGRect(x: 0, y: 0, width: APPW, height: 200)
        textFieldPlaceholderLabel.bounds = CGRect(x: 0, y: 0, width: rect.size.width, height: textField.frameHeight)
        textFieldPlaceholderLabel.center = CGPoint(x: textField.frame.size.width * 0.5, y: textField.frameHeight * 0.5)
        textFieldSearchIcon.bounds = CGRect(x: 0, y: 0, width: textField.frameHeight * 0.6, height: textField.frameHeight * 0.6)
        textFieldSearchIcon.center = CGPoint(x: textFieldPlaceholderLabel.frameX - textFieldSearchIcon.frame.size.width * 0.5, y: textFieldPlaceholderLabel.center.y)
    }
    
    func textFieldValueChanged(_ field: UITextField?) {
        textFieldPlaceholderLabel.isHidden = (field?.text?.count ?? 0) != 0
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textField.becomeFirstResponder()
        let deltaX: CGFloat = textFieldSearchIcon.frameX - 5
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.textFieldSearchIcon.transform = CGAffineTransform(translationX: -deltaX, y: 0)
            self.textFieldPlaceholderLabel.transform = CGAffineTransform(translationX: -deltaX, y: 0)
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.textFieldSearchIcon.transform = .identity
            self.textFieldPlaceholderLabel.transform = .identity
        })
        self.textField.text = ""
        textFieldPlaceholderLabel.isHidden = false
    }
        
}
class SDServiceTableViewController: AlipayBaseViewController {

    let cellClass = SDServiceTableViewCell.self
    var dataArray = [SDServiceTableViewCellModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "朋友"
        tableView.rowHeight = 70
        let header = SDServiceTableViewHeader(frame: CGRect.zero)
        header.frameHeight = 44
        header.setPlaceholderText("搜索朋友")
        tableView.tableHeaderView = header
        setupModel()
    }
    func setupModel() {
        var temp = [AnyHashable]()
        for i in 0..<12 {
            let model = SDServiceTableViewCellModel()
            model.title = "服务提醒 -- \(i)"
            model.detailString = "服务提醒摘要 -- \(i)"
            model.iconImageURLString = "http://f.vip.duba.net/data/avatar//201309/9/328/137871226483UB.jpg"
            temp.append(model)
        }
//        sectionsNumber = 1
        dataArray = temp as! [SDServiceTableViewCellModel]
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model: SDServiceTableViewCellModel? = dataArray[indexPath.row]
        let vc = BaseTableView() as? UIViewController
        vc?.title = model?.title
        if let aVc = vc {
            navigationController?.pushViewController(aVc, animated: true)
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        tableView.endEditing(true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let insets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        // 三个方法并用，实现自定义分割线效果
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = insets
        }
        if cell.responds(to: Selector("setLayoutMargins:")) {
            cell.layoutMargins = insets
        }
        if cell.responds(to: Selector("setPreservesSuperviewLayoutMargins:")) {
            cell.preservesSuperviewLayoutMargins = false
        }
    }
    // MARK: - pull down refresh
    func pullDownRefreshOperation() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(2.0 * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {() -> Void in
//            self.refreshControl?.endRefreshing()
        })
    }
    
}
