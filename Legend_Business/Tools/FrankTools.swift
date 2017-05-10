//
//  FrankTools.swift
//  legend_business_ios
//
//  Created by Frank on 2016/11/27.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class FrankTools: NSObject {
    class func showMessage(_ msg:String) -> Void {
        let view:UIView = (UIApplication.shared.delegate?.window!)!
        let hub:MBProgressHUD = MBProgressHUD.showAdded(to: view,animated: true)
        hub.isUserInteractionEnabled = false
        hub.mode = MBProgressHUDMode(rawValue: 5)!
        hub.labelText = msg
        hub.margin = 10
        hub.yOffset = 180
        hub.removeFromSuperViewOnHide = true;
        hub.hide(true,afterDelay: 2)
    }
    
    class func iphone5() -> Bool {
        let isTrue = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 640, height: 1136), (UIScreen.main.currentMode?.size)!):false
        return isTrue
    }
    
    class func iphone6() -> Bool {
        let isTrue = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 750, height: 1334), (UIScreen.main.currentMode?.size)!):false
        return isTrue
    }
    
    class func iphone6plus() -> Bool {
        let isTrue = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? (__CGSizeEqualToSize(CGSize(width: 1125, height: 2001), (UIScreen.main.currentMode?.size)!) || __CGSizeEqualToSize(CGSize(width: 1242, height: 2208), (UIScreen.main.currentMode?.size)!)) : false
        return isTrue
    }
}
