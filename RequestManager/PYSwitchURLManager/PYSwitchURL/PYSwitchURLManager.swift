//
//  PYSwitchURLManager.swift
//  PYSwitchURLManager
//
//  Created by 李鹏跃 on 2018/1/9.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

///添加到window上一个按钮，并且只有debug模式下才会生效，隐藏请修改
import UIKit
///处理重新登录的类
var switchURLManager_Delegate: PYSwitchURLDelegate.Type = PYSwitchURLDelegate.self
///url的string集合
var switchURLManager_URLArray = [String]() {
    didSet {
        #if DEBUG
            for url in switchURLManager_URLArray {
                let model = PYSwitchURLModel.init()
                model.URLStr = url
                switchURLManager_ModelArray.append(model)
            }
            PYSwitchURLManager.showButton()
        #endif
    }
}

let W_ = UIScreen.main.bounds.width
let H_ = UIScreen.main.bounds.height
private let buttonTagValue = 1008888
private let tableViewTagValue = 100222
private let backButtonTagValue = 2123432
private var switchURLManager_ModelArray = [PYSwitchURLModel]()
private var currentModel: PYSwitchURLModel?

private class PYSwitchURLManager: NSObject {
    #if DEBUG
    static let sheard = PYSwitchURLManager()
    private var clickCellCallBack: ((_ model: PYSwitchURLModel)->())?

    func clickCellFunc(_ clickCellCallBack: ((_ model: PYSwitchURLModel)->())?){
        self.clickCellCallBack = clickCellCallBack
    }
    class func showButton() {

        let window = UIApplication.shared.keyWindow
        if window == nil {
            DispatchQueue.global().asyncAfter(deadline:.now()+2, execute: {
                DispatchQueue.main.async {
                    showButton()
                }
            })
            return
        }
        if getButton() == nil {
            windowAddButton()
        }
        if getBackButton() == nil {
            addWindowCallBackButton()
        }
    }
    private class func getButton() -> UIButton? {
        return getWindow()?.viewWithTag(buttonTagValue) as? UIButton
    }
    private class func getTableView() -> PYSwitchTableView? {
        return getWindow()?.viewWithTag(tableViewTagValue) as? PYSwitchTableView
    }
    
    ///获取keyWindow
    private class func getWindow()-> UIWindow? {
        let window = UIApplication.shared.keyWindow
        return window
    }
    ///keyWindow 添加按钮
    private class func windowAddButton () {
        let window = PYSwitchURLManager.getWindow()
        let button = UIButton.init(frame: CGRect.init(x: 100, y: 100, width: 64, height: 64))
        
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 32
        button.layer.masksToBounds = true
        button.layer.borderColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        button.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        button.setTitle("URL", for: .normal)
        button.tag = buttonTagValue
        
        ///拖拽中
        let pan: UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: PYSwitchURLManager.sheard, action: #selector(dragMoving))
        button.addGestureRecognizer(pan)
        /// 点击方法
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: PYSwitchURLManager.sheard, action: #selector(click))
        button.addGestureRecognizer(tap)
        
        window?.addSubview(button)
    }
    
    @objc private func click() {
        
        if PYSwitchURLManager.getTableView() == nil{
            PYSwitchURLManager.createTableView()
        }
        
        let view = PYSwitchURLManager.getTableView()
        
        for model in switchURLManager_ModelArray {
            let passowrd = model.password != nil ? model.password : currentModel?.password
            model.password = passowrd
            
            let userName = model.userName != nil ? model.userName : currentModel?.userName
            model.userName = userName
        }
        
        view?.modelArray = switchURLManager_ModelArray
        view?.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            PYSwitchURLManager.getBackButton()?.alpha = 1
            view?.alpha = 1
            view?.frame = CGRect.init(x: 0, y: 0, width: W_, height: H_)
        })
    }
    @objc private func dragMoving(_ pan: UIPanGestureRecognizer) {
        
        let centerChangeValue: CGPoint = pan.translation(in: PYSwitchURLManager.getWindow())
        pan.setTranslation(CGPoint.zero, in: PYSwitchURLManager.getWindow())
        
        let x_change = (pan.view?.center.x)! + centerChangeValue.x
        let y_change = (pan.view?.center.y)! + centerChangeValue.y
        
        let center = CGPoint.init(x: x_change, y: y_change)
        
        let y_ = center.y <= 0 ? 0 : center.y
        let x_ = center.x <= 0 ? 0 : center.x
        let y = y_ >= H_ ? H_ : y_
        let x = x_ >= W_ ? W_ : x_
        pan.view?.center = CGPoint.init(x: x, y: y)
    }
    
    class func createTableView() {
        let switchTableView = PYSwitchTableView(frame: CGRect.zero, style: .plain)
        switchTableView.tag = tableViewTagValue
        switchTableView.clickCellFunc {[weak switchTableView] (model) in
            getTableView()?.endEditing(true)
            UIView.animate(withDuration: 0.4, animations: {
                switchTableView?.alpha = 0
                getBackButton()?.alpha = 0
                switchTableView?.frame = CGRect.init(x: 0, y: 0, width: W_, height: 0)
            })
            
            if model.URLStr?.count == 0 && model.URLStr == nil {
                switchURLManager_Delegate.error_NotURLStr(currentModel: currentModel ?? PYSwitchURLModel())
            }else{
                switchURLManager_Delegate.ssucceed(model: model)
            }
            currentModel = model
            
            PYSwitchURLManager.sheard.clickCellCallBack?(model)
        }
        PYSwitchURLManager.getWindow()?.insertSubview(switchTableView, belowSubview: getBackButton()!)
    }
    private class func getBackButton() -> UIButton? {
        return getWindow()?.viewWithTag(backButtonTagValue) as? UIButton
    }
    private class func addWindowCallBackButton() {
        let button = UIButton.init(frame: CGRect.init(x: 20, y: 40, width: 60, height: 40))
        button.tag = backButtonTagValue 
        button.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        button.setTitle("返回", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.alpha = 0
        button.addTarget(sheard, action: #selector(clickBackButton), for: .touchUpInside)
        getWindow()?.addSubview(button)
    }
    @objc private func clickBackButton() {
         let switchTableView = PYSwitchURLManager.getTableView()
        switchTableView?.endEditing(true)
        UIView.animate(withDuration: 0.4, animations: {
            switchTableView?.alpha = 0
            PYSwitchURLManager.getBackButton()?.alpha = 0
            switchTableView?.frame = CGRect.init(x: 0, y: 0, width: W_, height: 0)
        })
    }
    #endif
}

