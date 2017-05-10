//
//  ShopsHeadTableViewCell.swift
//  legend_business_ios
//
//  Created by Frank on 2016/11/24.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class ShopsHeadTableViewCell: UITableViewCell {
    @IBOutlet weak var logoIm: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var attrLab: UILabel!
    @IBOutlet weak var moneyLab: UILabel!
    @IBOutlet weak var statusLab: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
