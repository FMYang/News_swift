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
            return "article/category/get_subscribed/v2/"
        case .newsList(_):
            return "api/news/feed/v44/"
        case .newsDetail(_):
            return ""
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
        case .channel:
            return ["categories": ["news_local","video","news_hot","nineteenth","news_sports","question_and_answer","subscription","news_entertainment","组图","news_tech","news_car","essay_joke","news_world","image_funny","cellphone","两会","news_finance","news_military","live_talk","image_ppmm","news_history","news_baby","news_health","jinritemai","news_house","news_fashion","funny","news_food","news_regimen","news_travel","movie","novel_channel","digital","宠物","pregnancy","emotion","news_home","news_edu","news_culture","中国新唱将","weitoutiao","news_astrology","image_wonderful","news_story","news_collect","positive","boutique","news_comic","rumor","hotsoon","million_hero","stock","hotsoon_video","media","彩票","news_game","science_all","essay_saying","news_agriculture","high_court","中国好表演","public_welfare"]]
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
    
    public var headers: [String : String]? {
        switch self {
        case .channel:
            // 获取所有栏目
            return ["X-SS-Cookie": "_ba=BA0.2-20170409-51e32-7qYCnsjVRyDYi8NwBRjc; __utma=59317232.1827325726.1435833138.1469513633.1469619461.12; CNZZDATA1272189606=272739507-1518134539-%7C1520956554; CNZZDATA1263676333=592198736-1509892797-%7C1517737922; UM_distinctid=15f8ca277d6b3-0c246d5a8cf53f-170f5d31-3d10d-15f8ca277d71d1; _ga=GA1.2.1827325726.1435833138; uuid=\"w:b8ed2b7de1644e1595c471b5f6ce1f5f\"; alert_coverage=63; install_id=27536796204; odin_tt=c36ed7b14fb4f66c941a26742bb2b721848ebf06dec6b181988ec414ed9ecf1b5f61706e6351e189f21268a77c5107a2; sessionid=14367f8f6df1d83494b51266befeac1b; sid_guard=14367f8f6df1d83494b51266befeac1b%7C1520304122%7C2592000%7CThu%2C+05-Apr-2018+02%3A42%3A02+GMT; sid_tt=14367f8f6df1d83494b51266befeac1b; ttreq=1$e642a146bda2c409d4484cc6adfbce16a26d279c; uid_tt=0dda506579cbb6f10ccdfb22af25eb13"]
        default:
            return [:]
        }
    }
}


