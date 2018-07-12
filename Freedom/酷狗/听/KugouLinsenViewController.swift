//
//  LinsenViewController.swift
//  Freedom
import UIKit
import BaseFile
import XExtension
typealias clickLocalMusicBlock = () -> Void
class KugoumainHeaderView: UIView {
    var localMusic: clickLocalMusicBlock?
    var imageView: UIImageView?
    var bottomView: UIView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 最底层
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: APPW, height: 170))
        imageView?.isUserInteractionEnabled = true
        if let aView = imageView {
            addSubview(aView)
        }
        //最上面
        setupTopButtoms()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupTopButtoms() {
        let btnW: CGFloat = 60
        let btnH: CGFloat = 60
        let magin: CGFloat = (APPW - 4 * btnW) / 5.0
        let titleArr = ["我喜欢", "歌单", "下载", "最近"]
        for i in 0..<4 {
            let btnX: CGFloat = magin + (magin + btnW) * CGFloat(i)
            let btn = UIButton(frame: CGRect(x: btnX, y: 30, width: btnW, height: btnH))
            btn.imageView?.contentMode = .scaleAspectFit
            btn.titleLabel?.textAlignment = .center
            btn.imageView?.contentMode = .scaleAspectFit
            btn.titleLabel?.textAlignment = .center
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.setImage(UIImage(named: "main_clock"), for: .normal)
            btn.setTitle(titleArr[i], for: .normal)
            addSubview(btn)
        }
        let lineView = UIView(frame: CGRect(x: 10, y: btnH + 30 + 30, width: APPW - 20, height: 0.5))
        lineView.backgroundColor = UIColor.white
        lineView.alpha = 0.3
        addSubview(lineView)
        let phoneimage = UIImageView(frame: CGRect(x: 20, y: lineView.frame.maxY + 15, width: 20, height: 20))
        phoneimage.image = UIImage(named: "main_phone")
        addSubview(phoneimage)
        let lable = UILabel(frame: CGRect(x: phoneimage.frame.maxX + 8, y: phoneimage.frameY, width: 100, height: 25))
        lable.text = "本地音乐"
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = UIColor.white
        addSubview(lable)
//        let everyMusic = MPMediaQuery()
//        let musicArr = everyMusic.items
        let lable2 = UILabel(frame: CGRect(x: APPW - 130, y: phoneimage.frameY, width: 100, height: 25))
        lable2.text = "3首"
        lable2.font = UIFont.systemFont(ofSize: 12)
        lable2.textColor = UIColor.white
        lable2.textAlignment = .right
        addSubview(lable2)
        lable2.isUserInteractionEnabled = true
        let lable3 = UILabel(frame: CGRect(x: 0, y: lable2.frameY, width: APPW, height: lable2.frameHeight))
        addSubview(lable3)
        lable3.isUserInteractionEnabled = true
        lable3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickLable2)))
        let imageArrow = UIImageView(frame: CGRect(x: lable2.frame.maxX, y: lable2.frameY, width: 25, height: 25))
        imageArrow.image = UIImage(named: "arrow")
        addSubview(imageArrow)
        // 底部
        setupBottonButtons()
    }
    func setupBottonButtons() {
        let bView = UIView(frame: CGRect(x: 0, y: (imageView?.frame.maxY)!, width: APPW, height: 130))
        bView.backgroundColor = UIColor.white
        addSubview(bView)
        let btnW: CGFloat = 80
        let btnH: CGFloat = 100
        let magin: CGFloat = (APPW - 3 * btnW) / 4.0
        let titleArr = ["乐库", "电台", "库群"]
        for i in 0..<3 {
            let btnX: CGFloat = magin + (magin + btnW) * CGFloat(i)
            let btn = UIButton(frame: CGRect(x: btnX, y: 15, width: btnW, height: btnH))
            btn.imageView?.contentMode = .scaleAspectFit
            btn.titleLabel?.textAlignment = .center
            btn.imageView?.contentMode = .scaleAspectFit
            btn.titleLabel?.textAlignment = .center
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.setImage(UIImage(named: "n\(i + 1)"), for: .normal)
            btn.setTitle(titleArr[i], for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            bView.addSubview(btn)
        }
    }
    
    @objc func clickLable2() {
        localMusic!()
    }
}
class KugouLinsenViewController: KugouBaseViewController {
    var titlesArr = [Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        titlesArr = ["工具", "游戏", "推广"]
        setupTableView()
        setupRightGesture()
    }
    
    func setupRightGesture() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(KugouLinsenViewController.swipe(_:)))
        leftSwipe.direction = .right
        leftSwipe.numberOfTouchesRequired = 1
        view.addGestureRecognizer(leftSwipe)
    }
    
    @objc func swipe(_ sender: UISwipeGestureRecognizer?) {
    }
    var headerView = KugoumainHeaderView(frame: CGRect(x: 0, y: 0, width: APPW, height: 100))
    func setupTableView() {
        self.tableView = BaseTableView(frame: CGRect(x: 0, y: 0, width: Int(APPW), height: Int(APPH - TabBarH) + 2), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundView = UIImageView(image: UIImage(named: "bj"))
        tableView.backgroundView?.contentMode = .redraw
        tableView.tableHeaderView = headerView
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        view.addSubview(tableView)
        let viewtab = UIView(frame: CGRect(x: 0, y: 100 + 44 * titlesArr.count, width: Int(APPW), height: 500))
        viewtab.backgroundColor = UIColor.white
        tableView.addSubview(viewtab)
        // 访问系统本地音乐
        headerView.localMusic = {() -> Void in
            let localVC = KugouLocalMusicViewController()
            self.navigationController?.pushViewController(localVC, animated: false)
        }
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArr.count
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
        
    
    
}
