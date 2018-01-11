//
//  PYSwitchURLDelegate.swift
//  KReadingStuHD
//
//  Created by 李鹏跃李鹏跃 on 2018/1/10.
//  Copyright © 2018年 Koalareading. All rights reserved.
//

import UIKit

class PYSwitchURLDelegate: NSObject {
   
    
    class func error_NotURLStr(currentModel: PYSwitchURLModel) {
        
    }
    
    class func ssucceed(model: PYSwitchURLModel) {
        baseServerWord_debug = model.URLStr!
        //登出操作
        //登陆操作 参数
//        let parameters : [String : Any] =
//            [
//                "account" : model.userName ?? "",
//                "password": model.password ?? "",
//                "userType": 2
//        ]
        //登陆请求
        //。。。。。
        //这里面应该写你的 登陆和登出 接口，这里为了测试 。。先这么写了
        let alamofireMenager = AlamofireMenager.init()
        let parameters = ["appkey":"11474086",
                          "limit":"24",
                          "city":"北京",
                          "page":"1",
                          "sign":"93AD7448260235FCB3F691EF4CE8B2B12E6C0472"]
        
        alamofireMenager.loadData(Path: "v1/deal/find_deals", HTTPMethod: .get, parameters, .query, Success: { (banner: DataModel,netData)  in
            
        }) { (str) in
            
        }
    }
}
