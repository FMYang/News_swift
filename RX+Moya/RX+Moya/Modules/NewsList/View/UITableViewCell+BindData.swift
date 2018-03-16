//
//  UITableViewCell+BindData.swift
//  RX+Moya
//
//  Created by yfm on 2018/3/16.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import Foundation
import UIKit

protocol NewsCellProtocol {
    func bindData(model: News)
    static func reuseIdentify() -> String
}
