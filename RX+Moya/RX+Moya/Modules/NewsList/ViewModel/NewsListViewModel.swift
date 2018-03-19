//
//  ViewModel.swift
//  RX+Moya
//
//  Created by 杨方明 on 2018/1/7.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON

class NewsListViewModel {
    
    var news: [News] = []
    
    func getNewsList(channel: String, count: Int) -> Observable<RequestStatus> {
        return Observable.create({ (observe) -> Disposable in
            var status: RequestStatus = .serviceError
            Network.request(NewsAPi.newsList(channel: channel, count: count)) { [weak self] (result) in
                do {
                    switch result {
                    case .success(let reponse):
                        let json = try JSON(data: reponse.data)
                        let array = json["data"].arrayValue
                        
                        var resultNews = [News]()
                        for dic in array {
                            do {
                                let contentData = dic["content"].stringValue.data(using: .utf8)
                                var contentDic = try JSON.init(data: contentData!)
                                contentDic["category"] = ""
                                contentDic["publishTimeString"] = ""
                                let data = try contentDic.rawData()
                                let result: News = try JSONDecoder().decode(News.self, from: data)
                                result.timeStampToString()
                                status = .success
                                resultNews.append(result)
                            } catch {
                                print(error)
                                status = .serviceError
                            }
                        }
                        self?.news = resultNews

                        // 保存数据
                        NewsListDB.deleteAll(by: channel) {
                            for model in resultNews {
                                model.category = channel
                            }
                            NewsListDB.insert(objects: resultNews)
                        }
                    case .failure(_):
                        status = .serviceError
                    }
                } catch {
                    print(error)
                }
                observe.onNext(status)
            }
            return Disposables.create()
        })
    }
}
