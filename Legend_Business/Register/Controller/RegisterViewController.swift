//
//  RegisterViewController.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/16.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class RegisterViewController: BaseViewController {
    
    @IBOutlet var phoneNumField             : UITextField?
    @IBOutlet var recommedField             : UITextField?
    @IBOutlet var verificationField         : UITextField?
    @IBOutlet var verifiButton              : UIButton?
    @IBOutlet var registerButton            : UIButton?
    @IBOutlet var loginButton               : UIButton?
    @IBOutlet var userAgreementReadButton   : UIButton?
    @IBOutlet var userAgreementButton       : UIButton?
    @IBOutlet var userAgreementLabel        : UILabel?
    
    @IBOutlet var loginButtonHeight : NSLayoutConstraint?
    @IBOutlet var regeisterHeight : NSLayoutConstraint?
    
    
    /// 是否正在倒计时验证码
    var isWaitingVerifyCode : Bool?
    
    var timer : Timer?
    
    let countdown : Int = 60
    
    var myCountdown : Int?
    
    deinit {
        print("RegisterViewController 释放")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UitlCommon.setFlat(view: loginButton!, radius: Configure.SYS_CORNERRADIUS(), borderColor: Configure.SYS_UI_COLOR_BG_RED(), borderWidth: 0.5)
        UitlCommon.setFlat(view: registerButton!, radius: Configure.SYS_CORNERRADIUS())
        UitlCommon.setFlat(view: verifiButton!, radius: Configure.SYS_CORNERRADIUS())
        
        isWaitingVerifyCode = false
        
        
        loginButtonHeight?.constant  = Configure.SYS_UI_BUTTON_HEIGHT()
        loginButton?.titleLabel?.font = Configure.SYS_UI_BUTTON_FONT()
        
        regeisterHeight?.constant  = Configure.SYS_UI_BUTTON_HEIGHT()
        registerButton?.titleLabel?.font = Configure.SYS_UI_BUTTON_FONT()
        
        verifiButton?.titleLabel?.font = Configure.SYS_UI_BUTTON_FONT()
        
        phoneNumField?.font = UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(14))
        recommedField?.font = UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(14))
        verificationField?.font = UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(14))
        userAgreementLabel?.font = UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(12))
        userAgreementButton?.titleLabel?.font = UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(12))
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    func closeKeyBord(){
        
        if phoneNumField!.isFirstResponder{
            phoneNumField!.resignFirstResponder()
        }
        else if(recommedField!.isFirstResponder){
            recommedField!.resignFirstResponder()
        }
        else if(verificationField!.isFirstResponder){
            verificationField!.resignFirstResponder()
        }
        
    }
    
    @IBAction func clickToLogin(){
        
        closeKeyBord()
        if self.timer != nil && self.timer!.isValid {
            
            self.timer?.invalidate()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickRegister(){
        
        closeKeyBord()
        
        if UitlCommon.isNull( phoneNumField!.text!) {
            self.showHint("请填写手机号")
            return
        }
        if UitlCommon.isNull( recommedField!.text!) {
            self.showHint("请填写推荐码")
            return
        }
        if UitlCommon.isNull( verificationField!.text!) {
            self.showHint("请填写验证码")
            return
        }
        if !userAgreementReadButton!.isSelected {
            self.showHint("请阅读并同意《传说商家用户协议》")
            return
        }
        
        if !UitlCommon.isVaildePhoneNum(phoneNumField!.text!) {
            self.showHint("请填写正确的手机号")
            return
        }
        
        self.showHud(in: self.view, hint: "注册中...")
        
        self.registerRequst(phoneNumField!.text!,
            smsCode: verificationField!.text!,
            recommendCode: recommedField!.text!
            , success: { (smsToken) -> Void in
                
                
//                self.getUserInfo({ (userModel) -> Void in
//                    
                    self.hideHud()
                    let story : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
                    let vc = story.instantiateViewController(withIdentifier: "SetPasswordViewController") as!  SetPasswordViewController
                    vc.smsToken = smsToken;
                    vc.phoneNum = self.phoneNumField!.text!
                    vc.currentType = .setNew
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
//                    }, failed: { (errorDes) -> Void in
//                        self.hideHud()
//                        self.showHint(errorDes)
//                })
                
                
                
                
                
            }, failed:{(errorDes) -> Void in
                self.hideHud()
                self.showHint(errorDes)
        })
        
        
        
    }
    
    func verifySendTimer(_ timers : Timer){
        
        DispatchQueue.main.async { () -> Void in
            
            (self.myCountdown!) -= 1;
            
            if (self.myCountdown <= 0) {
                
                self.timer!.invalidate();
                
                self.isWaitingVerifyCode = false
                self.verifiButton?.setTitle("获取验证码", for: UIControlState())
            }
            else{
                self.verifiButton?.setTitle(String(self.myCountdown!), for: UIControlState())
            }
        }
        
    }
    
    
    @IBAction func clickGetVerifyCode(){
        
        closeKeyBord()
        
        if UitlCommon.isNull(phoneNumField!.text!) {
            
            self.showHint("请先填写手机号")
            return
        }
        
        if isWaitingVerifyCode! {
            return
        }
        
        self.showHud(in: self.view, hint: "");
        
        
        self.sendMsg(phoneNumField!.text!, type: SMSType_Seller_Regist) { (bSuccess, message) -> Void in
            
            self.hideHud()
            self.showHint(message)
            if bSuccess {
                
                self.isWaitingVerifyCode = true
                self.myCountdown = self.countdown
                
                DefaultService.myCustomQueque().async {
                    
                    DispatchQueue.main.async { () -> Void in
                        
                        self.verifiButton?.setTitle(String(self.countdown), for: UIControlState())
                    }
                    
                    self.timer = Timer(timeInterval:1, target: self, selector: #selector(RegisterViewController.verifySendTimer(_:)), userInfo: nil, repeats: true)
                    let runloop = RunLoop.current
                    
                    runloop.add(self.timer!, forMode:RunLoopMode.commonModes)
                    runloop.run()
                    
                    
                }
            }
        }
        
    }
    
    
    
    @IBAction func clickUserAgreement(){
        
        closeKeyBord()
        
        let vc = WebViewViewController(nibName: "WebViewViewController", bundle: nil)
        vc.type = WebType_UserAgent
        self.navigationController?.pushViewController(vc, animated: true);
        
    }
    
    @IBAction func clickReadUserAgreement(){
        
        closeKeyBord()
        
        userAgreementReadButton!.isSelected = !userAgreementReadButton!.isSelected
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        closeKeyBord()
    }
    
    
}
