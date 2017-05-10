//
//  SettingView.swift
//  legend_business_ios
//
//  Created by Frank on 2016/11/28.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

protocol SettingDelegate {
    func setWeekBonusValue(type:Int, value:String)
}

class SettingView: UIView {

    @IBOutlet weak var alterView: UIView!
    @IBOutlet weak var titleLab: UILabel!//标题
    @IBOutlet weak var setTextTx: UITextField!
    @IBOutlet weak var unitLab: UILabel!//单位
    @IBOutlet weak var tipLab: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var sureBtn: UIButton!
    var delegate: SettingDelegate?
    
    var type:Int? {
        didSet {
            if self.type == 1 {
                self.titleLab.text = "请输入您想设置的分红金额"
                self.unitLab.text = "元"
                self.tipLab.text = "注：分红金额不可少于1元"
            }
        }
    }//0表示代言周期 1表示分红周期
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cancelBtn.layer.borderWidth = 0.5
        self.cancelBtn.layer.borderColor = UIColor.mainColor().cgColor
        self.cancelBtn.addTarget(self, action: #selector(self.clickCancelBtn), for: .touchUpInside)
        
        self.sureBtn.layer.borderWidth = 0.5
        self.sureBtn.layer.borderColor = UIColor.mainColor().cgColor
        self.sureBtn.addTarget(self, action: #selector(self.clickSureButton), for: .touchUpInside)
        
        self.alterView.layer.cornerRadius = 6
        self.alterView.layer.masksToBounds = true
    }
    
    func clickCancelBtn() {
        self.endEditing(true)
        self.alterView.removeFromSuperview()
        self.removeFromSuperview()
    }
    
    func clickSureButton() {
        self.endEditing(true)
        if self.setTextTx.text?.isEmpty == false {
            self.delegate?.setWeekBonusValue(type: self.type!, value:self.setTextTx.text!)
            self .clickCancelBtn()
        }else {
            var str:String = "请输入天数"
            if self.type == 1 {
                str = "请输入分红周期"
            }
            FrankTools.showMessage(str)
        }
    }
}
