//
//  GoodsListHeaderView.swift
//  legend_business_ios
//
//  Created by Tsz on 2016/11/24.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class GoodsListHeaderView: UITableViewHeaderFooterView {

    fileprivate lazy var bgImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "others_bg")
        return img
    }()
    fileprivate lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "其他全部产品"
        return label
    }()
    
    @objc var isWarning: Bool = false {
        didSet {
            titleLabel.text = isWarning ? "库存预警产品" : "其他全部产品"
            bgImg.image = UIImage(named: isWarning ? "warning_bg" : "others_bg")
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        self.contentView.backgroundColor = .white
        self.addSubview(bgImg)
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .white
        self.contentView.backgroundColor = .white
        self.addSubview(bgImg)
        self.addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgImg.frame = CGRect(x: 0, y: 5, width: 110, height: 25)
        titleLabel.frame = CGRect(x: 10, y: 5, width: bgImg.frame.width - 10 - 10, height: bgImg.frame.height)
    }

}
