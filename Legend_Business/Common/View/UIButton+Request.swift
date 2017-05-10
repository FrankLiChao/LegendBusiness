//
//  UIButton+Request.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/23.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

extension UIButton {
    
    func enable(_ enable : Bool){
    
        if enable {
        
            self.backgroundColor = Configure.SYS_UI_COLOR_BG_RED()
            self.isEnabled = true
        }
        else {
        
            self.backgroundColor = Configure.SYS_UI_COLOR_LINE_COLOR()
            self.isEnabled = false
        }
    }
    
    /**
     图片在上，文字在下
     */
    func setUpImageDownTitle(_ image: UIImage, title: String){
    
        self.backgroundColor = UIColor.clear

        self.setImage(image, for: UIControlState())
        self.setTitle(title, for: UIControlState())

        let str = title as NSString
        var titleSize = str.size(with: self.titleLabel?.font, byHeight: 20)
        if titleSize.width > self.frame.size.width { titleSize.width = self.frame.size.width}
        
        
        self.imageEdgeInsets = UIEdgeInsetsMake(-15,0,0,-titleSize.width)//设置image在button上的位置
        self.titleEdgeInsets = UIEdgeInsetsMake(image.size.height + 10, -image.size.width, 0, 0);//设置title在button上的位置
        
    }
}