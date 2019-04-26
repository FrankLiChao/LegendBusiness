//
//  DefaultService.swift
//  Legend_Business
//
//  Created by heyk on 16/2/15.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class DefaultService: NSObject {
    
    static var myQueque : DispatchQueue?
    
    @objc class func defaultSetting() {
        
        
        UINavigationBar.appearance().barTintColor = Configure.SYS_UI_COLOR_BG_RED()
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(17))]
        UINavigationBar.appearance().isTranslucent = false
        
        UIToolbar.appearance().tintColor = .white
        UIToolbar.appearance().barTintColor = Configure.SYS_UI_COLOR_BG_RED()
        UIToolbar.appearance().isTranslucent = false
        
        WXApi.registerApp(WeChatKey)
        //判读版本更新等信息
        self.initRequst { (bsuccess, errorStr) -> Void in
            
            if bsuccess {
                if SaveEngine.getVersinNum() != NOW_VERSION_NUM {
                    
                    var leftButtonTitle = "稍后更新"
                    
                    if SaveEngine.versionForceUpdate() {
                        
                        leftButtonTitle = ""
                    }
                    CustomAlterView.getInstanceWithTitle("有新版本" + SaveEngine.getVersinNo(), message: SaveEngine.getVersinDesc(), leftButton: leftButtonTitle, rightButtonTitles: "前往更新", click: { (index, customAlterView) -> Void in
                        guard let customAlterView = customAlterView as? CustomAlterView else {
                            return
                        }
                        
                        if (index == 2) {
                            SDImageCache.shared().cleanDisk()
                            UIApplication.shared.openURL(URL(myString: SaveEngine.getVersinDownURL())!)
                         
                            if (!SaveEngine.versionForceUpdate()) {
                                customAlterView.dismiss()
                            }
                        }
                        else {
                            customAlterView.dismiss()
                        }
                        
                    }).show()
                }
            }
            
        }
        
//         DefaultService.showMyStoreController()
//        return;
// 
        if(SaveEngine.isLogin()){
            
            if SaveEngine.getSettleType() == SettleType_None  {
                
                DefaultService.showSettleController()
                return;
            }
            else if SaveEngine.getSettleType() == SettleType_Reviewing || SaveEngine.getSettleType() == SettleType_Failed {
            
                DefaultService.showReviewController()
            }
            else{
                DefaultService.showMyStoreController()
            }
        }
        else{
            
            DefaultService.showLoginController()
   
        }
    }
    
    
    @objc class func loginOut() {
        
        SaveEngine.clearUserInfo()
        DefaultService.showLoginController()
        
    }
    
    @objc class func myCustomQueque() -> DispatchQueue{
        
        if (myQueque == nil){
            
            myQueque =  DispatchQueue(label: "myCustomQueque", attributes: DispatchQueue.Attributes.concurrent)
        }
        
        return myQueque!
    }
    
    @objc class func showSettleController(){
        
        let vc1  =  StoreProfileEditViewController(nibName: "StoreProfileEditViewController", bundle: nil)
        let nav = KKNavigationController(rootViewController: vc1)
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController   =  nav
        
    }
    
    @objc class func showLoginController(){
        
        let story : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = story.instantiateViewController(withIdentifier: "LoginViewController") as!  LoginViewController
        
        let nav = KKNavigationController(rootViewController: loginVC)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController   = nav
        
    }
    @objc class func showReviewController(){
        
        let vc1  =  InReviewController(nibName: "InReviewController", bundle: nil)
        let nav = KKNavigationController(rootViewController: vc1)
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController   =  nav
        
    }
    
    @objc class func showMyStoreController(){
        
        let story : UIStoryboard = UIStoryboard(name: "Store", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "MyStoreMainController") as!  MyStoreMainController
        let nav = KKNavigationController(rootViewController: vc)
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController   =  nav
        
    }
    
    @objc class func showWelocmeController(){
        
        
        let vc = WelocomeViewController(nibName: "WelocomeViewController", bundle: nil)
        let nav = KKNavigationController(rootViewController: vc)
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController   =  nav
        
    }
}
