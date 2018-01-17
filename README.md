![PYNetManager.gif](http://upload-images.jianshu.io/upload_images/4185621-fac8725717c562fd.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
[可以在debug模式下，可以选择测试url](https://www.jianshu.com/p/051eb0666862)
[demo点这里](https://github.com/LiPengYue/AlamofireMenager)

#简介：
>1. 实现统一设置：超时时长、header、对code码的处理。。
>2. 统一对url进行了转码。（空格等特殊字符不崩溃）
>3. 使用简单，自动转化成为对象。（array，object，json）
>4. 对请求结果的清晰打印。（分为正确、错误，只有在debug模式会打印，可以在AlamafireMenager_Configuration中配置是否打印）

#结构：
>1. AlamafireMenager_Configuration.swift
`对一些公共信息的配置`
>2. AlamofireMenager.swift
`对外暴露请求的接口`
>3. AlamofireSession.swift
`对SessionManager的封装`
>4. RequestMenager.swift
`生成了request，（分为loadDataRequest与updataReqeust）`
KRURLMenager
`对url的处理`
>5. RespnseCodeMenager.swift
`打印了请求出的信息。（成功，失败），可以继承自这个类自定义处理code`

#封装思路
##全局的配置
```
///一些统一的配置

import UIKit

///域名 配置
let baseURL = "http://api.dianping.com/"

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
```

##1. 对url的封装
**`KRURLMenager`**: 对url的path进行了一个特殊字符的处理，并返回一个不可选类型的URL
```
class KRURLMenager: NSObject {
    
    static let baseURLString = baseURL
    
    private class func getBaseURLStr(_ str: String) -> (String) {
        return KRURLMenager.baseURLString + str
    }
    ///返回一个url 并且 cach处理
    class func getURL(_ path:String) throws -> URL {
        var urlStr = KRURLMenager.getBaseURLStr(path)
        urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        guard let URL = URL(string: urlStr) else { throw AFError.invalidURL(url: urlStr) }
        return URL
    }
}
```
##2.对Request的封装
**`RequestMenager`： 要把全局的header传入到Request中,且做了特殊字符的处理，
默认生成了全局的配置参数对象，根据传入的参数来拼接url参数,最后返回一个`DataRequest`**
```
/// qury 参数
private let query_Parameter = URLEncoding.init(destination: .queryString)

/// body 参数
private let httpBody_Parameter = URLEncoding.init(destination: .httpBody)
```
```
 //MARK: - downLoad Request
    
    /// 获取 下载请求
    ///
    /// - Parameters:
    ///   - path: url
    ///   - HTTPMethod_: 请求方式
    ///   - parameters: 请求参数
    ///   - parametersType: 请求参数 拼接类型
    /// - Returns: DataRequest
    class func getDataRequest(Path path: String,HTTPMethod HTTPMethod_: HTTPMethod? = .get,_ parameters: [String:Any]? = nil,_ parametersType: ParamaetersType? = nil) ->(DataRequest?) {
        let request = RequestMenager.getURLRequest(Path: path, HTTPMethod: HTTPMethod_, parameters, parametersType)
        if let request = request {

            return AlamofireSession.default.sessionMenager.request(request)
        }
        return nil
    }
   
    class func getURLRequest(Path path: String,HTTPMethod HTTPMethod_: HTTPMethod? = .get,_ parameters: [String:Any]? = nil,_ parametersType: ParamaetersType? = nil) -> (URLRequest?){
      
        do{
            let url = try KRURLMenager.getURL(path)
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
```


##3.对 SessionManager 的封装
**`AlamofireSession`：对超时时间修改**
```
class AlamofireSession: NSObject {
    static let `default`: AlamofireSession = AlamofireSession()
    /// 请求数据的 Menager
     var sessionMenager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = TimeInterval(Alamafire_TimeoutIntervalForRequest)
        
        let sessionMenager = SessionManager.init(configuration: configuration, delegate: AlamofireSessionDelegate(), serverTrustPolicyManager: nil)
        
        return sessionMenager
    }()
}
```

##4. 对 Mappable 的封装
**`AlamofireMenagerMap`遵循了`Mappable`协议**
内部实现了` func mapping(map: Map)`,用到了运行时，获取了属性名,并调用了相应的map方法。
从而实现了继承自`AlamofireMenagerMap`的model，不再需要写` func mapping(map: Map)`方法
```
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
            print(key)
            var property = value(forKey: key)
            property <- map[key]
            setingValueCallBack?(key,property as AnyObject)
            setValue(property, forKey: key)
            setedValueCallBack?(key,property as AnyObject)
        }
    }   
}
```

##5.动态获取对象的 propertyNames
**AlamofireGetProperty.swift**
```

extension NSObject {
    
    func getPropertyNames() -> ([String]){
        
        var outCount:UInt32
        
        outCount = 0
        
        let propers = class_copyPropertyList(self.classForCoder, &outCount)!
        
        
        
        let count:Int = Int(outCount);
        
        print("共有\(outCount)个")
        var propertyArray = [String]()
        for i in 0...(count-1) {
            
            let aPro: objc_property_t = propers[i]!
            
            let proName:String! = String.init(utf8String: property_getName(aPro))
            
            propertyArray.append(proName)
        }
        return propertyArray
    }
}
```




#使用
##RespnseCodeMenager.swift
```
import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper


public class RespnseCodeMenager: NSObject {
    ///继承这个这个类，并且 重写这个函数 来处理 code
    class func custom_handCodeFunc(_ code: NSInteger, _ netData: Any?, _ error: Error?, _ url: URL?) {}
    
    ///继承这个这个类，并且 重写这个函数 来处理 成功code
    class func custom_handSucceedCodeFunc(_ netData: Any?, _ url: URL?) {}
    
    ///继承这个这个类，并且 重写这个函数 来处理 失败code
    class func custom_handDefeatCodeFunc(_ code: NSInteger,_ error: Error?, _ url: URL?) {}
    
    ///code log  处理
    class func handleCode (_ code: NSInteger, _ netData: Any?, _ error: Error?, _ url: URL?) -> (Bool) {
        custom_handCodeFunc(code, netData, error, url)
        if code / 100 == 2 {
            succeed(netData,url)
            custom_handSucceedCodeFunc(netData, url)
            return true
        }
        custom_handDefeatCodeFunc(code, error, url)
        defeat(code, error, url)
        return false
    }
}

/// log输出
private extension RespnseCodeMenager {
    
    class func succeed(_ netData: Any?, _ url: URL?) {
        if !isPrintSucceedNetWorkLog {
            return
        }
        
        let urlTemp: Any = url ?? "url 未知"
        let dataTemp: Any = netData ?? "data 未知"
        
        dPrint("\n\n✅✅✅请求成功\n✅\(urlTemp)\n")
        
        if let dataArray = (dataTemp as? Array<Any>) {
             dPrint("\netData(Array):--")
            for data in dataArray {
                dPrint(data)
            }
        }else{
            dPrint("\netData(Object):--")
            dPrint(dataTemp)
        }
        
        dPrint("✅✅✅\n\n\n\n")
    }
    
    class func defeat(_ code: NSInteger,_ error: Error?, _ url: URL?) {
        
        if !isPrintErrorNetWorkLog {
            return
        }
        
        let urlTemp: Any = url ?? "url 未知"
        let errorTemp: Any = error ?? "error 未知"
        
        dPrint("\n\n🌶🌶🌶请求失败\n\(code)\(urlTemp)\n")
        
        dPrint("\n🌶error:--")
        dPrint(errorTemp)
        dPrint("🌶🌶🌶\n\n\n\n")
    }
}
```

##AlamofireMenager.swift
**使用注意请求类型的区分,方法名称一致**
>1. 根据success回调传入的<T>的类型返回对应的值
>2. T 为 [BaseMappable]，则返回数组，
>3. T 为BaseMappable，则返回对象，
>4. T 为Any，则返回Json字符串。

**object**
```
//MARK: - 下载数据 相关接口
    
    /// alamofire 数据请求 （数据为object）
    ///注意循环引用
    /// - Parameters:
    ///   - path: url path
    ///   - method: 请求方式
    ///   - parameters: 参数
    ///   - parametersType: 参数为 query 还是 body
    ///   - responseDateType: 网络数据类型
    ///   - success: 成功的回调
    ///   - failure: 失败的回调
    /// - Returns: Request
    @discardableResult
    func loadData<T:BaseMappable>(Path path: String, HTTPMethod method: RequestMethod? = .get,_ parameters: [String:Any]? = nil,_ parametersType: ParamaetersType? = nil,_ setRequest: ((_ request: DataRequest) -> Void)? = nil,Success success: @escaping (_ M:T,_ response:DataResponse<T>) -> Void, Failure failure:@escaping(_ errorMsg:String) -> Void) -> (DataRequest?) {
        
        return self.loadDataObject(Path: path, HTTPMethod: method, parameters, parametersType, setRequest, Success: success, Failure: failure)
    }
```

**Json**
```
 /// alamofire 数据请求 (数据Json)
    ///注意循环引用
    /// - Parameters:
    ///   - path: url path
    ///   - method: 请求方式
    ///   - parameters: 参数
    ///   - parametersType: 参数为 query 还是 body
    ///   - responseDateType: 网络数据类型
    ///   - success: 成功的回调
    ///   - failure: 失败的回调
    /// - Returns: Request
    @discardableResult
    func loadData(Path path: String, HTTPMethod method: RequestMethod? = .get,_ parameters: [String:Any]? = nil,_ parametersType: ParamaetersType? = nil,_ setRequest: ((_ request: DataRequest) -> Void)? = nil,Success success: @escaping (_ json: Any,_ response: DataResponse<Any>) -> Void, Failure failure:@escaping(_ errorMsg:String) -> Void) -> (DataRequest?) {
        
        return self.loadDataJson(Path: path, HTTPMethod: method, parameters, parametersType, setRequest, Success: success, Failure: failure)
    }
```

**array**
```
/// alamofire 数据请求 (数据数组)
    ///注意循环引用
    /// - Parameters:
    ///   - path: url path
    ///   - method: 请求方式
    ///   - pxarameters: 参数
    ///   - parametersType: 参数为 query 还是 body
    ///   - responseDateType: 网络数据类型
    ///   - success: 成功的回调
    ///   - failure: 失败的回调
    /// - Returns: Request
    @discardableResult
    func loadData<T:BaseMappable>(Path path: String, HTTPMethod method: RequestMethod? = .get,_ parameters: [String:Any]? = nil,_ parametersType: ParamaetersType? = nil,_ setRequest: ((_ request: DataRequest) -> Void)? = nil,Success success: @escaping ([T],_ response: DataResponse<[T]>) -> Void, Failure failure:@escaping(_ errorMsg:String) -> Void) -> (DataRequest?) {
        
       return self.loadDataArray(Path: path, HTTPMethod: method, parameters, parametersType, setRequest, Success: success, Failure: failure)
    }
```
**上传**
````
///上传
    ///
    /// - Parameters:
    ///   - urlStr: url
    ///   - method: 请求方法
    ///   - params: 请求参数（根据key来拼接（后续可能回接入用户名与token））
    ///   - data: 照片数据
    ///   - name: 需要与后台协商成统一字段
    ///   - fileNameArray: 文件名称，看后台有没有要求
    ///   - headers: header 可以没有
    ///   - mimeType: mimeType
    ///   - success: 成功
    ///   - failture: 失败 -- 如果没有数据，相当于失败。
    func upload(_ urlStr : String,_ method: HTTPMethod, _ params:[String:String],_ data: [Data],_ names:[String],_ fileNames:[String], _ headers: [String:String]?,_ mimeType: String, success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
        
        self.uploadFunc(urlStr, method, params, data, names, fileNames, headers, mimeType, success: success, failture: failture)
    }
````
**上传图片**
```
///图片 上传
    ///
    /// - Parameters:
    ///   - urlStr: url
    ///   - method: 请求方法
    ///   - params: 请求参数（根据key来拼接（后续可能回接入用户名与token））
    ///   - data: 照片数据
    ///   - name: 需要与后台协商成统一字段
    ///   - fileNameArray: 文件名称，看后台有没有要求
    ///   - headers: header 可以没有
    ///   - mimeType: mimeType
    ///   - success: 成功
    ///   - failture: 失败 -- 如果没有数据，相当于失败。
    func uploadImage(_ urlStr : String,_ method: HTTPMethod, _ params:[String:String],_ images: [UIImage],_ names:String,_ fileNames:[String], _ headers: [String:String]?,_ compressionQuality: CGFloat? = 0.1 , _ mimeType: String ,success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
        self.uploadImageFunc(urlStr, method, params, images, names, fileNames, headers, compressionQuality, mimeType, success: success, failture: failture)
    }
```

图片：
![请求错误](http://upload-images.jianshu.io/upload_images/4185621-7143adcb0fef9eb3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![请求成功](http://upload-images.jianshu.io/upload_images/4185621-7ffe057fbdf97cbb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#测试必备搭配组件
>1. 在开发中，经常要切换环境，来测试各个环境下的代码。
>2. 总是改baseURL，然后运行，那不爽爆？**写swift的小伙伴都懂**
>3. 写一个后门儿，只有在release下才会显示出来，并且可以选择相应的url。
>4. 提供输入账号密码输入textField，点击登录自动切换账号。

[可以在debug模式下，可以选择测试url](https://www.jianshu.com/p/051eb0666862)
[demo点这里](https://github.com/LiPengYue/AlamofireMenager)

