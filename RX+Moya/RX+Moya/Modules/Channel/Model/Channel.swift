//
//  Channel.swift
//  RX+Moya
//
//  Created by yfm on 2018/3/12.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import Foundation
import WCDBSwift

//let channelJson = """
//{
//"category": "news_hot",
//"web_url": "",
//"flags": 0,
//"name": "热点",
//"tip_new": 0,
//"default_add": 1,
//"concern_id": "",
//"type": 4,
//"icon_url": ""
//}
//"""

public class Channel: TableCodable {
    var name: String = ""
    var category: String = ""
    var type: Int = 0

    public enum CodingKeys: String, CodingTableKey {
        public typealias Root = Channel
        public static let objectRelationalMapping = TableBinding(CodingKeys.self)
        // 将下面字段绑定到了表中同名字段
        case name
        case category
        case type
    }

    // 绑定id为主键
    static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
        return [
            CodingKeys.name: ColumnConstraintBinding(isPrimary: true)
        ]
    }

//    public var isAutoIncrement: Bool = true
}
