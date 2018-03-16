//
//  News.swift
//  RX+Moya
//
//  Created by 杨方明 on 2018/1/7.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import Foundation
import SwiftyJSON

let listJson = """
{
"abstract": "关于宪法修改的意义，这篇文章说透了",
"action_extra": {
"channel_id": 3189398996
},
"aggr_type": 1,
"allow_download": false,
"article_alt_url": "http://m.toutiao.com/group/article/6531858579131990532/",
"article_sub_type": 0,
"article_type": 1,
"article_url": "http://a3.pstatp.com/subject2/6527158647733092878/?version=10",
"ban_comment": 0,
"behot_time": 1520821868,
"bury_count": 0,
"cell_flag": 262155,
"cell_layout_style": 1,
"cell_type": 0,
"comment_count": 7,
"content_decoration": "",
"cursor": 1520821868999,
"digg_count": 0,
"display_url": "http://a3.pstatp.com/subject2/6527158647733092878/?version=10",
"forward_info": {
"forward_count": 17
},
"gallary_image_count": 1,
"group_id": 6531858579131991000,
"has_image": true,
"has_m3u8_video": false,
"has_mp4_video": 0,
"has_video": false,
"hot": 0,
"ignore_web_transform": 1,
"is_subject": true,
"item_id": 6531858579131991000,
"item_version": 0,
"large_image_list": [
{
"height": 331,
"uri": "large/6592000c64813bf43f4e",
"url": "http://p3.pstatp.com/large/w960/6592000c64813bf43f4e.webp",
"url_list": [
{
"url": "http://p3.pstatp.com/large/w960/6592000c64813bf43f4e.webp"
},
{
"url": "http://pb9.pstatp.com/large/w960/6592000c64813bf43f4e.webp"
},
{
"url": "http://pb1.pstatp.com/large/w960/6592000c64813bf43f4e.webp"
}
],
"width": 640
}
],
"level": 0,
"log_pb": {
"impr_id": "201803121031080100080171051160A8"
},
"middle_image": {
"height": 331,
"uri": "list/6592000c64813bf43f4e",
"url": "http://p3.pstatp.com/list/300x196/6592000c64813bf43f4e.webp",
"url_list": [
{
"url": "http://p3.pstatp.com/list/300x196/6592000c64813bf43f4e.webp"
},
{
"url": "http://pb9.pstatp.com/list/300x196/6592000c64813bf43f4e.webp"
},
{
"url": "http://pb1.pstatp.com/list/300x196/6592000c64813bf43f4e.webp"
}
],
"width": 640
},
"need_client_impr_recycle": 1,
"publish_time": 1520816841,
"read_count": 19116,
"repin_count": 129,
"rid": "201803121031080100080171051160A8",
"share_count": 32,
"share_info": {
"cover_image": null,
"description": null,
"share_url": "http://m.toutiao.com/group/6531858579131990532/?iid=0&app=news_article",
"title": "关于宪法修改的意义，这篇文章说透了"
},
"share_url": "http://m.toutiao.com/group/6531858579131990532/?iid=0&app=news_article",
"show_dislike": true,
"show_portrait": false,
"show_portrait_article": false,
"source": "专题",
"source_avatar": "http://p9.pstatp.com/medium/dd30000ce5593c8c44a",
"source_icon_style": 5,
"source_open_url": "sslocal://search?from=channel_source&keyword=%E4%B8%93%E9%A2%98",
"tag": "news",
"tag_id": 6531858579131991000,
"tip": 0,
"title": "关于宪法修改的意义，这篇文章说透了",
"ugc_recommend": {
"activity": "",
"reason": ""
},
"url": "http://a3.pstatp.com/subject2/6527158647733092878/?version=10",
"user_repin": 0,
"user_verified": 0,
"verified_content": "",
"video_style": 0
}
"""

struct News: Codable {
    var title: String
    var source: String
    var item_id: Int
    var comment_count: Int
    var publish_time: TimeInterval
    var publishTimeString: String = ""
    var image_list: [NewsImage]?
    
    enum CodingKeys: String, CodingKey {
        case title
        case source
        case item_id
        case comment_count
        case publish_time
        case image_list
    }
    
    mutating func timeStampToString() {
        self.publishTimeString = String.timeStampToString(timeStamp: publish_time)
    }
}

struct NewsImage: Codable {
    var width: Int
    var height: Int
    var url: String
}

