//
//  KRParameterMenager.swift
//  KReadingStuHD
//
//  Created by 李鹏跃 on 2017/12/21.
//  Copyright © 2017年 Koalareading. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

///请求方式
enum RequestMethod: String {
    case options = "OPTIONS"
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case trace = "TRACE"
    case connect = "CONNECT"
}

/// 参数拼接的类型
enum ParamaetersType: String {
    case body = "body"
    case query = "query"
}

/// 请求 数据类型
enum ResponseDateType: String {
    case array = "array"
    case object = "Object"
    case json = "json"
}

class AlamofireSession: NSObject {
    static let `default`: AlamofireSession = AlamofireSession()
    /// 请求数据的 Menager
     var sessionMenager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = TimeInterval(Alamafire_TimeoutIntervalForRequest)
        
        let sessionMenager = SessionManager.init(configuration: configuration, delegate: AlamofireSessionDelegate(), serverTrustPolicyManager: nil)
        
        return sessionMenager
    }()
}
