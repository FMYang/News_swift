//
//  ActivityPlugin.swift
//  RX+Moya
//
//  Created by 杨方明 on 2018/3/12.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import Foundation
import Moya
import Result

public final class ActivityPlugin: PluginType {
    public func willSend(_ request: RequestType, target: TargetType) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
