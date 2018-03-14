//
//  RequestStatus.swift
//  RX+Moya
//
//  Created by 杨方明 on 2018/3/12.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import Foundation

public enum RequestStatus {
    case success
    case emptyData
    case serviceError
    case networkLost
    case clientError
}
