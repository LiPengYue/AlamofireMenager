//
//  RequestMenager.swift
//  RequestMenager
//
//  Created by 李鹏跃 on 2017/12/21.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit
import Alamofire

/**
 特殊符号 十六进制值
 + 转义符为 %2B
 空格 转义符为 + 或 %20
 / 转义符为 %2F
 ? 转义符为 %3F
 % 转义符为 %25
 # 转义符为 %23
 & 转义符为 %26
 = 转义符为 %3D
 */

/// qury 参数
private let query_Parameter = URLEncoding.init(destination: .queryString)

/// body 参数
private let httpBody_Parameter = URLEncoding.init(destination: .httpBody)

class RequestMenager: NSObject {

    //MARK: - downLoad Request
    
    /// 获取 下载请求
    ///
    /// - Parameters:
    ///   - path: url
    ///   - HTTPMethod_: 请求方式
    ///   - parameters: 请求参数
    ///   - parametersType: 请求参数 拼接类型
    /// - Returns: DataRequest
    class func getLoadDataRequest(Path path: String,HTTPMethod HTTPMethod_: HTTPMethod? = .get,_ parameters: [String:Any]? = nil,_ parametersType: ParamaetersType? = nil) ->(DataRequest?) {
        let request = RequestMenager.getLoadDataURLRequest(Path: path, HTTPMethod: HTTPMethod_, parameters, parametersType)
        if let request = request {

            return AlamofireSession.default.sessionMenager.request(request)
        }
        return nil
    }
   
    class private func getLoadDataURLRequest(Path path: String,HTTPMethod HTTPMethod_: HTTPMethod? = .get,_ parameters: [String:Any]? = nil,_ parametersType: ParamaetersType? = nil) -> (URLRequest?){
      
        do{
            let url = try AlamofireURLMenager.getURL(path)
            var requst = URLRequest.init(url: url)
            requst.httpMethod = (HTTPMethod_ ?? .get).rawValue
            
            ///传入 一些全局header 比如
            for (value,key) in Alamofire_header ?? Dictionary() {
                requst.setValue(value, forHTTPHeaderField: key)
            }
            
            //传入版本  "Version": "2.1.0"
            switch parametersType ?? .query{
                
            case .query:
                return try query_Parameter.encode(requst, with: parameters)
                
            case .body:
                return try httpBody_Parameter.encode(requst, with: parameters)
            }
        } catch {
            dPrint("🌶\n 数据下载 request 转化失败 " + path + "🌶\n")
            return nil
        }
    }
    
    //MARK: - upload Request
    class func getUploadRequest(_ path : String,_ method: HTTPMethod,headers: HTTPHeaders? = nil) -> (URLRequest?){
        do {
            let url = try AlamofireURLMenager.getURL(path)
            var requst = try URLRequest(url: url, method: method, headers: headers)
            ///传入 一些全局header
            if let headers = Alamofire_header {
                for (value,key) in headers {
                    requst.setValue(value, forHTTPHeaderField: key)
                }
            }
            return requst
        }catch{
            dPrint("🌶\n 数据上传 request 转化失败 " + path + "🌶\n")
            return nil
        }
    }
}


