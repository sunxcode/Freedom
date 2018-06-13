
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

