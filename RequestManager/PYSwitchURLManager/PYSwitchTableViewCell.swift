//
//  PYSwitchTableViewCell.swift
//  PYSwitchURLManager
//
//  Created by 李鹏跃 on 2018/1/10.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

import UIKit

class PYSwitchTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: PYSwitchURLModel? {
        didSet {
            if let userName = model?.userName {
                userTextField.text = userName
            }
            if let password = model?.password {
                passwordTextField.text = password
            }
            urlLabel.text = model?.URLStr
        }
    }
    private var clickCellCallBack: ((_ model: PYSwitchURLModel)->())?
    func clickCellFunc(_ clickCellCallBack: ((_ URL: PYSwitchURLModel)->())?){
        self.clickCellCallBack = clickCellCallBack
    }
    ///URL的懒加载
    private lazy var urlLabel: UILabel = {
        let label = UILabel(frame: CGRect.init(x: 20, y: 0, width: W_ - 40, height: 30))
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    ///userName TextField
    private lazy var userTextField: UITextField = {
        let textField = UITextField(frame: CGRect.init(x: 20, y: 40, width: W_ - 40, height: 30))
        textField.backgroundColor = UIColor.white
        textField.placeholder = "输入userName"
        return textField
    }()
    ///password TextField
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField(frame: CGRect.init(x: 20, y: 80, width: W_ - 40, height: 30))
        textField.placeholder = "输入password"
        textField.backgroundColor = UIColor.white
        return textField
    }()
    
    /// confirm 的懒加载
    private lazy var  confirmButton:UIButton = {
        let button = UIButton()
        button.setTitle("登陆", for: .normal)
        button.addTarget(self, action: #selector(clickConfirm), for: .touchUpInside)
        button.frame = CGRect.init(x: 20, y: 120, width: W_ - 40, height: 45)
        return button
    }()
    @objc private func clickConfirm() {
        model?.userName = userTextField.text
        model?.password = passwordTextField.text
        clickCellCallBack?(model ?? PYSwitchURLModel())
    }
    private func setup() {
        self.backgroundColor = #colorLiteral(red: 0.8116591737, green: 0.9562148644, blue: 0.9076814761, alpha: 1)
        urlLabel.backgroundColor = UIColor.white
        userTextField.backgroundColor = UIColor.white
        passwordTextField.backgroundColor = UIColor.white
        confirmButton.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        
        self.contentView.addSubview(urlLabel)
        self.contentView.addSubview(userTextField)
        self.contentView.addSubview(passwordTextField)
        self.contentView.addSubview(confirmButton)
    }
}



