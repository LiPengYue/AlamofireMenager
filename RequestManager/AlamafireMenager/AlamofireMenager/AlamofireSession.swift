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
