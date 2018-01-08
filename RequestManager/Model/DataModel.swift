//
//  DataModel.swift
//  RequestManager
//
//  Created by 李鹏跃 on 2018/1/7.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

import UIKit

class DataModel: AlamofireMenagerMap {
    var aaasaaaaaaa: String?
    
    var status: String?
    var total_count: NSInteger = -1

    var count: NSInteger = -1 {
        didSet{
//            
        }
    }
    var deals:[DataModelArray]?
}

class DataModelArray: AlamofireMenagerMap {
    var deal_id:NSInteger = -1
    var title:String?
    var descriptio:String?
    var city: String?
}
