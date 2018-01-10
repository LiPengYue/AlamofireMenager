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
var baseServerWord: String = "api"
var baseURL: String {
    get {
        return "http://\(baseServerWord).dianping.com/"
    }
}

//MARK: - code 的处理

///code 处理 是否打印Log日志
let isPrintSucceedNetWorkLog: Bool = true
///是否打印失败请求
let isPrintErrorNetWorkLog: Bool = true
///是否打印请求成功后的数据
let isPrintSucceedData: Bool = isDebug
///code处理的类 更改这里 全局配置code 的处理类
let k_codeMenager: RespnseCodeMenager.Type = KRCodeHandler.self


//MARK: - 超时时间
///超时时间
let Alamafire_TimeoutIntervalForRequest:TimeInterval = 10


//MARK: - 所有请求都会带的东西比如 版本和 cookie
var Alamofire_header: [String:String]? {
    get {
        return [
            "Version": KR_Version
        ]
    }
}
private var versionPrivate: String?
var KR_Version: String {
    get {
        if let versionPrivate_ = versionPrivate {
            return versionPrivate_
        }
        versionPrivate = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)
        return versionPrivate ?? "没有version😁"
    }
}


/**
 * log 在release 版本不打印
 * 注意要在 项目的 budSeting中 查找 `Other Swift Flags`，修改debug模式的flag 为“DEBUG”
 */
func dPrint(_ item: @autoclosure () -> Any) {
    if isDebug {
        print(item())
    }
}

///是否为debug模式
var isDebug: Bool {
    get {
        #if DEBUG
            return true
            #else
            return false
        #endif
    }
}

