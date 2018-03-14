//
//  Network.swift
//  RX+Moya
//
//  Created by yfm on 2018/3/12.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

/// 网路请求日志打印
///
/// - Parameters:
///   - url: 请求URL
///   - params: 请求参数
///   - response: 返回成功结果
///   - error: 返回错误
///   - statusCode: HTTP状态码
func networkLog(url: String,
                params: Any? = nil,
                response: Any? = nil,
                error: Any? = nil,
                httpStatusCode: Int = 404) {
    var output: String = ""
    output += "======================== BEGIN REQUEST =========================\n\r"
    output += "请求URL: \n\(url)\n\r"
    output += "请求参数: \n\(params ?? "nil")\n\r"
    output += "http状态码: \n\(httpStatusCode)\n\r"
    output += "返回结果: \n\(response ?? error ?? "")\n\r"
    output += "======================== END REQUEST ===========================\n\r"
    print(output)
}

class Network {
    
    /// 网络请求
    ///
    /// - Parameters:
    ///   - target: ApiTargetType
    ///   - completion: 请求完成回调
    static func request(_ target: ApiTargetType, completion: @escaping Completion) {
        ApiProvider.request(MultiTarget(target),
                                   callbackQueue: nil,
                                   progress: nil) { (result) in
                                    var data: JSON? = nil
                                    var resultError: Error? = nil
                                    var httpStatusCode: Int = 200
                                    do {
                                        switch result {
                                        case .success(let moyaResponse):
                                            httpStatusCode = moyaResponse.statusCode
                                            // 200~298表示请求正确，否则请求失败，抛出异常，到catch中处理
                                            let response = try moyaResponse.filter(statusCodes: 200...298)
                                            data = try JSON(data: response.data)
                                            completion(result)
                                        case .failure(let error):
                                            resultError = error
                                        }

                                    } catch {
                                        resultError = error
                                    }

                                    networkLog(url: target.baseURL.absoluteString + target.path, params: target.parameters, response: data, error: resultError, httpStatusCode: httpStatusCode)
        }
    }
}
