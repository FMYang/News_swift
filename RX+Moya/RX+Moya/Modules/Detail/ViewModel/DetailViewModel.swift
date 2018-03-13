//
//  DetailViewModel.swift
//  RX+Moya
//
//  Created by yfm on 2018/3/13.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift

class DetailViewModel {

    var detail: NewsDetail?

    func getDetail(newId: Int) -> Observable<RequestStatus> {
        return Observable.create({ (observe) -> Disposable in
            var status: RequestStatus = .serviceError
            Network.request(NewsAPi.newsDetail(id: newId)) { [weak self] (result) in
                switch result {
                case .success(let response):
                    do {
                        let resultJson = try! JSON.init(data: response.data)
                        let data = resultJson["data"]
                        let newsDetail = try JSONDecoder().decode(NewsDetail.self, from: data.rawData())
                        self?.detail = newsDetail
                        status = .success
                    } catch {
                        print(error)
                        status = .clientError
                    }
                case .failure(_):
                    status = .serviceError
                }
                observe.onNext(status)
            }
            return Disposables.create()
        })
    }
}
