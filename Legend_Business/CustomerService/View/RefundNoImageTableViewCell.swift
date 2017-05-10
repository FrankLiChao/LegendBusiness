//
//  RefundNoImageTableViewCell.swift
//  legend_business_ios
//
//  Created by Frank on 2016/11/24.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class RefundNoImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dataLab: UILabel!
    @IBOutlet weak var headIm: UIImageView!//头像
    @IBOutlet weak var nameLab: UILabel!//商家姓名
    @IBOutlet weak var bgViewIm: UIImageView!//背景图片
    @IBOutlet weak var titleLab: UILabel!//标题
    @IBOutlet weak var moneyLab: UILabel!//退款金额
    @IBOutlet weak var countDownBtn: UIButton!//倒计时

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
