//
//  ChannelDB.swift
//  RX+Moya
//
//  Created by yfm on 2018/3/14.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import Foundation
import WCDBSwift

class ChannelDB {
    static func insert(objects: [Channel]) {
        DBManager.dbQueue.async {
            do {
                try DBManager.db.insert(objects: objects, intoTable: TableName.channel.rawValue)
            } catch {
                print("insert channel object fail")
            }
        }
    }

    static func getObjects(completeHandle: @escaping ([Channel]?) -> Void) {
        DBManager.dbQueue.async {
            do {
                let channels: [Channel]? = try DBManager.db.getObjects(fromTable: TableName.channel.rawValue)
                DispatchQueue.main.async {
                    completeHandle(channels)
                }
            } catch {
                DispatchQueue.main.async {
                    completeHandle(nil)
                }
            }
        }
    }
    
    static func deleteAll(completeHandle: @escaping () -> Void) {
        DBManager.dbQueue.async {
            do {
                try DBManager.db.delete(fromTable: TableName.channel.rawValue)
                completeHandle()
            } catch {
                print("delete channel objects fail")
            }
        }
    }
}
