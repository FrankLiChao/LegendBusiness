//
//  InsetsLabel.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/17.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class InsetsLabel: UILabel {

  
    var insets :UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    convenience init(frame: CGRect, insets:UIEdgeInsets){
     
        self.init(frame:frame)
        self.insets = insets
    }
    
    override func drawText(in rect: CGRect) {
//        super.drawText(in: UIEdgeInsetsInsetRect(rect, self.insets))
        super.drawText(in: rect.inset(by: self.insets))
    }
}
