//
//  ChannelViewModel.swift
//  RX+Moya
//
//  Created by yfm on 2018/3/12.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import RxSwift

class ChannelViewModel {

    var channels: [Channel] = []

    func getChannel() -> Observable<RequestStatus> {
        return Observable.create({ (observe) -> Disposable in
            Network.request(NewsAPi.channel) { [weak self] (result) in
                var status: RequestStatus = .success
                switch result {
                case .success(let response):
                    do {
                        let json = try JSON(data: response.data)
                        let array = json["data"]["data"]
                        self?.channels = try JSONDecoder().decode([Channel].self, from: array.rawData())
                        status = .success
                    } catch {
                        status = .serviceError
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
