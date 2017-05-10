//
//  AfterSaleTableViewCell.swift
//  legend_business_ios
//
//  Created by Frank on 2016/11/24.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class AfterSaleTableViewCell: UITableViewCell {

    @IBOutlet weak var nameBtn: UIButton!//表示买家名字和头像
    @IBOutlet weak var logoIm: UIImageView! //商品图片
    @IBOutlet weak var nameLab: UILabel!//商品名称
    @IBOutlet weak var attrLab: UILabel!//商品属性
    @IBOutlet weak var priceLab: UILabel!//商品价格
    @IBOutlet weak var timerBtn: UIButton!//倒计时
    @IBOutlet weak var statusLab: UILabel!//发货状态
    @IBOutlet weak var cometeStatus: UIButton!//完成状态
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
