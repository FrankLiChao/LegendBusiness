//
//  InReviewController.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/18.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class InReviewController: BaseViewController {
    
    enum ReviewStatus{
        
        case reviewing,failed,success
    };
    
    
    @IBOutlet var statusImageView : UIImageView?
    @IBOutlet var tipLabel : UILabel?
    @IBOutlet var detailLabel : UILabel?
    @IBOutlet var reWriteButton : UIButton?
    @IBOutlet var reWriteButtonWidth : NSLayoutConstraint?
    @IBOutlet var reWriteButtonHeight : NSLayoutConstraint?
    
 //   var currentReviewStatus : ReviewStatus = .reviewing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "商家入驻"
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "退出登录", style: .plain, target: self, action: #selector(InReviewController.logout))
        
        reWriteButtonWidth?.constant  = Configure.SYS_UI_SCALE(170)
        reWriteButtonHeight?.constant  = Configure.SYS_UI_BUTTON_HEIGHT()
        
        UitlCommon.setFlat(view: reWriteButton!, radius: Configure.SYS_CORNERRADIUS())
        reWriteButton?.titleLabel?.font = Configure.SYS_UI_BUTTON_FONT()
        
        
        
        self.showHud(in: self.view, hint: "")
        self.checkSettleStatus({ (settleType, errordes) -> Void in
         
           
            
            if settleType == SettleType_Reviewing {
                 self.hideHud()
                self.reWriteButton?.isHidden = true
                
                self.detailLabel?.text = "我们会在1～2个工作日内对资料进行审核\n如果你有什么问题，请联系客服"
            }
            else if settleType == SettleType_Failed  || settleType == SettleType_None{
                 self.hideHud()
                self.statusImageView?.image = UIImage(named: "未通过")
                self.tipLabel?.text = "很抱歉，审核未通过"
                self.detailLabel?.text = "原有如下：" + errordes!
            }
            else if(settleType == SettleType_Passed){
                
                self.getUserInfo({ (model) -> Void in
                    self.hideHud()
                    DefaultService.showMyStoreController()
                    
                    }, failed: { (error) -> Void in
                        self .showHint(error)
                })
            }
            else{
                self.hideHud()
                self.showHint("认证状态为未认证")
            }
            
            
            }, failed: { (errorDes) -> Void in
                self.hideHud()
                
        })
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @objc func logout(){
     
        DefaultService.loginOut()
    
    }
    
    @IBAction func clickPhone(_ button : UIButton){
        
        let phone = "tel:" + (button.titleLabel?.text)!
        UIApplication.shared.openURL(URL(string:phone)!)
        
    }
    
    @IBAction func reWrite(_ button: UIButton){
        
         DefaultService.showSettleController()
        
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
