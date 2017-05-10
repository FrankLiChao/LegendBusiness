//
//  ForgetPasswordController.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/26.
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


class ForgetPasswordController: BaseViewController {
    
    @IBOutlet var phoneField : UITextField?
    @IBOutlet var sendSmSCodeButton : UIButton?
    @IBOutlet var verifyCodeField : UITextField?
    @IBOutlet var nextButton : UIButton?
    @IBOutlet var nextButtonHeight : NSLayoutConstraint?
    
    
    /// 是否正在倒计时验证码
    var isWaitingVerifyCode : Bool?
    
    var timer : Timer?
    
    let countdown : Int = 60
    
    var myCountdown : Int?
    
    deinit {
        print("ForgetPasswordController 释放")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButton()
        self.title = "忘记密码"
        
        
        UitlCommon.setFlat(view: phoneField!, radius: Configure.SYS_CORNERRADIUS())
        UitlCommon.setFlat(view: verifyCodeField!, radius: Configure.SYS_CORNERRADIUS())
        UitlCommon.setFlat(view: sendSmSCodeButton!, radius: Configure.SYS_CORNERRADIUS())
        UitlCommon.setFlat(view: nextButton!, radius: Configure.SYS_CORNERRADIUS())
        
        
        nextButtonHeight?.constant  = Configure.SYS_UI_BUTTON_HEIGHT()
        nextButton?.titleLabel?.font = Configure.SYS_UI_BUTTON_FONT()

        phoneField?.font = UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(14))
        verifyCodeField?.font = UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(14))
        
        let leftView : UIView = UIView(frame: CGRect(x: 0,y: 0,width: 15,height: 44))
        leftView.backgroundColor = UIColor.clear
        
        let leftView1 : UIView = UIView(frame: CGRect(x: 0,y: 0,width: 15,height: 44))
        leftView1.backgroundColor = UIColor.clear
        
        phoneField!.leftView = leftView
        phoneField!.leftViewMode = .always;
        
        
        verifyCodeField!.leftView = leftView1
        verifyCodeField!.leftViewMode = .always;
        
        
        isWaitingVerifyCode = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.timer != nil && self.timer!.isValid {
            
            self.timer!.invalidate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func verifySendTimer(_ timers : Timer){
        
        DispatchQueue.main.async { () -> Void in
            
            (self.myCountdown!) -= 1;
            
            if (self.myCountdown <= 0) {
                
                self.timer!.invalidate();
                
                self.isWaitingVerifyCode = false
                self.sendSmSCodeButton?.setTitle("获取验证码", for: UIControlState())
            }
            else{
                self.sendSmSCodeButton?.setTitle(String(self.myCountdown!), for: UIControlState())
            }
        }
        
    }

    
    @IBAction func clickNextButton(){
        
        UitlCommon.closeAllKeybord()
        if UitlCommon.isNull(phoneField!.text!){
            
            self.showHint("请输入手机号")
            return
        }
        
        if UitlCommon.isNull(verifyCodeField!.text!){
            
            self.showHint("请输入验证码")
            return
        }
        
        self.showHud(in: self.view, hint: "")
        self.checkMsgCode(
            phoneField?.text,
            type: SMSType_Seller_ForeGetPassword,
            code: verifyCodeField!.text!,
            success: { (smsToken) -> Void in
                  self.hideHud()
                
                let story : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
                let vc = story.instantiateViewController(withIdentifier: "SetPasswordViewController") as!  SetPasswordViewController
                vc.smsToken = smsToken;
                vc.phoneNum = self.phoneField!.text!
                vc.currentType = .findOld
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }, failed: { (errorDes) -> Void in
                self.hideHud()
                self.showHint(errorDes)
        
        })
        
    }
    
    @IBAction func clickSendSmSCode(){
        
        UitlCommon.closeAllKeybord()
        
        if UitlCommon.isNull(phoneField!.text!) {
            
            self.showHint("请先填写手机号")
            return
        }
        
        if isWaitingVerifyCode! {
            return
        }
        
        self.showHud(in: self.view, hint: "");
        
        
        self.sendMsg(phoneField!.text!, type: SMSType_Seller_ForeGetPassword) { (bSuccess, message) -> Void in
            
            self.hideHud()
            self.showHint(message)
            if bSuccess {
                
                self.isWaitingVerifyCode = true
                self.myCountdown = self.countdown
                
                DefaultService.myCustomQueque().async {
                    
                    DispatchQueue.main.async { () -> Void in
                        
                        self.sendSmSCodeButton?.setTitle(String(self.countdown), for: UIControlState())
                    }
                    
                    self.timer = Timer(timeInterval:1, target: self, selector: #selector(ForgetPasswordController.verifySendTimer(_:)), userInfo: nil, repeats: true)
                    let runloop = RunLoop.current
                    
                    runloop.add(self.timer!, forMode:RunLoopMode.commonModes)
                    runloop.run()
                    
                    
                }
            }
        }
        
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
