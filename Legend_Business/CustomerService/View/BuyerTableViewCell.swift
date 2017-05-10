//
//  BuyerTableViewCell.swift
//  legend_business_ios
//
//  Created by Frank on 2016/11/24.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class BuyerTableViewCell: UITableViewCell {
    @IBOutlet weak var dataLab: UILabel!
    @IBOutlet weak var headIm: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var resonLab: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
