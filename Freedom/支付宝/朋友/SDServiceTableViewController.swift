//
//  SDServiceTableViewController.swift
//  Freedom
//
//  Created by htf on 2018/5/17.
//  Copyright © 2018年 薛超. All rights reserved.
//

import UIKit
import BaseFile
import XExtension
class SDServiceTableViewCellModel: NSObject {
    var title = ""
    var detailString = ""
    var iconImageURLString = ""
    
    convenience init(title: String?, detailString: String?, iconImageURLString: String?) {
        let model = SDServiceTableViewCellModel()
        model.title = title ?? ""
        model.detailString = detailString ?? ""
        model.iconImageURLString = iconImageURLString ?? ""
        return model
    }
}
class SDServiceTableViewCell:BaseTableViewCell{
    init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        iconView = UIImageView(frame: CGRect(x: 10, y: 10, width: 100, height: 80))
        titleLabel = UILabel(frame: CGRect(x: 120, y: 10, width: 200, height: 20))
        detailLabel = UILabel(frame: CGRect(x: 120, y: 40, width: 200, height: 20))
        iconView.layer.cornerRadius = 4
        iconView.clipsToBounds = true
        titleLabel?.font = Font(16)
        detailLabel.font = Font(14)
        detailLabel.textColor = UIColor.gray
        addSubviews(iconView, titleLabel, detailLabel, nil)
    }

    func setModel(_ model: NSObject?) {
        super.setModel(model)
        let cellModel = model as? SDServiceTableViewCellModel
        titleLabel?.text = cellModel?.title
        detailLabel.text = cellModel?.detailString
        iconView.sd_setImage(with: URL(string: cellModel?.iconImageURLString ?? ""), placeholderImage: nil)
    }
    

}
class SDServiceTableViewHeader : UIView{

    init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        let textField = UITextField()
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        textField.backgroundColor = UIColor.white
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.addTarget(self, action: Selector("textFieldValueChanged:"), for: .editingChanged)
        textField.clearButtonMode = .always
        textField.delegate = self
        addSubview(textField)
        self.textField = textField
        let searchIcon = UIImageView(image: UIImage(named: Psearch))
        searchIcon.contentMode = .scaleAspectFill
        self.textField.addSubview(searchIcon)
        textFieldSearchIcon = searchIcon
        let placeholderLabel = UILabel()
        placeholderLabel.font = self.textField.font
        placeholderLabel.textColor = UIColor.lightGray
        textField.addSubview(placeholderLabel)
        textFieldPlaceholderLabel = placeholderLabel
        
    }
    func setPlaceholderText(_ placeholderText: String?) {
        self.placeholderText = placeholderText
        textFieldPlaceholderLabel.text = placeholderText
    }
    
    func layoutSubviews() {
        let margin: CGFloat = 8
        textField.frame = CGRect(x: margin, y: margin, width: frameWidth - margin * 2, height: frameHeight - margin * 2)
        layoutTextFieldSubviews()
        if textField.leftView == nil {
            let leftView = UIView(frame: CGRect(x: 0, y: 0, width: textFieldSearchIcon.frameHeight * 1.4, height: textFieldSearchIcon.frameHeight))
            textField.leftView = leftView
            textField.leftViewMode = .always
        }
    }
    func layoutTextFieldSubviews() {
        let rect: CGRect = placeholderText.boundingRect(with: CGSize(width: textField.frameWidth * 0.7, height: textField.frameHeight), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: textFieldPlaceholderLabel.font], context: nil)
        textFieldPlaceholderLabel.bounds = CGRect(x: 0, y: 0, width: rect.size.width, height: textField.frameHeight)
        textFieldPlaceholderLabel.center = CGPoint(x: textField.frameWidth * 0.5, y: textField.frameHeight * 0.5)
        textFieldSearchIcon.bounds = CGRect(x: 0, y: 0, width: textField.frameHeight * 0.6, height: textField.frameHeight * 0.6)
        textFieldSearchIcon.center = CGPoint(x: textFieldPlaceholderLabel.frameX - textFieldSearchIcon.frameWidth * 0.5, y: textFieldPlaceholderLabel.center.y)
    }
    
    func textFieldValueChanged(_ field: UITextField?) {
        textFieldPlaceholderLabel.hidden = (field?.text?.count ?? 0) != 0
    }
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textField.becomeFirstResponder()
        let deltaX: CGFloat = textFieldSearchIcon.frameX - 5
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            textFieldSearchIcon.transform = CGAffineTransform(translationX: -deltaX, y: 0)
            textFieldPlaceholderLabel.transform = CGAffineTransform(translationX: -deltaX, y: 0)
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            textFieldSearchIcon.transform = .identity
            textFieldPlaceholderLabel.transform = .identity
        })
        self.textField.text = ""
        textFieldPlaceholderLabel.hidden = false
    }
        
}
class SDServiceTableViewController: AlipayBaseViewController {
    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem?.title = "朋友"
        refreshMode = BaseTableViewRefeshModeHeaderRefresh
        tableView.rowHeight = 70
        let header = SDServiceTableViewHeader()
        header.frameHeight = 44
        header.placeholderText = "搜索朋友"
        tableView.tableHeaderView = header
        cellClass = SDServiceTableViewCell.self
        setupModel()
    }
    func setupModel() {
        var temp = [AnyHashable]()
        for i in 0..<12 {
            let model = SDServiceTableViewCellModel(title: "服务提醒 -- \(i)", detailString: "服务提醒摘要 -- \(i)", iconImageURLString: "http://f.vip.duba.net/data/avatar//201309/9/328/137871226483UB.jpg")
            temp.append(model)
        }
        sectionsNumber = 1
        dataArray = temp
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let insets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        // 三个方法并用，实现自定义分割线效果
        if cell.responds(to: Selector("setSeparatorInset:")) {
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
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((int64_t)(2.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {() -> Void in
            self.refreshControl?.endRefreshing()
        })
    }


    
    
}
