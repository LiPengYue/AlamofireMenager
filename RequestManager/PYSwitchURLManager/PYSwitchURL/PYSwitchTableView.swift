//
//  PYSwitchTableView.swift
//  PYSwitchURLManager
//
//  Created by 李鹏跃 on 2018/1/10.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

import UIKit

class PYSwitchTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
    var modelArray = [PYSwitchURLModel]() {
        didSet {
            if self.contentSize.height >= self.frame.size.height - 400{
                self.contentInset = UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, 400, self.contentInset.right)
            }
            reloadData()
        }
    }
    ///headerView的懒加载
    private lazy var headerLabel: PYSwitchTableHeaderView = {
        let label = PYSwitchTableHeaderView(frame: CGRect.init(x: 0, y: 0, width: W_, height: 90))
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private var clickCellCallBack: ((_ model: PYSwitchURLModel)->())?
    func clickCellFunc(_ clickCellCallBack: ((_ model: PYSwitchURLModel)->())?){
        self.clickCellCallBack = clickCellCallBack
    }
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        delegate = self
        dataSource = self
        self.rowHeight = 175
        self.backgroundColor = #colorLiteral(red: 0.8116591737, green: 0.9562148644, blue: 0.9076814761, alpha: 1)
        self.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        register(PYSwitchTableViewCell.classForCoder(), forCellReuseIdentifier: "reuseIdentifier")
        self.tableHeaderView = headerLabel
    }
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? PYSwitchTableViewCell
        cell?.selectionStyle = .none
        cell?.model = modelArray[indexPath.row]
        cell?.clickCellFunc({[weak self] (model) in
            self?.headerLabel.text = "当前环境:\n" + (model.URLStr ?? "")
            self?.clickCellCallBack?(model)
        })
        return cell ?? UITableViewCell()
    }
}

class PYSwitchTableHeaderView: UILabel{
    
}

