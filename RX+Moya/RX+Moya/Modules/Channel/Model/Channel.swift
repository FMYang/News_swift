//
//  Channel.swift
//  RX+Moya
//
//  Created by yfm on 2018/3/12.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import Foundation
import WCDBSwift

class Channel: TableCodable {
    var name: String = ""
    var category: String = ""
    var type: Int = 0

    enum CodingKeys: String, CodingTableKey {
        typealias Root = Channel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case name
        case category
        case type
    }
}

