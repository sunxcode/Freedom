//
//  SDHomeViewController.swift
//  Freedom
//
//  Created by htf on 2018/5/17.
//  Copyright © 2018年 薛超. All rights reserved.
//

import UIKit
import BaseFile
import XExtension
class SDHomeGridItemModel: NSObject {
    var imageResString = ""
    var title = ""
    var destinationClass: AnyClass?
}

class SDHomeGridViewListItemView: UIView {
    var itemModel: SDHomeGridItemModel?
    var hidenIcon = false
    var iconImage: UIImage?
    var itemLongPressedOperationBlock: ((_ longPressed: UILongPressGestureRecognizer?) -> Void)?
    var buttonClickedOperationBlock: ((_ item: SDHomeGridViewListItemView?) -> Void)?
    var iconViewClickedOperationBlock: ((_ view: SDHomeGridViewListItemView?) -> Void)?
    private var button: UIButton?
    private var iconView: UIButton?
    
    init(frame: CGRect) {
        super.init(frame: frame)
        
        initialization()
        
    }
    func initialization() {
        backgroundColor = UIColor.white
        button = UIButton()
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        addSubview(button)
        let icon = UIButton()
        icon.setImage(UIImage(named: Pdelete), for: .normal)
        icon.addTarget(self, action: #selector(self.iconViewClicked), for: .touchUpInside)
        icon.isHidden = true
        addSubview(icon)
        iconView = icon
        let longPressed = UILongPressGestureRecognizer(target: self, action: Selector("itemLongPressed:"))
        addGestureRecognizer(longPressed)
    }
    func itemLongPressed(_ longPressed: UILongPressGestureRecognizer?) {
        if itemLongPressedOperationBlock {
            itemLongPressedOperationBlock(longPressed)
        }
    }
    
    func buttonClicked() {
        if buttonClickedOperationBlock {
            buttonClickedOperationBlock(self)
        }
    }
    
    func iconViewClicked() {
        if iconViewClickedOperationBlock {
            iconViewClickedOperationBlock(self)
        }
    }
    func setItemModel(_ itemModel: SDHomeGridItemModel?) {
        self.itemModel = itemModel
        if itemModel?.title != nil {
            button.setTitle(itemModel?.title, for: .normal)
        }
        if itemModel?.imageResString != nil {
            if itemModel?.imageResString.hasPrefix("http:") ?? false {
                button.sd_setImage(with: URL(string: itemModel?.imageResString ?? ""), for: .normal, placeholderImage: nil)
            } else {
                button.setImage(UIImage(named: itemModel?.imageResString ?? ""), for: .normal)
            }
        }
    }
    func setHidenIcon(_ hidenIcon: Bool) {
        self.hidenIcon = hidenIcon
        iconView.hidden = hidenIcon
    }
    
    func setIconImage(_ iconImage: UIImage?) {
        self.iconImage = iconImage
        iconView.setImage(iconImage, for: .normal)
    }
    
    func layoutSubviews() {
        super.layoutSubviews()
        let margin: CGFloat = 10
        button.frame = bounds
        let h: CGFloat = H(button)
        let w: CGFloat = W(button)
        button.imageEdgeInsets = UIEdgeInsetsMake(h * 0.2, w * 0.32, h * 0.3, w * 0.32)
        button.titleEdgeInsets = UIEdgeInsetsMake(h * 0.6, -w * 0.4, 0, 0)
        iconView.frame = CGRect(x: frameWidth - iconView.frameWidth - margin, y: margin, width: 20, height: 20)
    }


}
protocol SDHomeGridViewDeleate: NSObjectProtocol {
    func homeGrideView(_ gridView: SDHomeGridView?, selectItemAt index: Int)
    
    func homeGrideViewmoreItemButtonClicked(_ gridView: SDHomeGridView?)
    
    func homeGrideViewDidChangeItems(_ gridView: SDHomeGridView?)
}
class SDHomeGridView: UIScrollView, UIScrollViewDelegate {
    weak var gridViewDelegate: SDHomeGridViewDeleate?
    var gridModelsArray = [Any]()
    
    private var itemsArray = [AnyHashable]()
    private var rowSeparatorsArray = [AnyHashable]()
    private var columnSeparatorsArray = [AnyHashable]()
    private var shouldAdjustedSeparators = false
    private var lastPoint = CGPoint.zero
    private var placeholderButton: UIButton?
    private var currentPressedView: SDHomeGridViewListItemView?
    private var cycleScrollADView: BaseScrollOCView?
    private var cycleScrollADViewBackgroundView: UIView?
    private var moreItemButton: UIButton?
    private var currentPresssViewFrame = CGRect.zero
    func scanButtonClicked() {
        let desVc = SDScanViewController() as? SDBasicViewContoller
        if let aVc = desVc {
            getCurrentViewController()?.navigationController?.pushViewController(aVc, animated: true)
        }
    }
    
    func getCurrentViewController() -> UIViewController? {
        var next: UIResponder? = self.next
        repeat {
            if (next is UIViewController) {
                return next as? UIViewController
            }
            next = next?.next
        } while next != nil
        return nil
    }
    //  The converted code is limited to 1 KB.
    //  Please Sign Up (Free!) to remove this limitation.
    //
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    init(frame: CGRect) {
        super.init(frame: frame)
        
        delegate = self
        itemsArray = [AnyHashable]()
        rowSeparatorsArray = [AnyHashable]()
        columnSeparatorsArray = [AnyHashable]()
        shouldAdjustedSeparators = false
        placeholderButton = UIButton()
        // MARK: 在这里设置最上面的那个扫描二维码
        let header = UIView()
        header.frame = CGRect(x: 0, y: 0, width: APPW, height: 100)
        header.backgroundColor = UIColor(red: 38 / 255.0, green: 42 / 255.0, blue: 59 / 255.0, alpha: 1)
        let scan = UIButton(frame: CGRect(x: 0, y: 0, width: header.frameWidth * 0.5, height: header.frameHeight))
        scan.setImage(UIImage(named: Pscan_y), for: .normal)
        scan.addTarget(self, action: #selector(self.scanButtonClicked), for: .touchUpInside)
        header.addSubview(scan)
        let pay = UIButton(frame: CGRect(x: scan.frameWidth, y: 0, width: header.frameWidth * 0.5, height: header.frameHeight))
        pay.setImage(UIImage(named: "home_pay"), for: .normal)
        header.addSubview(pay)
        let line = UIView(frame: CGRect(x: APPW / 2, y: 0, width: 0.5, height: 100))
        line.backgroundColor = whitecolor
        header.addSubview(line)
        addSubview(header)
        let cycleScrollADViewBackgroundView = UIView()
        cycleScrollADViewBackgroundView.backgroundColor = UIColor(red: 235 / 255.0, green: 235 / 255.0, blue: 235 / 255.0, alpha: 1)
        addSubview(cycleScrollADViewBackgroundView)
        self.cycleScrollADViewBackgroundView = cycleScrollADViewBackgroundView
        self.cycleScrollADViewBackgroundView.backgroundColor = UIColor.red
        let temp = ["http://ww3.sinaimg.cn/bmiddle/9d857daagw1er7lgd1bg1j20ci08cdg3.jpg", "http://ww4.sinaimg.cn/bmiddle/763cc1a7jw1esr747i13xj20dw09g0tj.jpg", "http://ww4.sinaimg.cn/bmiddle/67307b53jw1esr4z8pimxj20c809675d.jpg"]
        cycleScrollADView = BaseScrollOCView.sharedBanner(withFrame: CGRect(x: 0, y: 0, width: APPW, height: 100), icons: temp)
        addSubview(cycleScrollADView)
        
    }
    //  The converted code is limited to 1 KB.
    //  Please Sign Up (Free!) to remove this limitation.
    //
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    func setGridModelsArray(_ gridModelsArray: [Any]?) {
        self.gridModelsArray = gridModelsArray
        itemsArray.removeAll()
        rowSeparatorsArray.removeAll()
        columnSeparatorsArray.removeAll()
        (gridModelsArray as NSArray?)?.enumerateObjects({(_ model: SDHomeGridItemModel?, _ idx: Int, _ stop: UnsafeMutablePointer<ObjCBool>?) -> Void in
            let item = SDHomeGridViewListItemView()
            item.itemModel = model
            weak var weakSelf = self
            item.itemLongPressedOperationBlock = {(_ longPressed: UILongPressGestureRecognizer?) -> Void in
                weakSelf.buttonLongPressed(longPressed)
            }
            item.iconViewClickedOperationBlock = {(_ view: SDHomeGridViewListItemView?) -> Void in
                weakSelf.delete(view)
            }
            item.buttonClickedOperationBlock = {(_ view: SDHomeGridViewListItemView?) -> Void in
                if !currentPressedView.hidenIcon && currentPressedView {
                    currentPressedView.hidenIcon = true
                    return
                }
                if self.gridViewDelegate.responds(to: Selector("homeGrideView:selectItemAtIndex:")) {
                    if let aView = view {
                        self.gridViewDelegate.homeGrideView(self, selectItemAt: itemsArray.index(of: aView))
                    }
                }
            }
            self.addSubview(item)
        })
        let more = UIButton()
        more.setImage(UIImage(named: "tf_home_more"), for: .normal)
        more.addTarget(self, action: #selector(self.moreItemButtonClicked), for: .touchUpInside)
        addSubview(more)
        itemsArray.append(more)
        moreItemButton = more
        // MARK: 设置中间分割线的位置
        let rowCount: Int = self.rowCount(withItemsCount: gridModelsArray?.count)
        let lineColor: UIColor? = UIColor.lightGray.withAlphaComponent(0.8)
        for i in 0..<(rowCount + 1) {
            let rowSeparator = UIView()
            rowSeparator.backgroundColor = lineColor
            addSubview(rowSeparator)
            rowSeparatorsArray.append(rowSeparator)
        }
        for i in 0..<(4 + 1) {
            let columnSeparator = UIView()
            columnSeparator.backgroundColor = lineColor
            addSubview(columnSeparator)
            columnSeparatorsArray.append(columnSeparator)
        }
        shouldAdjustedSeparators = true
        bringSubview(toFront: cycleScrollADViewBackgroundView)
        bringSubview(toFront: cycleScrollADView)
    }
    func moreItemButtonClicked() {
        if gridViewDelegate.responds(to: Selector("homeGrideViewmoreItemButtonClicked:")) {
            gridViewDelegate.homeGrideViewmoreItemButtonClicked(self)
        }
    }
    
    func rowCount(withItemsCount count: Int) -> Int {
        var rowCount: Int = (count + 4 - 1) / 4
        rowCount += 1
        rowCount = (rowCount < 4) ? 4 : rowCount
        return rowCount
    }

    //  The converted code is limited to 1 KB.
    //  Please Sign Up (Free!) to remove this limitation.
    //
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    func buttonLongPressed(_ longPressed: UILongPressGestureRecognizer?) {
        let pressedView = longPressed?.view as? SDHomeGridViewListItemView
        let point: CGPoint? = longPressed?.location(in: self)
        if longPressed?.state == .began {
            currentPressedView.hidenIcon = true
            currentPressedView = pressedView
            currentPresssViewFrame = pressedView?.frame
            longPressed?.view?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            pressedView?.hidenIcon = false
            var index: Int? = nil
            if let aView = longPressed?.view {
                index = itemsArray.index(of: aView)
            }
            if let aView = longPressed?.view {
                while let elementIndex = itemsArray.index(of: aView) { itemsArray.remove(at: elementIndex) }
            }
            itemsArray.insert(placeholderButton, at: index ?? 0)
            lastPoint = point
            bringSubview(toFront: aView)
        }
    }
    let temp: CGRect? = longPressed?.view?.frame
    temp?.origin.x += point.x - lastPoint.x
    temp?.origin.y += point.y - lastPoint.y
    longPressed?.view?.frame = temp ?? CGRect.zero
    lastPoint = point
    itemsArray.enumerateObjects({(_ button: UIButton?, _ idx: Int, _ stop: UnsafeMutablePointer<ObjCBool>?) -> Void in
    if button == moreItemButton {
    return
    }
    if button?.frame.contains(point) && button != longPressed?.view {
    while let elementIndex = itemsArray.index(of: placeholderButton) { itemsArray.remove(at: elementIndex) }
    itemsArray.insert(placeholderButton, at: idx)
    return
    }
    if button?.frame.contains(point) && button != longPressed?.view {
    while let elementIndex = itemsArray.index(of: placeholderButton) { itemsArray.remove(at: elementIndex) }
    stop = true
    UIView.animate(withDuration: 0.5, animations: {() -> Void in
    self.setupSubViewsFrame()
    })
    }
    })
    if longPressed?.state == .ended {
    let index: Int = itemsArray.index(of: placeholderButton)
    while let elementIndex = itemsArray.index(of: placeholderButton) { itemsArray.remove(at: elementIndex) }
    if let aView = longPressed?.view {
    itemsArray.insert(aView, at: index)
    }
    if let aView = longPressed?.view {
    sendSubview(toBack: aView)
    }
    // 保存数据
    saveItemsSettingCache()
    UIView.animate(withDuration: 0.4, animations: {() -> Void in
    longPressed?.view?.transform = .identity
    self.setupSubViewsFrame()
    }, completion: {(_ finished: Bool) -> Void in
    if !currentPresssViewFrame.equalTo(currentPressedView.frame) {
    currentPressedView.hidenIcon = true
    }
    })
    }
}
//  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
func delete(_ view: SDHomeGridViewListItemView?) {
    if let aView = view {
        while let elementIndex = itemsArray.index(of: aView) { itemsArray.remove(at: elementIndex) }
    }
    view?.removeFromSuperview()
    saveItemsSettingCache()
    UIView.animate(withDuration: 0.4, animations: {() -> Void in
        self.setupSubViewsFrame()
    })
}
func saveItemsSettingCache() {
    var tempItemsContainer = [AnyHashable]()
    itemsArray.enumerateObjects({(_ button: SDHomeGridViewListItemView?, _ idx: Int, _ stop: UnsafeMutablePointer<ObjCBool>?) -> Void in
        if (button is SDHomeGridViewListItemView) {
            tempItemsContainer.append([button?.itemModel.title: button?.itemModel.imageResString])
        }
    })
    AlipayTools.saveItemsArray(tempItemsContainer)
    if gridViewDelegate.responds(to: Selector("homeGrideViewDidChangeItems:")) {
        gridViewDelegate.homeGrideViewDidChangeItems(self)
    }
}

func setupSubViewsFrame() {
    let itemW: CGFloat = frameWidth / 4
    let itemH: CGFloat = itemW * 1.1
    itemsArray.enumerateObjects({(_ item: UIView?, _ idx: Int, _ stop: UnsafeMutablePointer<ObjCBool>?) -> Void in
        let rowIndex: Int = idx / 4
        let columnIndex: Int = idx % 4
        let x = itemW * CGFloat(columnIndex)
        var y: CGFloat = 0
        if idx < 4 * 3 {
            y = itemH * CGFloat(rowIndex) + 100
        } else {
            y = itemH * CGFloat((rowIndex + 1))
        }
        item?.frame = CGRect(x: x, y: y, width: itemW, height: itemH)
        if idx == (itemsArray.count - 1) {
            self.contentSize = CGSize(width: 0, height: item?.frameHeight + item?.frameY)
        }
    })
}
//  The converted code is limited to 1 KB.
//  Please Sign Up (Free!) to remove this limitation.
//
//  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
func layoutSubviews() {
    super.layoutSubviews()
    let itemW: CGFloat = frameWidth / 4
    let itemH: CGFloat = itemW * 1.1
    setupSubViewsFrame()
    if shouldAdjustedSeparators {
        rowSeparatorsArray.enumerateObjects({(_ view: UIView?, _ idx: Int, _ stop: UnsafeMutablePointer<ObjCBool>?) -> Void in
            let w: CGFloat = self.frameWidth
            let h: CGFloat = 0.4
            let x: CGFloat = 0
            let y = CGFloat(idx) * itemH + 100
            view?.frame = CGRect(x: x, y: y, width: w, height: h)
        })
        columnSeparatorsArray.enumerateObjects({(_ view: UIView?, _ idx: Int, _ stop: UnsafeMutablePointer<ObjCBool>?) -> Void in
            let w: CGFloat = 0.4
            let h: CGFloat = max(self.contentSize.height - 100, self.frameHeight - 100)
            let x = CGFloat(idx) * itemW
            let y: CGFloat = 100
            view?.frame = CGRect(x: x, y: y, width: w, height: h)
        })
        shouldAdjustedSeparators = false
    }
    cycleScrollADViewBackgroundView.frame = CGRect(x: 0, y: itemH * 3, width: frameWidth, height: itemH)
    cycleScrollADView.frame = CGRect(x: 0, y: cycleScrollADViewBackgroundView.frameY + 10, width: frameWidth, height: itemH - 10 * 2)
}
func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    currentPressedView.hidenIcon = true
}


}

class SDHomeViewController: AlipayBaseViewController {
    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem?.title = "支付宝"
        let mainView = SDHomeGridView()
        mainView.gridViewDelegate = self
        mainView.showsVerticalScrollIndicator = false
        setupDataArray()
        mainView.gridModelsArray = dataArray
        view.addSubview(mainView)
        self.mainView = mainView
    }
    
    func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tabbarHeight: CGFloat? = tabBarController?.tabBar.frameHeight()
        mainView.frame = CGRect(x: 0, y: 0, width: view.frameWidth, height: APPH - (tabbarHeight ?? 0.0))
    }
    func setupDataArray() {
        let itemsArray = AlipayTools.itemsArray()
        var temp = [AnyHashable]()
        for itemDict: [AnyHashable: Any] in itemsArray as? [[AnyHashable: Any]] ?? [[AnyHashable: Any]]() {
            let model = SDHomeGridItemModel()
            model.destinationClass = SDBasicViewContoller.self
            model.imageResString = itemDict.allValues.first
            model.title = itemDict.keys.first
            temp.append(model)
        }
        dataArray = temp
    }
    func homeGrideView(_ gridView: SDHomeGridView?, selectItemAt index: Int) {
        let model: SDHomeGridItemModel? = dataArray[index]
        let vc: UIViewController? = model?.destinationClass()
        vc?.title = model?.title
        if let aVc = vc {
            navigationController?.pushViewController(aVc, animated: true)
        }
    }
    
    func homeGrideViewmoreItemButtonClicked(_ gridView: SDHomeGridView?) {
        let addVc = SDAddItemViewController()
        addVc.title = "添加更多"
        navigationController?.pushViewController(addVc, animated: true)
    }
    
    func homeGrideViewDidChangeItems(_ gridView: SDHomeGridView?) {
        setupDataArray()
}
}
