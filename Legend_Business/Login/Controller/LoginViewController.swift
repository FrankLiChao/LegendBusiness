//
//  LoginViewController.swift
//  Legend_Business
//
//  Created by heyk on 16/2/15.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    @IBOutlet var loginButton   : UIButton?
    @IBOutlet var nameField     : UITextField?
    @IBOutlet var passwordField : UITextField?
    @IBOutlet var loginButtonHeight : NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField?.font = UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(14))
        passwordField?.font =  UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(14))
        UitlCommon.setFlat(view: loginButton!, radius: Configure.SYS_CORNERRADIUS())
        loginButtonHeight?.constant  = Configure.SYS_UI_BUTTON_HEIGHT()
        loginButton?.titleLabel?.font = Configure.SYS_UI_BUTTON_FONT()
        
        /// 添加点击背景关闭键盘
        let tapBack = UITapGestureRecognizer(target: self, action:#selector(LoginViewController.handelTapBack))
        tapBack.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapBack)
        
//        nameField?.text = "18227653504"
//        passwordField?.text = "00000000"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        handelTapBack()
        
    }
    
    @IBAction func clickForgetPassword(){
        
        let story : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "ForgetPasswordController") as!  ForgetPasswordController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func clickLogin(_ button : UIButton?){
        
        //       //test///
        //        let vc1  =  StoreProfileEditViewController(nibName: "StoreProfileEditViewController", bundle: nil)
        //        self.navigationController?.pushViewController(vc1, animated: true)
        //        return
        //      /////////
        
        
        handelTapBack()
        
        if UitlCommon.isNull( nameField!.text!) {
            self.showHint("请填写用户名")
            return
        }
        if UitlCommon.isNull( passwordField!.text!) {
            self.showHint("请填写密码")
            return
        }
        
        self.showHud(in: self.view, hint: "登录中...")
        
        weak var weakSelf = self
        
        self.loginRequst(nameField?.text,
            pwd: passwordField?.text,
            success: { (type) -> Void in
                
                
                SaveEngine.saveMyLoginAccount(weakSelf!.nameField!.text!)
                SaveEngine.saveLoginPassword(weakSelf!.passwordField!.text!)
                
                if type == SettleType_None {//未认证
                    weakSelf!.hideHud()
                    DefaultService.showSettleController()
                }
                else if(type == SettleType_Failed || type ==  SettleType_Reviewing){//认证失败|认证中
                    weakSelf!.hideHud()
                    DefaultService.showReviewController()
                }
                    
                else if (type == SettleType_Passed){//认证成功
                    
                    self.getUserInfo({ (UserInfo) -> Void in
                        
                        weakSelf!.hideHud()
                        
                        DefaultService.showMyStoreController()
                        
                        
                        }, failed: { (errorDes) -> Void in
                            
                            weakSelf!.hideHud()
                            weakSelf!.showHint(errorDes)
                    })
                    
                    
                }
            },
            failed: { (errorDes) -> Void in
                weakSelf!.hideHud()
                weakSelf!.showHint(errorDes)
        })
        
    }
    
    
    @objc func handelTapBack(){
        
        if (nameField?.isFirstResponder) != nil {
            nameField?.resignFirstResponder()
        }
        if (passwordField?.isFirstResponder) != nil {
            passwordField?.resignFirstResponder()
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        if textField == nameField {
            
            if UitlCommon.isNull(passwordField!.text!){
                passwordField?.becomeFirstResponder()
            }
            else{
                textField.resignFirstResponder()
            }
        }
        else if textField == passwordField {
            
            clickLogin(nil)
        }
        
        
        return true
    }
    
}
