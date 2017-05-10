//
//  GoodsAttrTableViewCell.swift
//  legend_business_ios
//
//  Created by Tsz on 2016/11/24.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class GoodsAttrTableViewCell: UITableViewCell {
    
    @IBOutlet weak var attrNameTextField: UITextField!
    @IBOutlet weak var attrPriceTextField: UITextField!
    @IBOutlet weak var stockTextField: UITextField!
    @IBOutlet weak var stockWarningTextField: UITextField!
    @IBOutlet weak var directAwardTextField: UITextField!
    @IBOutlet weak var relativeAwardTextField: UITextField!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var notEnoughStockLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .white
        
        let attr = [NSForegroundColorAttributeName: Configure.SYS_UI_COLOR_PLACEHOLDER()]
        self.attrNameTextField.attributedPlaceholder = NSAttributedString(string: "请输入规格", attributes: attr)
        self.attrPriceTextField.attributedPlaceholder = NSAttributedString(string: "请输入价格", attributes: attr)
        self.stockTextField.attributedPlaceholder = NSAttributedString(string: "请输入库存量", attributes: attr)
        self.stockWarningTextField.attributedPlaceholder = NSAttributedString(string: "预警数量", attributes: attr)
        self.directAwardTextField.attributedPlaceholder = NSAttributedString(string: "请输入金额", attributes: attr)
        self.relativeAwardTextField.attributedPlaceholder = NSAttributedString(string: "请输入金额", attributes: attr)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame.size.height = self.bounds.height - 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
