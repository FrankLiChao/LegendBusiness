//
//  InsetsLabel.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/17.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class InsetsLabel: UILabel {

  
    var insets :UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
    
    convenience init(frame: CGRect, insets:UIEdgeInsets){
     
        self.init(frame:frame)
        self.insets = insets
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, self.insets))
    }
}
