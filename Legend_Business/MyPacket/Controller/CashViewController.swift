
//
//  CashViewController.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/23.
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

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class CashViewController: BaseViewController ,UIAlertViewDelegate{
    
    var myMoney : String?//我的余额
    @IBOutlet var bankNameLabel : UILabel?
    @IBOutlet var banckDetailLabel : UILabel?
    @IBOutlet var bankIconImageView : UIImageView?
    @IBOutlet var avalibleAccountLabel : UILabel?
    @IBOutlet var accountField : UITextField?
    @IBOutlet var tipLabel : UILabel?
    @IBOutlet var sureButton : UIButton?
    @IBOutlet var sureButtonHeight : NSLayoutConstraint?
    
    var selectModel : MyBankListVO?
    
    var myBankList = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBackButton()
        self.title = "提现"
        
        self.sureButtonHeight?.constant = Configure.SYS_UI_BUTTON_HEIGHT()
        self.sureButton?.titleLabel?.font = Configure.SYS_UI_BUTTON_FONT()
        UitlCommon.setFlat(view:sureButton!, radius:  Configure.SYS_CORNERRADIUS())
        
        UitlCommon.setFlat(view: bankIconImageView!, radius: 24)
        sureButton?.enable(false)
        
        avalibleAccountLabel!.text = "\(myMoney!)"
        
        loadMyBankList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CashViewController.recieveBankListChanged), name: NSNotification.Name(rawValue: SYS_ADD_BANK_SUCESS_NOTIFY), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickSure(){
        
        UitlCommon.closeAllKeybord()
        
        if UitlCommon.isNull(accountField!.text!) || Float(accountField!.text!)<=0 {
            
            self.showHint("请输入正确的提现金额")
            return
        }
        if Float(accountField!.text!) > Float(myMoney!) {
            
            self.showHint("提现金额不能大于余额")
            return
        }
        if Float(accountField!.text!) > Float(5000) {
            
            self.showHint("单笔提现金额不能大于5000")
            return
        }
        
        enterMyPayPassword()
        
    }
    
    func reloadUI(){
        
        accountField?.placeholder = "\(myMoney!)"
        accountField?.text = ""
        avalibleAccountLabel!.text = "\(myMoney!)"
        bankNameLabel?.text = selectModel?.bank_name
        banckDetailLabel?.text = selectModel!.card_num + selectModel!.card_type
        bankIconImageView?.sd_setImage(with: URL(string: selectModel!.bank_logo), placeholderImage:  UIImage(named: "bank_0"))
        
    }
    
    func loadMyBankList(){
        
        self.showHud(in: self.view,hint:"")
        weak var weakSelf = self
        self.getMyBankCardList({(modelList) -> Void in//MyBankListVO
            weakSelf!.hideHud()
            if modelList != nil{
                
                if modelList == nil || modelList?.count==0 {//没有绑定银行卡
                    
                    let story : UIStoryboard = UIStoryboard(name: "Store", bundle: nil)
                    let vc = story.instantiateViewController(withIdentifier: "AddBankCardController") as!  AddBankCardController
                    vc.bFromCash = true
                    weakSelf!.navigationController?.pushViewController(vc, animated: true);
                    
                }
                else{//已绑定银行卡
                    weakSelf!.myBankList = NSMutableArray(array: modelList!)
                    weakSelf!.selectModel = weakSelf!.myBankList.firstObject as? MyBankListVO
                    weakSelf!.reloadUI()
                }
                
            }
            
            },failed:{(msg) -> Void in
                weakSelf!.hideHud()
                weakSelf!.showHint(msg)
        })
        
        
    }
    
    @IBAction func clickSelectCard(){
        
        weak var weakSelf = self
        
        let resultArray = NSMutableArray()
        
        for vo in self.myBankList {
            
            resultArray.add((vo as AnyObject).bank_name)
        }
        
        
        CustomPickView.getInstance().showPick(self.selectModel?.bank_name, data: resultArray as [AnyObject], valueChange: { (value, component) -> Void in
            
            }, select: { (content) -> Void in
                
                for vo in weakSelf!.myBankList {
                    
                    if (vo as AnyObject).bank_name == content as! String {
                        
                        weakSelf!.selectModel = vo as? MyBankListVO;
                        weakSelf!.reloadUI()
                        break
                    }
                }
            }, disSelect: { (content) -> Void in
                
        })
        
    }
    
    func enterMyPayPassword(){
        
        let vo = SaveEngine.getUserInfo() //as UserInfoModel
        if Int((vo?.payment_pwd)!) == 1 {//有密码
            
            weak var weakSelf = self
            
            EnterPasswordView.show(withContent: "\(accountField!.text!)",comple:{ (password) -> Void in
                
                weakSelf!.showHud(in: weakSelf!.view,hint:"")
                
                weakSelf!.takeCash(weakSelf!.selectModel!.bank_id!,money: Float(weakSelf!.accountField!.text!)!, password:password, success:{ (msg,myMoney) -> Void in
                    
                    weakSelf!.hideHud()
                    weakSelf!.showHint(msg)
//                    weakSelf!.myMoney = myMoney
//                    weakSelf!.reloadUI()
                    NotificationCenter.default.post(name: Notification.Name(rawValue: SYS_CASH_SUCESS_NOTIFY), object: nil)
                    weakSelf!.navigationController?.popViewController(animated: true)
                    
                    }, failed:{ (msg) -> Void in
                        weakSelf!.hideHud()
                        
                        let str = msg! as String
                        
                        if str.components(separatedBy: "支付密码错误").count > 1{
                            
                            let alter =   UIAlertView(title: "提示", message: str, delegate: self, cancelButtonTitle: "重试", otherButtonTitles: "忘记密码?")
                            alter.tag = 2
                            alter.show()
                        }
                        else{
                            
                            weakSelf!.showHint(msg)
                        }
                        
                        
                })
                
            })
        }
        else{//没有设置过密码
            
            let alter =   UIAlertView(title: "提示", message: "您还没设置过支付密码，提现需要先设置支付密码，是否去设置？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "设置")
            alter.tag = 1;
            alter.show()
            
        }
        
    }
    
    
    func setPayPassword(){
        
        let vc = CashPasswordFirstSetingViewController(nibName: "CashPasswordFirstSetingViewController", bundle: nil)
        vc.type = SMSType_SetPayPWD
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    
    
    //MARK -- UIAlertViewDelegate
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int){
        
        if alertView.tag == 2{
            if (buttonIndex == 1) {
                self.setPayPassword()
                
            }
            else{
                self.enterMyPayPassword()
            }
        }
        else if alertView.tag == 1 {
            
            if buttonIndex == 1 {
                setPayPassword()
            }
        }
    }
    
    
    
    
    //MARK: -UITextField delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        print(UitlCommon.getCurrentTextFiledText(textField.text!, newText: string))
        
        if UitlCommon.isNull(UitlCommon.getCurrentTextFiledText(textField.text!, newText: string)) {
            sureButton?.enable(false)
        }
        else {sureButton?.enable(true)}
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
    // MARK - Notify
    
    @objc func recieveBankListChanged(){
    
        loadMyBankList()
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
