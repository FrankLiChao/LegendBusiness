//
//  BonusMoneyViewController.swift
//  legend_business_ios
//
//  Created by Frank on 2016/11/23.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class BonusMoneyViewController: BaseViewController,SettingDelegate {
    internal func setWeekBonusValue(type: Int, value: String) {
        self.textFieldValue = value
        self.saveEvent()
    }

    @IBOutlet weak var moneyTx: UITextField!
    @IBOutlet weak var tipLab: UILabel!
    var weekBonusModel:WeekBonusModel!
    var textFieldValue:String!
    
    
    
    var isSet:Bool!
    
    var moneyStr:String!
    var seller_id:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "分红金额"
        self.setBackButton()
        if self.isSet == true {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "申请修改", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.modifyEvent))
        }else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.clickSaveEvent))
        }
        
        
        let leftview = UIImageView(image: UIImage(named: "normalImage"))
        leftview.frame = CGRect(x: 0, y: 0, width: 10.0, height: 10.0)
        self.moneyTx.backgroundColor = UIColor.white
        self.moneyTx.leftViewMode = UITextField.ViewMode.always
        self.moneyTx.leftView = leftview
        self.loadData()
    }

    func loadData() -> Void {
        let dict = ["device_id":SaveEngine.getDeviceUUID(),
                    "token":SaveEngine.getToken(),
                    "seller_id":self.seller_id,
                    "type":"2",
                    "endorse_money":self.moneyTx.text!]
        self.showHud(in: self.view, hint: "")
        self.requestHTTPData(self.getHttpUrl("Api/Share/getSellerShareDetail"), parameters:dict, success:{(response:Any) in
            self.hideHud()
            print(response)
            self.weekBonusModel = WeekBonusModel.parseWeekResponse(response)
            self.refreshUI()
        }, failed:{(errorDic:Any) in
            self.hideHud()
            print(errorDic)
            let errorDic = errorDic as! NSDictionary
            let msg = errorDic["error_msg"] as! String?
            self.showHint(msg)
        })
    }
    
    func refreshUI() -> Void {
        
        guard let status:Int = Int(self.weekBonusModel.status) else { return
            self.moneyTx.text = self.weekBonusModel.endorse_money
        }
        
        if status == 0 || status == 1{
            self.moneyTx.isEnabled = false
        }
        
        if status == 2 {
            self.navigationItem.rightBarButtonItem = nil
            self.moneyTx.isEnabled = false
        }
        self.tipLab.text = self.weekBonusModel.msg
        self.moneyTx.text = self.weekBonusModel.endorse_money
    }
    
    @objc func modifyEvent() -> Void {
        if Int(self.weekBonusModel.status) == 0{
            FrankTools.showMessage("申请审核中，请勿重复提交")
            return
        }
        
        let nib = UINib(nibName: "SettingView", bundle: nil)
        let view:SettingView = nib.instantiate(withOwner: self, options: nil)[0] as! SettingView
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.frame = CGRect(x: 0, y: 0, width:self.view.frame.width , height:self.view.frame.height)
        view.type = 1
        view.delegate = self
        self.view.addSubview(view)
    }
    
    @objc func clickSaveEvent() -> Void {
        self.view.endEditing(true)
        if !self.moneyTx.text!.isEmpty{
            self.textFieldValue = self.moneyTx.text
            self.saveEvent()
        }
    }
    
    func saveEvent() -> Void {
        let dict = ["device_id":SaveEngine.getDeviceUUID(),
                    "token":SaveEngine.getToken(),
                    "seller_id":self.seller_id,
                    "type":"2",
                    "endorse_money":self.textFieldValue]
        self.showHud(in: self.view, hint: "")
        self.requestHTTPData(self.getHttpUrl("Api/Share/setSellerShare"), parameters:dict, success:{(response:Any) in
            self.hideHud()
            print(response)
            self.tipLab.text = "本月最多有一次申请机会，本月已修改，如需调整下月再来"
            self.moneyTx.text = self.textFieldValue
            _ = self.navigationController?.popViewController(animated: true)
        }, failed:{(errorDic:Any) in
            self.hideHud()
            print(errorDic)
            let errDic = errorDic as! NSDictionary
            self.tipLab.text =  errDic["error_msg"] as! String?
        })
    }

}
