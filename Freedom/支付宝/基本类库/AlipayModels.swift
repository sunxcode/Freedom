//
//  AlipayModels.swift
//  Freedom
import UIKit
class AlipayTools: NSObject {
    class func itemsArray() -> [Any]? {
        var temp = UserDefaults.standard.object(forKey: "AlipayHomeIconsCacheKey") as? [Any]
        if temp == nil {
            temp = [["淘宝": "i00"],["生活缴费": "i01"], ["教育缴费": "i02"], ["红包": "hongbao"], ["物流": "i04"], ["信用卡": "i05"], ["转账": "i06"], ["爱心捐款": "i07"], ["彩票": "i08"], ["当面付": "i09"], ["余额宝": "i10"], ["AA付款": "i11"], ["国际汇款": "i12"], ["淘点点": "i13"], ["淘宝电影": "i14"], ["亲密付": "i15"], ["股市行情": "i16"], ["汇率换算": "i17"]]
            self.saveItemsArray(temp)
        }
        return temp
    }
    
    class func saveItemsArray(_ array: [Any]?) {
        UserDefaults.standard.set(array, forKey: "AlipayHomeIconsCacheKey")
        UserDefaults.standard.synchronize()
    }
}

class AlipayAssetsTableViewControllerCellModel: NSObject {
    var title = ""
    var iconImageName = ""
    var destinationControllerClass: AnyClass?
    
    convenience init(title: String?, iconImageName: String?, destinationControllerClass: AnyClass) {
        self.init()
        self.title = title!
        self.iconImageName = iconImageName!
        self.destinationControllerClass = destinationControllerClass
    }
}
class AlipayModels: NSObject {

}
