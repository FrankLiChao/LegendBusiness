//
//  ForgetPasswordViewController.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/16.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

enum SetPasswordType {
    
    case setNew
    case findOld
}

class SetPasswordViewController: BaseViewController {
    
    
    
    
    @IBOutlet var firstPasswordField    : UITextField?
    @IBOutlet var confirmPasswordField  : UITextField?
    @IBOutlet var saveButton            : UIButton?
    @IBOutlet var saveButtonHeight : NSLayoutConstraint?
    
    var smsToken : String!
    var phoneNum : String!
    var currentType : SetPasswordType?
    
    deinit {
        print("SetPasswordViewController 释放")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置密码"
        self.navigationItem.hidesBackButton = true
        
        UitlCommon.setFlat(view: saveButton!, radius: Configure.SYS_CORNERRADIUS())
        UitlCommon.setFlat(view: confirmPasswordField!, radius: Configure.SYS_CORNERRADIUS())
        UitlCommon.setFlat(view: firstPasswordField!, radius: Configure.SYS_CORNERRADIUS())
        
        firstPasswordField?.font = UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(14))
        confirmPasswordField?.font = UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(14))
        
        let leftView : UIView = UIView(frame: CGRect(x: 0,y: 0,width: 15,height: 44))
        leftView.backgroundColor = UIColor.clear
        
        let leftView1 : UIView = UIView(frame: CGRect(x: 0,y: 0,width: 15,height: 44))
        leftView1.backgroundColor = UIColor.clear
        
        firstPasswordField!.leftView = leftView
        firstPasswordField!.leftViewMode = .always;
        
        
        confirmPasswordField!.leftView = leftView1
        confirmPasswordField!.leftViewMode = .always;
        
        
        saveButtonHeight?.constant  = Configure.SYS_UI_BUTTON_HEIGHT()
        saveButton?.titleLabel?.font = Configure.SYS_UI_BUTTON_FONT()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func savePassword(_ button : UIButton?){
        
        UitlCommon.closeAllKeybord()
        
        if UitlCommon.isNull(firstPasswordField!.text!){
            
            self.showHint("请输入新密码")
            return
        }
        if UitlCommon.isNull(confirmPasswordField!.text!){
            
            self.showHint("请再次输入新密码")
            return
        }
        
        if firstPasswordField!.text != confirmPasswordField!.text{
            
            self.showHint("两次输入密码不一致")
            return
        }
        
        
        self.showHud(in: self.view, hint: "设置中...")
        
        if currentType == .setNew || currentType == nil {
        
            self.setRegisterPWD(smsToken, passowd: firstPasswordField!.text!) { (bSuccess, errorDes) -> Void in
                self.hideHud()
                if bSuccess {
                    
                    SaveEngine.saveMyLoginAccount(self.phoneNum)
                    SaveEngine.saveLoginPassword(self.firstPasswordField!.text!)
                
                    let vc1  =  StoreProfileEditViewController(nibName: "StoreProfileEditViewController", bundle: nil)
                    self.navigationController?.pushViewController(vc1, animated: true)
                    
                }
                else {
                    
                    self.showHint(errorDes)
                }
            };
        }
        else if currentType == .findOld {
        
            self.findPassword(phoneNum!, pwd: confirmPasswordField?.text, smsToke: smsToken, comple: { (bSuccess, message) -> Void in
                 self.hideHud()
                if bSuccess {
                    self.showHint("设置成功");
                    let _ = self.navigationController?.popToRootViewController(animated: true)
                }
                
                else{
                    self.showHint(message);
                }
            })
        
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        if textField == firstPasswordField {
            
            if UitlCommon.isNull(confirmPasswordField!.text!){
                confirmPasswordField?.becomeFirstResponder()
            }
            else{
                textField.resignFirstResponder()
            }
        }
        else if textField == confirmPasswordField {
            
            savePassword(nil)
        }
        
        
        return true
    }
    
}
