//
//  AddBankTableController.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/23.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

@objc protocol AddBankTableControllerDelegate : NSObjectProtocol {
    
    @objc optional func bindCardSuccess(_ model: MyBankListVO?)
}


class AddBankTableController: UITableViewController {
    
    
    weak var delegate : AddBankTableControllerDelegate?
    
    @IBOutlet var bankNameLabel : UILabel?
    @IBOutlet var nameField : UITextField?
    @IBOutlet var numField : UITextField?
    @IBOutlet var sureButtton : UIButton?
    @IBOutlet var footView : UIView?
    
    var selectBankVO :BankListVO?
    
    deinit {
        
        print("AddBankTableController 释放")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UitlCommon.setFlat(view: sureButtton!, radius: Configure.SYS_CORNERRADIUS())
        footView?.frame = CGRect(x: 0, y: 0, width: Configure.SYS_UI_WINSIZE_WIDTH(), height: Configure.SYS_UI_BUTTON_HEIGHT()+11)
        sureButtton?.titleLabel?.font = Configure.SYS_UI_BUTTON_FONT()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func clickSureButton(){
        
        UitlCommon.closeAllKeybord()
        
        if UitlCommon.isNull(bankNameLabel!.text!){
            
            self.showHint("请选择银行卡类型")
            return
        }
        if UitlCommon.isNull(nameField!.text!) {
            
            self.showHint("请填写持卡人姓名")
            return
            
        }
        
        if UitlCommon.isNull(numField!.text!) {
            
            self.showHint("请输入银行卡号")
            return
        }
        
        weak var weakSelf = self
        self.showHud(in: self.view, hint: "添加中")
        
        self.addBankCard(selectBankVO?.bank_id,
            bankNo: numField?.text,
            ownerName: nameField?.text,
            success: { (msg) -> Void in
                weakSelf!.hideHud()
                weakSelf!.showHint(msg)
                
                
                if weakSelf!.delegate != nil && self.delegate!.responds(to: #selector(AddBankTableControllerDelegate.bindCardSuccess(_:))){
                    
                    if !UitlCommon.isNull(weakSelf!.bankNameLabel!.text!) {
                    
                        weakSelf!.delegate?.bindCardSuccess!(nil)
                    }
                    
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: SYS_ADD_BANK_SUCESS_NOTIFY), object: nil)
                
                _ = weakSelf!.navigationController?.popViewController(animated: true)
                
                
            }, failed: {(msg) -> Void in
                weakSelf!.hideHud()
                weakSelf!.showHint(msg)
                
        })
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1 {return 10}
        return 0
    }
    
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 && indexPath.section == 0{
            
            weak var weakSelf = self
            
            let bankList = SaveEngine.getLocalBankList()
            
            if bankList == nil{
                
                self.showHud(in: self.view, hint: "")
                self.getBankList({ (bankList) -> Void in
                    
                    weakSelf!.hideHud()
                    weakSelf!.showBankPick()
                    
                    }, failed: { (msg) -> Void in
                        weakSelf!.hideHud()
                        weakSelf!.showHint(msg)
                        
                })
            }
            else{
                self.showBankPick()
                
            }
            
        }
    }
    
    
    
    func showBankPick(){
        
        weak var weakSelf = self
        
        let resultArray = NSMutableArray()
        
        for vo in SaveEngine.getLocalBankList() {
            if let vo = vo as? BankListVO {
                resultArray.add(vo.name)
            }
        }
        CustomPickView.getInstance().showPick(self.selectBankVO?.name, data: resultArray as [AnyObject], valueChange: { (value, component) -> Void in
            
            }, select: { (content) -> Void in
                
                weakSelf!.bankNameLabel?.text = content as? String
                
                let bankList = SaveEngine.getLocalBankList()
                
                for vo in bankList! {
                    
                    if (vo as AnyObject).name == content as! String {
                        
                        weakSelf?.selectBankVO = vo as? BankListVO;
                        break
                    }
                }
            }, disSelect: { (content) -> Void in
                
        })
        
    }
}
