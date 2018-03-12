//
//  FMTargetType.swift
//  RX+Moya
//
//  Created by 杨方明 on 2018/3/11.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import Foundation
import Moya

let requestClosure = { (endpoint: Endpoint<MultiTarget>, done: @escaping MoyaProvider<MultiTarget>.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        request.timeoutInterval = 10    //设置请求超时时间
        done(.success(request))
    } catch {
        print("")
    }
}

let ApiProvider = MoyaProvider<MultiTarget>(endpointClosure: MoyaProvider.defaultEndpointMapping, requestClosure: requestClosure, plugins: [ActivityPlugin()])

public protocol ApiTargetType: TargetType {
    var parameters: [String: Any]? { get }
    var url: String { get }
}

public extension ApiTargetType {
    public var path: String {
        return self.url
    }
    
    /// The target's base `URL`.
    public var baseURL: URL {
        return URL(string: "http://lf.snssdk.com")!
    }
    
    public var parameters: [String: Any]? {
        return self.parameters ?? [:]
    }
    
    /// The HTTP method used in the request.
    public var method: Moya.Method {
        return .get
    }
    
    /// Provides stub data for use in testing.
    public var sampleData: Data {
        return Data()
    }
    
    /// The type of HTTP task to be performed.
    public var task: Task {
        /*
           通过不同的方式设置body和参数，使用不同的方法，详情看Task.swift的说明
           requestCompositeParameters 参数拼接到url后面的格式
           requestParameters 参数放到body中的格式
         */
        if method == .get {
            if let params = self.parameters {
                return .requestCompositeData(bodyData: Data(), urlParameters: params)
            } else {
                return .requestPlain
            }
        } else {
            return .requestParameters(parameters: self.parameters ?? [:], encoding: JSONEncoding.default)
        }
    }
    
    /// The headers to be used in the request.
    public var headers: [String: String]? {
        return nil
    }
}
