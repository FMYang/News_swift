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

class ChannelViewModel {

    var channels: [Channel] = []

    func getChannel() {
        Network.request(NewsAPi.channel) { [weak self] (result) in
            switch result {
            case .success(let response):
                do {
                    let json = try JSON(data: response.data)
                    let array = json["data"]["data"]
                    self?.channels = try JSONDecoder().decode([Channel].self, from: array.rawData())
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
