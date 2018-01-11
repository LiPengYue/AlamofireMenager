//
//  AlamofireURLMenager.swift
//  RequestManager
//
//  Created by 李鹏跃 on 2018/1/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

import UIKit
import Alamofire
class AlamofireURLMenager: NSObject {
    
    private class func getBaseURLStr(_ str: String) -> (String) {
        return baseURL + str
    }
    ///返回一个url 并且 cach处理
    class func getURL(_ path:String) throws -> URL {
        var urlStr = AlamofireURLMenager.getBaseURLStr(path)
        urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        guard let URL = URL(string: urlStr) else { throw AFError.invalidURL(url: urlStr) }
        return URL
    }
}
