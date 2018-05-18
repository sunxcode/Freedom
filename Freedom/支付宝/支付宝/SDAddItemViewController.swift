//
//  SDAddItemViewController.swift
//  Freedom
//
//  Created by htf on 2018/5/17.
//  Copyright © 2018年 薛超. All rights reserved.
//

import UIKit
import BaseFile
import XExtension
class SDAddItemGridView: UIScrollView, UIScrollViewDelegate {
    var gridModelsArray = [Any]()
    var itemClickedOperationBlock: ((_ gridView: SDAddItemGridView?, _ index: Int) -> Void)?
    
    private var itemsArray = [AnyHashable]()
    private var rowSeparatorsArray = [AnyHashable]()
    private var columnSeparatorsArray = [AnyHashable]()
    private var hasAdjustedSeparators = false
    private var lastPoint = CGPoint.zero
    private var placeholderButton: UIButton?
    private var currentPressedView: SDHomeGridViewListItemView?
    private var currentPresssViewFrame = CGRect.zero
    init(frame: CGRect) {
        super.init(frame: frame)
        
        delegate = self
        itemsArray = [AnyHashable]()
        rowSeparatorsArray = [AnyHashable]()
        columnSeparatorsArray = [AnyHashable]()
        hasAdjustedSeparators = false
        placeholderButton = UIButton()
        
    }
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    func layoutSubviews() {
        super.layoutSubviews()
        let itemW: CGFloat = frameWidth / 4
        let itemH: CGFloat = itemW * 1.1
        if true {
            setupSubViewsFrame()
            rowSeparatorsArray.enumerateObjects({(_ view: UIView?, _ idx: Int, _ stop: UnsafeMutablePointer<ObjCBool>?) -> Void in
                let w: CGFloat = self.frameWidth
                let h: CGFloat = 0.4
                let x: CGFloat = 0
                let y = CGFloat(idx) * itemH
                view?.frame = CGRect(x: x, y: y, width: w, height: h)
                if let aView = view {
                    self.bringSubview(toFront: aView)
                }
            })
            columnSeparatorsArray.enumerateObjects({(_ view: UIView?, _ idx: Int, _ stop: UnsafeMutablePointer<ObjCBool>?) -> Void in
                let w: CGFloat = 0.4
                let h: CGFloat = self.contentSize.height
                let x = CGFloat(idx) * itemW
                let y: CGFloat = 0
                view?.frame = CGRect(x: x, y: y, width: w, height: h)
                if let aView = view {
                    self.bringSubview(toFront: aView)
                }
            })
            hasAdjustedSeparators = true
        }
    }
    //  The converted code is limited to 1 KB.
    //  Please Sign Up (Free!) to remove this limitation.
    //
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    func setGridModelsArray(_ gridModelsArray: [Any]?) {
        self.gridModelsArray = gridModelsArray
        (gridModelsArray as NSArray?)?.enumerateObjects({(_ model: SDHomeGridItemModel?, _ idx: Int, _ stop: UnsafeMutablePointer<ObjCBool>?) -> Void in
            let item = SDHomeGridViewListItemView()
            item.iconImage = UIImage(named: "app_add")
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
                if self.itemClickedOperationBlock {
                    if let aView = view {
                        self.itemClickedOperationBlock(self, itemsArray.index(of: aView))
                    }
                }
            }
            self.addSubview(item)
            itemsArray.append(item)
        })
        let rowCount: Int = self.rowCount(withItemsCount: gridModelsArray?.count)
        for i in 0..<(rowCount + 1) {
            let rowSeparator = UIView()
            rowSeparator.backgroundColor = UIColor.lightGray
            addSubview(rowSeparator)
            rowSeparatorsArray.append(rowSeparator)
        }
        for i in 0..<(4 + 1) {
            let columnSeparator = UIView()
            columnSeparator.backgroundColor = UIColor.lightGray
            addSubview(columnSeparator)
            columnSeparatorsArray.append(columnSeparator)
        }
    }
    func rowCount(withItemsCount count: Int) -> Int {
        let rowCount: Int = (count + 4 - 1) / 4
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
            //  The converted code is limited to 1 KB.
            //  Please Sign Up (Free!) to remove this limitation.
            //
            //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
            func buttonLongPressed(_ longPressed: UILongPressGestureRecognizer?) {
                itemsArray.enumerateObjects({(_ button: UIButton?, _ idx: Int, _ stop: UnsafeMutablePointer<ObjCBool>?) -> Void in
                    if button?.frame.contains(point) && button != longPressed?.view {
                        while let elementIndex = itemsArray.index(of: placeholderButton) { itemsArray.remove(at: elementIndex) }
                        itemsArray.insert(placeholderButton, at: idx)
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
            func setupSubViewsFrame() {
                let itemW: CGFloat = frameWidth / 4
                let itemH: CGFloat = itemW * 1.1
                itemsArray.enumerateObjects({(_ item: UIView?, _ idx: Int, _ stop: UnsafeMutablePointer<ObjCBool>?) -> Void in
                    let rowIndex: Int = idx / 4
                    let columnIndex: Int = idx % 4
                    let x = itemW * CGFloat(columnIndex)
                    let y = itemH * CGFloat(rowIndex)
                    item?.frame = CGRect(x: x, y: y, width: itemW, height: itemH)
                    if idx == (itemsArray.count - 1) {
                        self.contentSize = CGSize(width: 0, height: item?.frameHeight + item?.frameY)
                    }
                })
            }
            func delete(_ view: SDHomeGridViewListItemView?) {
                if let aView = view {
                    while let elementIndex = itemsArray.index(of: aView) { itemsArray.remove(at: elementIndex) }
                }
                view?.removeFromSuperview()
                UIView.animate(withDuration: 0.4, animations: {() -> Void in
                    self.setupSubViewsFrame()
                })
            }
            
            func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
                currentPressedView.hidenIcon = true
            }


}


class SDAddItemViewController: AlipayBaseViewController {
    weak var mainView: SDAddItemGridView?
    var dataArray = [AnyHashable]()
    func viewDidLoad() {
        super.viewDidLoad()
        let mainView = SDAddItemGridView(frame: view.bounds)
        mainView.showsVerticalScrollIndicator = false
        let titleArray = ["淘宝", "生活缴费", "教育缴费", "红包", "物流", "信用卡", "转账", "爱心捐款", "彩票", "当面付", "余额宝", "AA付款", "国际汇款", "淘点点", "淘宝电影", "亲密付", "股市行情", "汇率换算"]
        var temp = [AnyHashable]()
        for i in 0..<18 {
            let model = SDHomeGridItemModel()
            model.destinationClass = SDBasicViewContoller.self
            model.imageResString = String(format: "i%02d", i)
            model.title = titleArray[i]
            temp.append(model)
        }
        dataArray = temp
        mainView.gridModelsArray = temp
        view.addSubview(mainView)
        self.mainView = mainView
    }

}
