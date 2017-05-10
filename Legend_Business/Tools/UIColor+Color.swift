//
//  UIColor+Color.swift
//  legend_business_ios
//
//  Created by Frank on 2016/11/26.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

extension UIColor{
    class func colorFromHexRGBValue(_ hex: NSInteger) -> UIColor {
        return UitlCommon.UIColorFromRGB(hex)
    }
    
    class func mainColor() -> UIColor {
        return UIColor.colorFromHexRGBValue(0xE3383E)
    }
}
