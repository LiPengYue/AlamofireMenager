//
//  AlamafireMenager_Configuration.swift
//  RequestManager
//
//  Created by 李鹏跃 on 2017/12/22.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//


///一些统一的配置

import UIKit

///域名 配置
//let baseServerWord = "test"
//var baseServerWord = "demo"

/// release模式 是哪个环境,一定要写对，
let baseServerWord_release = "api"

///debug模式 下默认是什么环境
var baseServerWord_debug: String = "demo"

var baseURL: String {
    get {
        if !isDebug {
            return "http://\(baseServerWord_release).dianping.com/"
        }
        return "http://\(baseServerWord_debug).dianping.com/"
    }
}


//MARK: - code 的处理

///code 处理 是否打印Log日志
let isPrintSucceedNetWorkLog: Bool = true
///是否打印失败请求
let isPrintErrorNetWorkLog: Bool = true
///是否打印请求成功后的数据
let isPrintSucceedData: Bool = true
///code处理的类 更改这里 全局配置code 的处理类
let k_codeMenager: RespnseCodeMenager.Type = KRCodeHandler.self


//MARK: - 超时时间
///超时时间
let Alamafire_TimeoutIntervalForRequest:TimeInterval = 10


//MARK: - 所有请求都会带的东西比如 版本和 cookie
var Alamofire_header: [String:String]? {
    get {
        return [
//            "Cookie" : KRUserInfoManager.shared.cookieManager.clientCookie,
            "Version": PY_Version
        ]
    }
}





