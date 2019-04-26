//
//  Configure.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/16.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit



class Configure: NSObject {
    
   
    @objc class func SYS_UI_BASE_WIDTH() -> CGFloat{return  320.0}
    @objc class func SYS_UI_BASE_HEIGHT() -> CGFloat{return 580.0}
    
    @objc class func SYS_UI_WINSIZE_WIDTH() ->CGFloat{ return UIScreen.main.bounds.size.width}
    @objc class func SYS_UI_WINSIZE_HEIGHT() ->CGFloat{ return UIScreen.main.bounds.size.height}

    /**
     size缩放比例
     
     - parameter value: 参考值
     
     - returns: 显示值
     */
   @objc class func SYS_UI_SCALE(_ value: CGFloat)-> CGFloat{
        var sacle  = SYS_UI_WINSIZE_WIDTH() / SYS_UI_BASE_WIDTH()
        if sacle>1.05{
            sacle = 1.05
        }
        else if sacle < 0.95 {
            sacle = 0.95
        }
        
        let result = CGFloat(value) * sacle
        
        return result
    }
    
    /**
     字体缩放比例
     
     - parameter value: 参考值
     
     - returns: 显示值
     */
    @objc class func SYS_FONT_SCALE(_ value: CGFloat)-> CGFloat{
        
        var sacle  = SYS_UI_WINSIZE_WIDTH() / SYS_UI_BASE_WIDTH()
        if sacle>1{
            sacle = 1
        }
        else if sacle < 1 {
            sacle = -1
        }
        else {
            sacle = 0
        }
        
        let result = CGFloat(value) + sacle
        
        return result
    }
    
    //红色
    @objc class func SYS_UI_COLOR_BG_RED() -> UIColor{ return UitlCommon.UIColorFromRGB(0xEF3441)}
    
    
    /// 背景色
    @objc class func SYS_UI_COLOR_BG_COLOR() -> UIColor{ return UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)}
    
    
    /// 分割线颜色
    @objc class func SYS_UI_COLOR_LINE_COLOR() -> UIColor{ return UitlCommon.UIColorFromRGB(0xF1F1F1)}
    
    
    /// 黑色字体颜色
    @objc class func SYS_UI_COLOR_TEXT_BLACK() -> UIColor{ return UIColor(red: 69.0/255, green: 69/255.0, blue: 69/255.0, alpha: 1.0)}
    
    /// 灰色字体颜色
    @objc class func SYS_UI_COLOR_TEXT_GRAY() -> UIColor{ return UIColor(red: 153.0/255, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)}
    
    // PlaceHolder字体
    @objc class func SYS_UI_COLOR_PLACEHOLDER() -> UIColor{ return Configure.SYS_UI_COLOR_TEXT_GRAY().withAlphaComponent(0.5) }
        
    /// 左右离屏幕间距
    @objc class func SYS_UI_LEADING_OFFSET() -> CGFloat{ return 10.0}
    
    /// button 高度
    @objc class func SYS_UI_BUTTON_HEIGHT() -> CGFloat{ return SYS_UI_SCALE(44)}
    
    
    ///  button 字体
    @objc class func SYS_UI_BUTTON_FONT() -> UIFont{ return UIFont.systemFont(ofSize: SYS_FONT_SCALE(16))}
    
    @objc class func SYS_CORNERRADIUS() -> CGFloat{ return 2.0 }
    
}
