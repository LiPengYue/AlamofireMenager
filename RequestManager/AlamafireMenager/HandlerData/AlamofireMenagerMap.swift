//
//  AlamofireMenagerMap.swift
//  RequestManager
//
//  Created by 李鹏跃 on 2018/1/6.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

import UIKit
import ObjectMapper
class AlamofireMenagerMap: NSObject, Mappable {
    ///已经key对应的属性将要赋值
    private var setingValueCallBack: ((_ key:String,_ value: AnyObject)->())?
    
    ///已经key对应的属性已经赋值
    private var setedValueCallBack: ((_ key:String,_ value: AnyObject)->())?
   
    ///已经key对应的属性将要赋值
    func setingValue(_ callBack: @escaping (_ key:String,_ value: AnyObject)->()?){
        setingValueCallBack = callBack as? ((String, AnyObject) -> ())
    }
    ///已经key对应的属性已经赋值
    func setedValue(_ callBack: @escaping (_ key:String,_ value: AnyObject)->()?){
        setedValueCallBack = callBack as? ((String, AnyObject) -> ())
    }

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        let propertyNames = self.getPropertyNames()
        for key in propertyNames {
            dPrint(key)
            var property = value(forKey: key)
            property <- map[key]
            setingValueCallBack?(key,property as AnyObject)
            setValue(property, forKey: key)
            setedValueCallBack?(key,property as AnyObject)
        }
    }
    
}

