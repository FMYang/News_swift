//
//  DBManager.swift
//  RX+Moya
//
//  Created by yfm on 2018/3/14.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import Foundation
import WCDBSwift

enum TableName: String {
    case channel = "Channel"
    case newsList = "NewsList"
}

let dbPath = NSHomeDirectory() + "/Documents/NewsDB/news.db"

// 单例
class DBManager {

    static let dbQueue = DispatchQueue(label: "com.news.queue", attributes: .concurrent)

    static let db = Database(withPath: dbPath)

    static let share: DBManager = {
        let instance = DBManager()
        return instance
    }()

    private init() {}
}

extension DBManager {
    /// 准备所需的表
    func createAllTable() {
        DBManager.dbQueue.async {
            do {
                try DBManager.db.run(transaction: {
                    try DBManager.db.create(table: TableName.channel.rawValue, of: Channel.self)
                    try DBManager.db.create(table: TableName.newsList.rawValue, of: News.self)
                })
            } catch {
                print(error)
            }
            DispatchQueue.main.async(execute: {
                print("db init or update finish")
            })
        }
    }
}
