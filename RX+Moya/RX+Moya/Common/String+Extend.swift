//
//  String+Extend.swift
//  RX+Moya
//
//  Created by 杨方明 on 2018/3/15.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import Foundation
import UIKit

extension String {
    /// 新闻类时间戳转字符串
    ///
    /// - Parameter timeStamp: 时间戳
    /// - Returns: 转换之后的字符串
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
    
    /// 计算字符串的宽高
    ///
    /// - Parameters:
    ///   - size: 目标字符串宽高，计算高度设置宽为MAXFLOAT，计算宽度设置高度为MAXFLOAT
    ///   - font: 目标字符串使用的字体
    /// - Returns: 目标字符串的Size结构体
    public func sizeWithString(size: CGSize, font: UIFont) -> CGSize {
        return self.boundingRect(with: size, options: NSStringDrawingOptions.usesFontLeading, attributes: [NSAttributedStringKey.font: font], context: nil).size
    }

}
