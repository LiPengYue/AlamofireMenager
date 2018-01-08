//
//  KRCodeHandler.swift
//  koalareading
//
//  Created by 李鹏跃 on 2017/12/25.
//  Copyright © 2017年 koalareading. All rights reserved.
//

import UIKit

class KRCodeHandler: RespnseCodeMenager {
    ///继承这个这个类，并且 重写这个函数 来处理 code
    override class func custom_handCodeFunc(_ code: NSInteger, _ netData: Any?, _ error: Error?, _ url: URL?) {
        
    }
    
    ///继承这个这个类，并且 重写这个函数 来处理 成功code
    override class func custom_handSucceedCodeFunc(_ netData: Any?, _ url: URL?) {
        
    }
    
    ///继承这个这个类，并且 重写这个函数 来处理 失败code
    override class func custom_handDefeatCodeFunc(_ code: NSInteger,_ error: Error?, _ url: URL?) {
        
    }
}
