//
//  KRSessionDelegate.swift
//  KReadingStuHD
//
//  Created by 李鹏跃 on 2017/12/22.
//  Copyright © 2017年 Koalareading. All rights reserved.
//

import UIKit
import Alamofire
class AlamofireSessionDelegate: SessionDelegate {
    override func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        
    }
    override func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
       
        sessionDidFinishEventsForBackgroundURLSession?(session)
    }
}
