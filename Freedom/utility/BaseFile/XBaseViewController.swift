//
//  XBaseViewController.swift
//  Freedom
//
//  Created by htf on 2018/5/15.
//  Copyright © 2018年 薛超. All rights reserved.
//

import UIKit
import BaseFile
class XBaseViewController: BaseViewController {
    var cellHeight:CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }


}
