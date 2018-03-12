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

enum RequestStatus {
    case success
    case emptyData
    case serviceError
    case networkLost
}

class ViewModel {
    func getNewsList(channel: String, count: Int) -> Observable<RequestStatus> {
        return Observable.create({ (observe) -> Disposable in

            var status: RequestStatus = .success

            Network.request(NewsAPi.newsList(channel: channel, count: count)) { (result) in
                do {
                    switch result {
                    case .success(let reponse):
                        let json = try JSON(data: reponse.data)
                        let array = json["data"].arrayValue
                        status = .success
                        print(array)
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
