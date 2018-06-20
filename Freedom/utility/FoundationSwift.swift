
//
//  FoundationSwift.swift
//  Freedom
//
//  Created by htf on 2018/5/18.
//  Copyright © 2018年 薛超. All rights reserved.
//

import Foundation
import XExtension

public func Font(_ fontSize:CGFloat)->UIFont{
    return UIFont.systemFont(ofSize: fontSize)
}
public func BoldFont(_ fontSize:CGFloat)->UIFont{
    return UIFont.boldSystemFont(ofSize: fontSize)
}
public let fontTitle = Font(15)
public let fontnomal = Font(13)
public let fontSmallTitle = Font(14)
public let clearcolor = UIColor.clear
public let gradcolor  = RGBAColor(224, 225, 226, 1)
public let redcolor = RGBAColor(229, 59, 25, 1)
public let yellowcolor = UIColor.yellow
public let greencolor = UIColor.green
public let whitecolor = UIColor.white
public let blacktextcolor = RGBAColor(33, 34, 35, 1)
public let gradtextcolor = RGBAColor(116, 117, 118, 1)
public let graycolor = UIColor.gray
public let TabBarH:CGFloat = 49
public let APPW = UIScreen.main.bounds.size.width
public let FreedomItems = [["icon": "kugouIcon", "title": "酷狗", "control": "Kugou"], ["icon": "juheIcon", "title": "聚合数据", "control": "JuheData"], ["icon": "aiqiyiIcon", "title": "爱奇艺", "control": "Iqiyi"], ["icon": "taobaoIcon", "title": "淘宝", "control": "Taobao"], ["icon": "weiboIcon", "title": "新浪微博", "control": "Sina"], ["icon": "zhifubaoIcon", "title": "支付宝", "control": "Alipay"], ["icon": "jianliIcon", "title": "我的简历", "control": "Resume"], ["icon": "database", "title": "我的数据库", "control": "MyDatabase"], ["icon": "shengyibaoIcon", "title": "微能量", "control": "MicroEnergy"], ["icon": "weixinIcon", "title": "微信", "control": "Wechart"], ["icon": "dianpingIcon", "title": "大众点评", "control": "DZ"], ["icon": "toutiaoIcon", "title": "今日头条", "control": "Toutiao"], ["icon": "books", "title": "书籍收藏", "control": "Books"], ["icon": "ziyouzhuyi", "title": "个性特色自由主义", "control": "Freedom"], ["icon": "yingyongIcon", "title": "个人应用", "control": "PersonalApply"]]
