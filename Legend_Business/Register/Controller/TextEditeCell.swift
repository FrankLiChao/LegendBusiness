//
//  TextEditeCell.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/17.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

@objc protocol TextEditeCellDelegate : NSObjectProtocol{

    @objc optional func companyNameChange(_ name:String?)
    //optional func companyTypeChange(name:String?)
    @objc optional func companyPhoneChange(_ name:String?)
    @objc optional func companyCatogeryClick()
    
}


class TextEditeCell: UITableViewCell {

    @IBOutlet var backView : UIView?
    @IBOutlet var companyNameField : UITextField?
    @IBOutlet var companyTypeField : UITextField?
    @IBOutlet var companyPhoneField : UITextField?
    
    weak var delegate : TextEditeCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        UitlCommon.setFlat(view: backView!, radius: Configure.SYS_CORNERRADIUS())
        companyNameField?.addTarget(self, action: #selector(TextEditeCell.companyNameChanged(_:)), for: .allEditingEvents)
     //   companyTypeField?.addTarget(self, action: Selector("companyTypeChanged:"), forControlEvents: .AllEditingEvents)
        companyPhoneField?.addTarget(self, action: #selector(TextEditeCell.companyPhoneChanged(_:)), for: .allEditingEvents)
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        textField.resignFirstResponder()
        return true
    }
    
    func companyNameChanged(_ textFile: UITextField) {
    
        if delegate != nil && delegate!.responds(to: #selector(TextEditeCellDelegate.companyNameChange(_:))) {
            delegate!.companyNameChange!(textFile.text)
        }
    }
    
//    func companyTypeChanged(textFile: UITextField){
//        
//        if delegate != nil && delegate!.respondsToSelector(Selector("companyTypeChange:")) {
//            delegate!.companyTypeChange!(textFile.text!)
//        }
//        
//    }
    func companyPhoneChanged(_ textFile: UITextField){
        
        if delegate != nil && delegate!.responds(to: #selector(TextEditeCellDelegate.companyPhoneChange(_:))) {
            delegate!.companyPhoneChange!(textFile.text)
        }
    }
    
    
    @IBAction func clickSelectCompanyCatorgery(_ button : UIButton){
    
        if delegate != nil && delegate!.responds(to: #selector(TextEditeCellDelegate.companyCatogeryClick)) {
            delegate!.companyCatogeryClick!()
        }

    }
    
}
