//
//  AlipayModels.swift
//  Freedom
//
//  Created by htf on 2018/5/18.
//  Copyright © 2018年 薛超. All rights reserved.
//

import UIKit
class AlipayTools: NSObject {
    //  The converted code is limited to 1 KB.
    //  Please Sign Up (Free!) to remove this limitation.
    //
    //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
    class func itemsArray() -> [Any]? {
        var temp = UserDefaults.standard.object(forKey: "AlipayHomeIconsCacheKey") as? [Any]
        if temp == nil {
            temp = [["淘宝": "i00"],         // title => imageString
                ["生活缴费": "i01"], ["教育缴费": "i02"], ["红包": Phongbao], ["物流": "i04"], ["信用卡": "i05"], ["转账": "i06"], ["爱心捐款": "i07"], ["彩票": "i08"], ["当面付": "i09"], ["余额宝": "i10"], ["AA付款": "i11"], ["国际汇款": "i12"], ["淘点点": "i13"], ["淘宝电影": "i14"], ["亲密付": "i15"], ["股市行情": "i16"], ["汇率换算": "i17"]]
            self.saveItemsArray(temp)
        }
        return temp
    }
    
    class func saveItemsArray(_ array: [Any]?) {
        UserDefaults.standard.set(array, forKey: "AlipayHomeIconsCacheKey")
        UserDefaults.standard.synchronize()
    }
}

class SDAssetsTableViewControllerCellModel: NSObject {
    var title = ""
    var iconImageName = ""
    var destinationControllerClass: AnyClass?
    
    convenience init(title: String?, iconImageName: String?, destinationControllerClass: AnyClass) {
        let model = SDAssetsTableViewControllerCellModel()
        model.title = title
        model.iconImageName = iconImageName
        model.destinationControllerClass = destinationControllerClass
        return model
    }

}


class AlipayModels: NSObject {

}
