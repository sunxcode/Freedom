//
//  JFSubscribeViewController.swift
//  Freedom

import UIKit
import BaseFile
import XExtension
import XCategory
import MJRefresh
class JFSubItemModel: NSObject {
    var itemID: NSNumber?
    var formatTotalTime = ""
    var code = ""
    var totalTime: NSNumber?
    var pubDate: NSNumber?
    var playLink = ""
    var title = ""
    var userpic_220_220 = ""
    var playNum: NSNumber?
    var bigPic = ""
    var limit: NSNumber?
    var picurl = ""
    var playtimes: NSNumber?
    var userpic = ""
    var formatPubDate = ""
    var type = ""
    var uid: NSNumber?
}

class JFSubscribeModel: NSObject {
    var video_count: NSNumber?
    var des = ""
    var title = ""
    var channelized_type = ""
    var subed_count = ""
    var last_item = [AnyHashable]()
    var podcast_user_id = ""
    var isVuser = ""
    var image = ""
    var avatar = ""
}
protocol JFSubScribeCardViewDelegate: NSObjectProtocol {
    func didSelectSubImageCard(_ subImageCard: JFSubScribeCardView?, subItem: JFSubItemModel?)
}

class JFSubImageScrollView: UIView {
    weak var delegate: JFSubScribeCardViewDelegate?
    var scrollView: UIScrollView?
    var dataArray = [Any]()
}

class JFSubScribeCardView: UIView {
    var imageView: UIImageView?
    var titleLabel: UILabel?
    var cardImageView: UIImageView?
    var cardLabel: UILabel?
    var subItem: JFSubItemModel?
    weak var delegate: JFSubScribeCardViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cardImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        cardLabel = UILabel(frame: CGRect(x: 0, y: 100, width: 200, height: 20))
        addSubviews([cardImageView!, cardLabel!])
        imageView = UIImageView(frame: CGRect(x: 5, y: 0, width: frame.size.width - 5, height: frame.size.height - 30))
        if let aView = imageView {
            addSubview(aView)
        }
        //
        titleLabel = UILabel(frame: CGRect(x: 5, y: frame.size.height - 30, width: frame.size.width - 5, height: 30))
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        titleLabel?.textColor = UIColor.black
        if let aLabel = titleLabel {
            addSubview(aLabel)
        }
        let tap = UITapGestureRecognizer(target: self, action: Selector("TapImageCard:"))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setSubItem(_ subItem: JFSubItemModel?) {
        self.subItem = subItem
        imageView?.sd_setImage(with: URL(string: subItem?.picurl ?? ""), placeholderImage: UIImage(named: "rec_holder"))
        titleLabel?.text = subItem?.title
    }
    func tapImageCard(_ sender: UITapGestureRecognizer?) {
    }
}

class JFSubscribeCell:BaseTableViewCell{
    override func initUI() {
        let backview = UIView(frame: CGRect(x: 0, y: 0, width: APPW, height: 210))
        backview.backgroundColor = UIColor.white
        addSubview(backview)
        let imageView = UIImageView(frame: CGRect(x: 10, y: 5, width: 40, height: 40))
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        backview.addSubview(imageView)
        let titleLabel = UILabel(frame: CGRect(x: 65, y: 5, width: 120, height: 25))
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = UIColor.black
        backview.addSubview(titleLabel)
        let subedLabel = UILabel(frame: CGRect(x: 65, y: 25, width: 120, height: 25))
        subedLabel.font = UIFont.systemFont(ofSize: 12)
        subedLabel.textColor = UIColor.lightGray
        backview.addSubview(subedLabel)
        let dingyueBtn = UIButton(type: .custom)
        dingyueBtn.frame = CGRect(x: APPW - 10 - 70, y: 10, width: 70, height: 29)
        dingyueBtn.setImage(UIImage(named: "search_channel_subscribe_noPlay"), for: .normal)
        dingyueBtn.setImage(UIImage(named: "search_channel_subscribed"), for: .selected)
        backview.addSubview(dingyueBtn)
        let scrollV = JFSubImageScrollView(frame: CGRect(x: 0, y: 55, width: APPW, height: 155))
//        scrollV.delegate = self
        backview.addSubview(scrollV)
    }
    func setSubscribeM(_ subscribeM: JFSubscribeModel?) {
//        self.subscribeM = subscribeM
//        items.removeAll()
//        for i in 0..<subscribeM?.last_item.count ?? 0 {
//            let item = JFSubItemModel.mj_object(withKeyValues: subscribeM?.last_item[i])
//            items.append(item)
//        }
//        imageView.sd_setImage(with: URL(string: subscribeM?.image ?? ""), placeholderImage: UIImage(named: "rec_holder"))
//        titleLabel.text = subscribeM?.title
//        if let aCount = subscribeM?.subed_count {
//            subedLabel.text = "订阅 \(aCount)"
//        }
//        scrollV.dataArray = items
    }

}
class JFSubscribeScrollView: UIScrollView {
    var dataArray: [Any]?
    var scrollView:UIScrollView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        scrollView.contentSize = CGSize(width: 2 * APPW, height: frame.size.height)
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        //card
        let cardWidth: Float = Float((APPW * 2 - 15) / 3.0)
        for i in 0..<3 {
            let card = JFSubScribeCardView(frame: CGRect(x: CGFloat(cardWidth * Float(i)), y: 0, width: CGFloat(cardWidth), height: frame.size.height))
            card.frame = CGRect(x: CGFloat((cardWidth + 5) * Float(i) + 5), y: 0, width: CGFloat(cardWidth), height: frame.size.height)
            card.tag = 20 + i
            scrollView.addSubview(card)
//            card.delegate = self
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setDataArray(_ dataArray: [Any]?) {
        self.dataArray = dataArray
        for i in 0..<3 {
            let item = dataArray![i] as! JFSubItemModel
            let card = scrollView.viewWithTag(20 + i) as? JFSubScribeCardView
            card?.subItem = item
        }
    }
    
    func didSelectSubImageCard(_ subImageCard: JFSubScribeCardView?, subItem: JFSubItemModel?) {
    }

}

class IqiyiSubscribeViewController: IqiyiBaseViewController {
    var subscribeTableView : UITableView!
    var dataSource = [AnyHashable]()
    func setUpRefresh() {
        subscribeTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {() -> Void in
            self.initData()
        })
        subscribeTableView.mj_header.beginRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    func initNav() {
        title = "订阅推荐"
    }
    func initData() {
        let urlStr = FreedomTools.sharedManager().urlWithSubscribeData()
    }
    
    func initView() {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH - 64), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        //将系统的Separator左边不留间隙
        tableView.separatorInset = UIEdgeInsets.zero
        subscribeTableView = tableView
        view.addSubview(subscribeTableView)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 215
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIndentifier = "JFSubscribeCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier) as? JFSubscribeCell
        if cell == nil {
            cell = JFSubscribeCell(style: .default, reuseIdentifier: cellIndentifier)
        }
//        cell?.delegate = self
        let subM = dataSource[indexPath.row] as? JFSubscribeModel
        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }

    func didSelect(_ subCell: JFSubscribeCell?, subItem: JFSubItemModel?) {
        let videoDetailVC = IqiyiVideoDetailViewController()
        videoDetailVC.iid = (subItem?.code)!
        navigationController?.pushViewController(videoDetailVC, animated: true)
    }

    

}
