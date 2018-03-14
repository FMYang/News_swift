//
//  ChannelDB.swift
//  RX+Moya
//
//  Created by yfm on 2018/3/14.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import Foundation
import WCDBSwift

typealias CompleteHandle = ([Channel]?) -> Void

class ChannelDB {
    static func insertOrReplace(objects: [Channel]) {
        DBManager.dbQueue.async {
            do {
                try DBManager.db.insertOrReplace(objects: objects, intoTable: TableName.channel.rawValue)
            } catch {
                print("insert channel object fail")
            }
        }
    }

    static func getObjects(completeHandle: @escaping CompleteHandle) {
        DBManager.dbQueue.async {
            do {
                let channels: [Channel]? = try DBManager.db.getObjects(fromTable: TableName.channel.rawValue)
                DispatchQueue.main.async {
                    completeHandle(channels)
                }
            } catch {
                print("get channel object fail")
            }
        }
    }
}
