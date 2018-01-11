//
//  AlamofireGetProperty.swift
//  RequestManager
//
//  Created by 李鹏跃 on 2018/1/7.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

import UIKit

extension NSObject {
    
    func getPropertyNames() -> ([String]){
        
        var outCount:UInt32
        
        outCount = 0
        
        let propers = class_copyPropertyList(self.classForCoder, &outCount)!
        
        
        
        let count:Int = Int(outCount);
        
        dPrint("共有\(outCount)个")
        var propertyArray = [String]()
        for i in 0...(count-1) {
            
            let aPro: objc_property_t = propers[i]!
            
            let proName:String! = String.init(utf8String: property_getName(aPro))
            
            propertyArray.append(proName)
        }
        return propertyArray
    }
}
