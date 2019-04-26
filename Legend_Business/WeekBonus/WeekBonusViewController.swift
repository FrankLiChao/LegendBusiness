//
//  WeekBonusViewController.swift
//  legend_business_ios
//
//  Created by Frank on 2016/11/23.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class WeekBonusViewController: BaseViewController {
    @IBOutlet weak var endorseLab: UILabel!//代言周期
    @IBOutlet weak var moneyLab: UILabel!//分红金额
    @IBOutlet weak var endorseBtn: UIButton!//点击代言周期
    @IBOutlet weak var moneyBtn: UIButton!//点击分红金额
    @IBOutlet weak var tipLab: UILabel!
    var weekBonusModel:WeekBonusModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "周分红管理"
        self.setBackButton()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "帮助", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.clickHelpEvent))
        
        self.endorseBtn.addTarget(self, action: #selector(self.clickEndroseEvent), for: .touchUpInside)
        
        self.moneyBtn.addTarget(self, action: #selector(self.clickMoneyEvent), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    
    func loadData() -> Void {
        let dict = ["device_id":SaveEngine.getDeviceUUID(),
                    "token":SaveEngine.getToken()]
        self.showHud(in: self.view, hint: "")
        self.requestHTTPData(self.getHttpUrl("Api/Share/getSellerShareInfo"), parameters:dict as [AnyHashable : Any], success:{(response:Any) in
            self.hideHud()
            print(response)
            self.weekBonusModel = WeekBonusModel.parseResponse(response)
            if self.weekBonusModel != nil {
                self.refreshUI()
            }
        }, failed:{(errorDic:Any) in
            self.hideHud()
            print(errorDic)
        })
    }
    
    func refreshUI() {
        if let is_endorse_days = self.weekBonusModel.is_endorse_days {
            if Int(is_endorse_days) == 1 {
                self.endorseLab.text = self.weekBonusModel.endorse_days+" 天"
            }
        }
        if let is_endorse_money = self.weekBonusModel.is_endorse_money {
            if Int(is_endorse_money) == 1 {
                self.moneyLab.text = self.weekBonusModel.endorse_money+" 元"
            }
        }
    }
    
    @objc func clickMoneyEvent() -> Void {//点击分红金额
        guard (self.weekBonusModel) != nil else {
            let bonusVc = BonusMoneyViewController()
            bonusVc.seller_id = self.weekBonusModel.seller_id
            bonusVc.moneyStr  = self.weekBonusModel.endorse_money
            bonusVc.isSet = false
            self.navigationController?.pushViewController(bonusVc, animated: true)
            return
        }
        if self.weekBonusModel.seller_id.isEmpty == false {
            let bonusVc = BonusMoneyViewController()
            bonusVc.seller_id = self.weekBonusModel.seller_id
            bonusVc.moneyStr  = self.weekBonusModel.endorse_money
            bonusVc.isSet = false
            if let is_endorse_money = self.weekBonusModel.is_endorse_money {
                if Int(is_endorse_money) == 1 {
                    bonusVc.isSet = true
                }
            }
            
            self.navigationController?.pushViewController(bonusVc, animated: true)
        }
    }
    
    @objc func clickEndroseEvent() -> Void { //点击代言周期
        if !self.weekBonusModel.seller_id.isEmpty {
            let endorseVc = EndorseCycleViewController()
            endorseVc.seller_id = self.weekBonusModel.seller_id
            endorseVc.darStr = self.weekBonusModel.endorse_days
            endorseVc.isSet = false
            if let is_endorse_days = self.weekBonusModel.is_endorse_days {
                if Int(is_endorse_days) == 1 {
                    endorseVc.isSet = true
                }
            }
            self.navigationController?.pushViewController(endorseVc, animated:true)
        }
    }
    
    @objc func clickHelpEvent() -> Void {
        print("点击帮助按钮")
//        let alterView = UIAlertView.init(title: "代言管理规则", message: "1.代言规则只适用于可代言产品，非可代言产品不参与\n2.代言规则关系买家用户的周分红收益，在代言期间，买家购买了商家旗下的任意一款可代言产品，即完成代言，并根据买家推荐人数享受相应的周分红收益\n3.所有可代言商品的代言周期为固定周期，每周根据买家购买和分享情况进行一次分红，分红金额为固定金额，若需修改代言周期与分红金额，需向平台申请\n4.设置合理的代言周期与分红金额有助于买家用户完成购买任务与分享任务\n5.本规则最终解释权归平台方所有", delegate: nil, cancelButtonTitle: "知道了")
//        alterView.show()
        
        let nib = UINib(nibName: "PopView", bundle: nil)
        let view:PopView = nib.instantiate(withOwner: self, options: nil)[0] as! PopView
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        view.frame = CGRect(x: 0, y: 0, width:self.view.frame.width , height:self.view.frame.height)
        self.view.addSubview(view)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
