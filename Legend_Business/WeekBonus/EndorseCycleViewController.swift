//
//  EndorseCycleViewController.swift
//  legend_business_ios
//
//  Created by Frank on 2016/11/23.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class EndorseCycleViewController: BaseViewController,SettingDelegate{
    internal func setWeekBonusValue(type: Int, value:String) {
        self.textFieldValue = value
        self.saveData()
    }

    @IBOutlet weak var endorseField: UITextField!
    @IBOutlet weak var tipLab: UILabel!
    var weekBonusModel:WeekBonusModel!
    var textFieldValue:String!
    
    
    var isSet:Bool!
    
    
    var darStr:String!
    var seller_id:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "代言周期"
        self.setBackButton()
        if self.isSet == true{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "申请修改", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.modifyEvent))
        }else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.clickSaveEvent))
        }
        
        let leftview = UIImageView(image: UIImage(named: "normalImage"))
        leftview.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        self.endorseField.backgroundColor = UIColor.white
        self.endorseField.leftViewMode = UITextField.ViewMode.always
        self.endorseField.leftView = leftview
        
        self.endorseField.text = self.darStr
        
        self.loadData()
    }
    
    func loadData() -> Void {
        let dict = ["device_id":SaveEngine.getDeviceUUID(),
                    "token":SaveEngine.getToken(),
                    "seller_id":self.seller_id!,
                    "type":"1",
                    "endorse_days":self.endorseField.text!]
        self.showHud(in: self.view, hint: "")
        self.requestHTTPData(self.getHttpUrl("Api/Share/getSellerShareDetail"), parameters:dict, success:{(response:Any) in
            self.hideHud()
            print(response)
            self.weekBonusModel = WeekBonusModel.parseWeekResponse(response)
            self.refreshUI()
        }, failed:{(errorDic:Any) in
            self.hideHud()
            print(errorDic)
        })
    }
    
    func refreshUI() -> Void {
        guard let status:Int = Int(self.weekBonusModel.status) else { return
            self.endorseField.text = ""
        }
        if status == 0 || status == 1{
            self.endorseField.isEnabled = false
        }
        if status == 2 {
            self.navigationItem.rightBarButtonItem = nil
            self.endorseField.isEnabled = false
        }
        self.tipLab.text = self.weekBonusModel.msg
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
        view.type = 0
        view.delegate = self
        self.view.addSubview(view)
    }
    
    @objc func clickSaveEvent() -> Void {
        print("点击保存按钮")
        self.view.endEditing(true)
        if !self.endorseField.text!.isEmpty{
            self.textFieldValue = self.endorseField.text
            self.saveData()
        }
    }
    
    func saveData() -> Void {
        let dict = ["device_id":SaveEngine.getDeviceUUID(),
                    "token":SaveEngine.getToken(),
                    "seller_id":self.seller_id,
                    "type":"1",
                    "endorse_days":self.textFieldValue]
        self.showHud(in: self.view, hint: "")
        self.requestHTTPData(self.getHttpUrl("Api/Share/setSellerShare"), parameters:dict, success:{(response:Any) in
            self.hideHud()
            print(response)
            self.tipLab.text = "本月最多有一次申请机会，本月已修改，如需调整下月再来"
            self.endorseField.text = self.textFieldValue
            _ = self.navigationController?.popViewController(animated: true)
        }, failed:{(errorDic: Any) in
            self.hideHud()
            print(errorDic)
            let errDic = errorDic as! NSDictionary
            self.tipLab.text =  errDic["error_msg"] as! String?
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
