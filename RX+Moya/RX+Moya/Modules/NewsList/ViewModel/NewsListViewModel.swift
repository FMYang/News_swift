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
                        
                        for dic in array {
                            do {
                                let data = dic["content"].stringValue.data(using: String.Encoding.utf8)
                                if let data = data {
                                    let result: News = try JSONDecoder().decode(News.self, from: data)
                                    status = .success
                                    self?.news.append(result)
                                }
                            } catch {
                                status = .serviceError
                            }
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
