//
//  JFClassifyViewController.swift
//  Freedom
import UIKit
import BaseFile
import XExtension
import MJRefresh
class IqiyiClassifyModel: NSObject {
    var normal_icon_for_ipad_v_4 = ""
    var top_state: NSNumber?
    var selected_icon_for_v_4 = ""
    var tabs = [AnyHashable]()
    var image_at_bottom = ""
    var the_whole_state: NSNumber?
    var display_flag: NSNumber?
    var selected_icon = ""
    var label_top_state: NSNumber?
    var selected_icon_for_apad_v_4 = ""
    var normal_icon_for_apad_v_4 = ""
    var choiceness_state: NSNumber?
    var is_listing: NSNumber?
    var redirect_type = ""
    var channel_order_for_pad: NSNumber?
    var icon = ""
    var image_at_top = ""
    var show_operation: NSNumber?
    var display_flag_bak: NSNumber?
    var selected_icon_for_ipad_v_4_1_plus = ""
    var tagType: NSNumber?
    var label_tops = [AnyHashable]()
    var tabs_state: NSNumber?
    var young_app_launcher = ""
    var normal_icon_for_v_4 = ""
}
class IqiyiClassifyCell: UITableViewCell {
    var classifyModel: IqiyiClassifyModel?
    func setClassifyModel(_ classifyModel: IqiyiClassifyModel?) {
        self.classifyModel = classifyModel
        imageView?.sd_setImage(with: URL(string: classifyModel?.image_at_bottom ?? ""), placeholderImage: UIImage(named: "home_GaoXiao"))
        textLabel?.text = classifyModel?.image_at_top
    }
}
class TEMPBASEC:BaseTableViewCell{
    override func initUI() {
        self.icon = UIImageView(frame: CGRect(x:0, y:0, width:0, height:120))
        self.title = UILabel(frame: CGRect(x:0, y:0, width:0, height: 20))
        self.addSubviews([self.title,self.icon])
        self.title.text = "name"
        self.icon.image = UIImage(named:"taobaomini2")
    }
}
class IqiyiClassifyViewController: IqiyiBaseViewController {
    let urlStr = urlWithclassifyData
    var dataSource = [AnyHashable]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH - 64), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        //将系统的Separator左边不留间隙
        tableView.separatorInset = UIEdgeInsets.zero
        view.addSubview(tableView)
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {() -> Void in
        })
        tableView.mj_header.beginRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ID = "JFClassifyCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID) as? IqiyiClassifyCell
        if cell == nil {
            // 从xib中加载cell
            cell = IqiyiClassifyCell(style: .default, reuseIdentifier: ID)
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = IqiyiWebViewController()
        webVC.urlStr = TestWebURL
        navigationController?.pushViewController(webVC, animated: true)
    }
}
