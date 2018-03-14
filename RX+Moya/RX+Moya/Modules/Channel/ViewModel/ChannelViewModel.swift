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
            ChannelDB.getObjects(completeHandle: { (result) in
                // 如果本地存在，返回本地的数据
                if let channels = result, channels.count > 0 {
                    self.channels = channels
                    observe.onNext(.success)
                } else {
                    // 如果本地不存在获取服务器的数据返回，保存本地
                    Network.request(NewsAPi.channel) { [weak self] (result) in
                        var status: RequestStatus = .success
                        switch result {
                        case .success(let response):
                            do {
                                let json = try JSON(data: response.data)
                                let array = json["data"]["data"]
                                self?.channels = try JSONDecoder().decode([Channel].self, from: array.rawData())
                                status = .success

                                // 保存栏目数据
                                if let objects = self?.channels {
                                    ChannelDB.insertOrReplace(objects: objects)
                                }
                            } catch {
                                print(error)
                                status = .serviceError
                            }
                        case .failure(_):
                            status = .serviceError
                        }
                        observe.onNext(status)
                    }
                }
            })

            return Disposables.create()
        })
    }
}
