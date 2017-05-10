//
//  BankListCell.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/23.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

@objc protocol BankListCellDelegate : NSObjectProtocol {
    
    @objc optional func deleteBankCard(_ index: IndexPath?)
}



class BankListCell: UITableViewCell {

    @IBOutlet var contentBackView : UIView?
    @IBOutlet var iconImageView : UIImageView?
    @IBOutlet var bankNameLabel : UILabel?
    @IBOutlet var cardDetailLabel : UILabel?
    @IBOutlet var deleteButton : UIButton?
    @IBOutlet var iconWidth : NSLayoutConstraint?
    
    
    weak var delegate:BankListCellDelegate?
    
    var index : IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UitlCommon.setFlat(view: iconImageView!, radius: iconWidth!.constant/2)
        UitlCommon.setFlat(view: contentBackView!, radius: Configure.SYS_CORNERRADIUS(), borderColor: Configure.SYS_UI_COLOR_LINE_COLOR(), borderWidth: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickDelete(){
    
        if delegate != nil && delegate!.responds(to: #selector(BankListCellDelegate.deleteBankCard(_:))) {

            delegate?.deleteBankCard!(index)
        }
    }
    

}
