//
//  PopView.swift
//  legend_business_ios
//
//  Created by Frank on 2016/11/28.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class PopView: UIView {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var alterView: UIView!
    @IBOutlet weak var sureBtn: UIButton!
 
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        self.alterView.layer.cornerRadius = 6
        self.alterView.layer.masksToBounds = true
        self.alterView.backgroundColor = .white
        
        self.sureBtn.addTarget(self, action: #selector(self.dissMissPopView), for: .touchUpInside)
        
        //动画效果
//        self.bgView.alpha = 0
//        self.alterView.alpha = 0
//        alterView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//        UIView.animate(withDuration: 0.25, animations:{
//            self.bgView.alpha = 1
//            self.alterView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//            self.alterView.alpha = 1
//        })
    }
    
    @objc func dissMissPopView() -> Void {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
            self.alterView.alpha = 0
        }, completion: {(finish : Bool) in
            self.alterView.removeFromSuperview()
            self.removeFromSuperview()
        })
    }
}


