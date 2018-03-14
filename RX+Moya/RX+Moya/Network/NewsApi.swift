//
//  NewsApi.swift
//  RX+Moya
//
//  Created by 杨方明 on 2018/1/7.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import Foundation
import Moya

public enum NewsAPi {
    case channel
    case newsList(channel: String, count: Int)
    case newsDetail(id: Int)
}

extension NewsAPi: ApiTargetType {

    /// The target's base `URL`.
    public var baseURL: URL {
        switch self {
        case .newsDetail(let id):
            return URL(string: "http://a.pstatp.com/article/content/19/2/\(id)/\(id)/1/0")!
        default:
            return URL(string: "http://lf.snssdk.com")!
        }
    }

    public var url: String {
        switch self {
        case .channel:
            return "article/category/get_subscribed/v1/"
        case .newsList(_):
            return "api/news/feed/v44/"
        case .newsDetail(_):
            return ""
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
        case .channel:
            return nil
        case .newsList(let channel, let count):
            return ["category": channel, "count": count, "device_id": 3755813419]
        case .newsDetail(_):
            return nil
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .newsList(_), .channel, .newsDetail(_):
            return .get
        }
    }
}


