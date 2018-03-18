//
//  NewsListDB.swift
//  RX+Moya
//
//  Created by 杨方明 on 2018/3/18.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import Foundation

class NewsListDB {
    static func insert(objects: [News]) {
        DBManager.dbQueue.async {
            do {
                try DBManager.db.insert(objects: objects, intoTable: TableName.newsList.rawValue)
            } catch {
                print("insert news object fail")
            }
        }
    }
    
    static func getObjects(completeHandle: @escaping ([News]?) -> Void) {
        DBManager.dbQueue.async {
            do {
                let news: [News]? = try DBManager.db.getObjects(fromTable: TableName.newsList.rawValue)
                DispatchQueue.main.async {
                    completeHandle(news)
                }
            } catch {
                DispatchQueue.main.async {
                    completeHandle(nil)
                }
            }
        }
    }
    
    static func getObjects(by channel: String, completeHandle: @escaping ([News]?) -> Void) {
        DBManager.dbQueue.async {
            do {
                let news: [News]? = try DBManager.db.getObjects(fromTable: TableName.newsList.rawValue, where: News.Properties.category.is(channel))
                DispatchQueue.main.async {
                    completeHandle(news)
                }
            } catch {
                DispatchQueue.main.async {
                    completeHandle([News]())
                }
            }
        }
    }
    
    static func deleteAll(by channel: String, completeHandle: @escaping () -> Void) {
        DBManager.dbQueue.async {
            do {
                try DBManager.db.delete(fromTable: TableName.newsList.rawValue, where: News.Properties.category.is(channel))
                completeHandle()
            } catch {
                print("delete news objects fail")
            }
        }
    }

}
