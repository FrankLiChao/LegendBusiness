//
//  ModefyLoginPassowedController.swift
//  legend_business_ios
//
//  Created by msb-ios-dev on 16/2/21.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class ModefyLoginPassowedController: BaseViewController {


    @IBOutlet var oldPwdField : UITextField?
    @IBOutlet var newPwdField : UITextField?
    @IBOutlet var confirmPwdField : UITextField?
    @IBOutlet var saveButton : UIButton?
    @IBOutlet var saveButtonHeight : NSLayoutConstraint?

    @IBOutlet var textFiledHeight : NSLayoutConstraint?
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改登录密码"
        self.setBackButton()
        
        textFiledHeight?.constant = Configure.SYS_UI_SCALE(44)
        
        saveButtonHeight?.constant = Configure.SYS_UI_BUTTON_HEIGHT()
        saveButton?.titleLabel?.font = Configure.SYS_UI_BUTTON_FONT()
        
        UitlCommon.setFlat(view: saveButton!, radius: Configure.SYS_CORNERRADIUS())
        UitlCommon.setFlat(view: oldPwdField!, radius: Configure.SYS_CORNERRADIUS())
        UitlCommon.setFlat(view: newPwdField!, radius: Configure.SYS_CORNERRADIUS())
        UitlCommon.setFlat(view: confirmPwdField!, radius: Configure.SYS_CORNERRADIUS())
        
        oldPwdField?.font = UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(14))
        confirmPwdField?.font = UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(14))
        newPwdField?.font = UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(14))
        
        let leftV1 = UIView(frame: CGRect(x: 0,y: 0,width: 15,height: 10))
        leftV1.backgroundColor = UIColor.white
        oldPwdField?.leftView = leftV1
        oldPwdField?.leftViewMode = .always
        
        let leftV2 = UIView(frame: CGRect(x: 0,y: 0,width: 15,height: 10))
        leftV2.backgroundColor = UIColor.white
        newPwdField?.leftView = leftV2
        newPwdField?.leftViewMode = .always
        
        let leftV3 = UIView(frame: CGRect(x: 0,y: 0,width: 15,height: 10))
        leftV3.backgroundColor = UIColor.white
        confirmPwdField?.leftView = leftV3
        confirmPwdField?.leftViewMode = .always
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func clickSave(){
    
        if UitlCommon.isNull(oldPwdField!.text!) {
            self.showHint("请输入旧密码")
            return
        }
        if UitlCommon.isNull(newPwdField!.text!) {
            
             self.showHint("请输入新密码")
            return
        }
        if UitlCommon.isNull(confirmPwdField!.text!) {
            
            self.showHint("请再次输入新密码")
            return
        }
        
        if confirmPwdField!.text! !=  newPwdField!.text!{
            
            self.showHint("两次密码输入不一致，请重新输入")
            return
        }
        
        weak var weakSekf = self
        
        self.showHud(in: self.view, hint: "设置中")
        
        self.modifyPassword(newPwdField!.text!, oldPassword: oldPwdField!.text!, smsToken: nil, type: 1, comple: {(bSuccess, message) -> Void in
            
            weakSekf?.hideHud()
            
            if bSuccess {
                weakSekf?.showHint("修改成功")
                let vc = self.navigationController?.viewControllers[1]
                let _ = weakSekf?.navigationController?.popToViewController(vc!, animated: true);
            }
            else{
            
             weakSekf?.showHint(message)
            }
            
        })
        

        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
