//
//  DealingListCell.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/22.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class DealingListCell: UITableViewCell {

    @IBOutlet var dataLabel : UILabel?
    @IBOutlet var headImageView : UIImageView?
    @IBOutlet var priceLabel : UILabel?
    @IBOutlet var infoLabel : UILabel?
    @IBOutlet var statusLabel : UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UitlCommon.setFlat(view: headImageView!, radius: 21)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
