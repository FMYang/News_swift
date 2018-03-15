//
//  String+Extend.swift
//  RX+Moya
//
//  Created by 杨方明 on 2018/3/15.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import Foundation

extension String {
    static func timeStampToString(timeStamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeStamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm"
        let dateString = formatter.string(from: date)
        
        let current = Date().timeIntervalSince1970
        let min = Int((current - timeStamp) / 60) //分钟
        let hour = Int(min / 60) // 小时
        let day = Int(hour / 24) // 天
        if min > 0 && min < 60 {
            return String(min) + "分钟前"
        } else if hour > 0 && hour < 60 {
            return String(hour) + "小时前"
        } else if day > 0 && day < 2 {
            return String(hour) + "天前"
        } else {
            return dateString
        }
    }
}
