//
//  Detail.swift
//  RX+Moya
//
//  Created by yfm on 2018/3/13.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import Foundation

//let detailJson = """
//{
//"data" : {
//"content" : "\n\n\n<header><div class=\"tt-title\">美常驻联合国代表：或就化武事件对叙采取新行动<\/div><\/header>\n\n\n<article><a class=\"image\"  href=\"bytedance:\/\/large_image?url=http%3A%2F%2Fp9.pstatp.com%2Flarge%2F6ec60007b65d39ea4a7f&index=0\"\nwidth=\"480\" height=\"260\"\nthumb_width=\"120\" thumb_height=\"65\" ><\/a><p><strong>海外网3月13日电<\/strong>据俄罗斯卫星通讯社报道，美国常驻联合国代表妮基·黑莉12日在联合国安理会上表示，美国在必要情况下或就叙利亚境内的化武袭击采取新的行动。<\/p><p>据悉，2017年4月4日，叙利亚反对派发表声明称，伊德利卜省遭到化武攻击，80人死亡，200人受伤，反对派称叙利亚政府军应为此负责。叙政府军否认该指控，指责恐怖分子及其庇护者发动了袭击。俄罗斯国防部表示，叙利亚空军袭击了恐怖分子位于伊德利卜省汉谢洪镇市郊区的一个弹药库，后来被运往伊拉克的化学武器曾存放在此地的军火库中。<\/p><p>叙利亚政府曾表示，叙政府军从未使用过并且不打算针对平民和恐怖分子使用化学武器，并强调说，该国的全部化学武器早已在禁止化学武器组织监督下运出。<\/p><p>联合国与禁化武组织的联合调查机制2017年10月底向联合国安理会提交了有关叙利亚汉谢洪镇2017年4月4日的沙林袭击事件的报告。专家认定，该事件中沙林是叙利亚政府军施放的。<\/p><p>俄罗斯常驻联合国代表涅边贾称，俄罗斯愿意就成立调查叙利亚化学攻击的新机制进行讨论，因为当前联合调查机制已声誉尽毁。（海外网 张振）<\/p><p>本文系版权作品，未经授权严禁转载。海外视野，中国立场，登陆人民日报海外版官网——海外网www.haiwainet.cn或“海客”客户端，领先一步获取权威资讯。<\/p><p class=\"footnote\">运营人员： 马文晶 MZ012<\/p><\/article>\n\n\n<footer><\/footer>\n",
//"item_id" : 6532141943768482311,
//"media_user_id" : 3242684112,
//"group_id" : 6532141943768482311,
//"thumb_image" : [
//{
//"width" : 480,
//"height" : 260,
//"uri" : "thumb\/6ec60007b65d39ea4a7f",
//"url" : "http:\/\/p9.pstatp.com\/thumb\/6ec60007b65d39ea4a7f",
//"url_list" : [
//{
//"url" : "http:\/\/p9.pstatp.com\/thumb\/6ec60007b65d39ea4a7f"
//},
//{
//"url" : "http:\/\/pb1.pstatp.com\/thumb\/6ec60007b65d39ea4a7f"
//},
//{
//"url" : "http:\/\/pb3.pstatp.com\/thumb\/6ec60007b65d39ea4a7f"
//}
//]
//}
//],
//"aggr_type" : 1,
//"is_wenda" : 0,
//"image_detail" : [
//{
//"width" : 480,
//"height" : 260,
//"uri" : "large\/6ec60007b65d39ea4a7f",
//"url" : "http:\/\/p9.pstatp.com\/large\/6ec60007b65d39ea4a7f",
//"url_list" : [
//{
//"url" : "http:\/\/p9.pstatp.com\/large\/6ec60007b65d39ea4a7f"
//},
//{
//"url" : "http:\/\/pb1.pstatp.com\/large\/6ec60007b65d39ea4a7f"
//},
//{
//"url" : "http:\/\/pb3.pstatp.com\/large\/6ec60007b65d39ea4a7f"
//}
//]
//}
//],
//"h5_extra" : {
//    "media" : {
//        "name" : "海外网",
//        "user_auth_info" : "{\"auth_type\": \"0\", \"auth_info\": \"海外网官方头条号\"}",
//        "user_verified" : true,
//        "can_be_praised" : false,
//        "description" : "人民日报海外版官方网站",
//        "v" : false,
//        "avatar_url" : "http:\/\/p2.pstatp.com\/large\/1687\/8327084584",
//        "creator_id" : 3242684112,
//        "auth_info" : "海外网官方头条号",
//        "praise_data" : {
//
//        },
//        "show_pgc_component" : true,
//        "id" : 3244931401,
//        "pgc_custom_menu" : ""
//    },
//    "source" : "海外网",
//    "str_item_id" : "6532141943768482311",
//    "media_user_id" : "3242684112",
//    "is_original" : false,
//    "publish_time" : "03-13 02:39",
//    "publish_stamp" : "1520879940",
//    "str_group_id" : "6532141943768482311",
//    "title" : "美常驻联合国代表：或就化武事件对叙采取新行动",
//    "src_link" : "https:\/\/m.haiwainet.cn\/ttc\/3541093\/2018\/0313\/content_31276889_1.html?s=toutiao"
//}
//},
//"message" : "success"
//}
//"""

let detailImageWidth = Double(screenWidth - 20)

struct NewsDetail: Codable {
    var content: String
    var image_detail: [NewsDetailImage]?
}

class NewsDetailImage: Codable {
    var width: Double = 0.0
    var height: Double = 0.0
    var uri: String = ""
    var url: String = ""
    
    // 根据设备计算图片显示的宽高
    func fitWidthAndHeight(width originWidth: Double,
                                    height originHeight: Double) {
        width = originWidth > detailImageWidth ? detailImageWidth : originWidth
        height = width * originHeight / originWidth
    }
}
