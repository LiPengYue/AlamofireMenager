//
//  ViewController.swift
//  RequestMenager
//
//  Created by 李鹏跃 on 2017/12/21.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchURLManager_URLArray = ["api","demo","server"]
        
        let alamofireMenager = AlamofireMenager.init()
        let parameters = ["appkey":"11474086",
                          "limit":"24",
                          "city":"北京",
                          "page":"1",
                          "sign":"93AD7448260235FCB3F691EF4CE8B2B12E6C0472"]
        
        alamofireMenager.loadData(Path: "v1/deal/find_deals", HTTPMethod: .get, parameters, .query, Success: { (banner: DataModel,netData)  in

        }) { (str) in

        }

        alamofireMenager.loadData(Path: "", HTTPMethod: .get, nil, .query, Success: { (banner: Any) in

        }) { (_) in

        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = PYViewController()
        self.present(vc, animated: true) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

