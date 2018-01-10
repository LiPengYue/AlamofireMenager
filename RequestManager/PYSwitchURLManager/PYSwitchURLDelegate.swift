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
        baseServerWord = model.URLStr!
        //登出操作
        //登陆操作 参数
        let parameters : [String : Any] =
            [
                "account" : model.userName ?? "",
                "password": model.password ?? "",
                "userType": 2
        ]
        //登陆请求
        //。。。。。
    }
}
