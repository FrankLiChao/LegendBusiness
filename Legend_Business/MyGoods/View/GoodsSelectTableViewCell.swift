//
//  GoodsSelectTableViewCell.swift
//  legend_business_ios
//
//  Created by Tsz on 2016/11/24.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class GoodsSelectTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    weak var line: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let line = UIImageView()
        self.line = line
        self.line.backgroundColor = Configure.SYS_UI_COLOR_LINE_COLOR()
        self.addSubview(self.line)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.line.frame = CGRect(x: 15, y: self.contentView.frame.maxY, width: self.bounds.width - 30, height: 0.5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
