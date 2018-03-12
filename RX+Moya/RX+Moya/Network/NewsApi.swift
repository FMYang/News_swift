//
//  NewsApi.swift
//  RX+Moya
//
//  Created by 杨方明 on 2018/1/7.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import Foundation
import Moya

//http://lf.snssdk.com/api/news/feed/v44/?category=video&count=20&device_id=3755813419

public enum NewsAPi {
    case channel
    case newsList(channel: String, count: Int)
}

extension NewsAPi: ApiTargetType {
    public var url: String {
        switch self {
        case .channel:
            return "article/category/get_subscribed/v1/"
        case .newsList(_):
            return "api/news/feed/v44/"
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
        case .channel:
            return nil
        case .newsList(let channel, let count):
            return ["category": channel, "count": count, "device_id": 3755813419]
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .newsList(_), .channel:
            return .get
        }
    }
}


