//
//  RefundViewController.swift
//  legend_business_ios
//
//  Created by Frank on 2016/11/24.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class RefundViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate {
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var agreeBtn: UIButton!//同意申请
    @IBOutlet weak var contactBtn: UIButton!//联系买家
    @IBOutlet weak var refuseBtn: UIButton!//拒绝申请
    @IBOutlet weak var bgView: UIView!//背景View
    
    var sectionCount:Int = 0
    
    
    var after_id:String!
    var goodsInfoModel:AfterGoodsModel!
    var systemInfoModel:SystemInfoModel!
    var sellerInfoModel:SellerInfoModel!
    var userInforModel:UserInforModel!
    var afterInforModel:AfterInforModel!
    
    var afterList:Array<AfterSaleListModel>!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "协商退款"
        self.setBackButton()
        
        initFrameView()
        self.loadData()
    }
    
    func loadData() -> Void {
        let dict = ["device_id":SaveEngine.getDeviceUUID(),
                    "token":SaveEngine.getToken(),
                    "after_id":self.after_id]
        self.showHud(in: self.view, hint: "")
        self.requestHTTPData(self.getHttpUrl("api/After/getSellerAfterInfo"), parameters:dict, success:{(response:Any) in
            self.hideHud()
            print(response)
            self.myTableView.delegate = self
            self.myTableView.dataSource = self
            self.goodsInfoModel = AfterGoodsModel.parseResponse(response)
            self.afterList = AfterSaleListModel.parseResponse(response)
            if self.afterList != nil {
                self.sectionCount = self.afterList.count
            }
            self.afterInforModel = AfterInforModel.parseResponse(response)
            self.userInforModel = UserInforModel.parseResponse(response)
            self.sellerInfoModel = SellerInfoModel.parseResponse(response)
            self.systemInfoModel = SystemInfoModel.parseResponse(response)
            self.refreshUI()
            self.myTableView.reloadData()
        }, failed:{(errorDic:Any) in
            self.hideHud()
            print(errorDic)
        })
    }
    
    func refreshUI() -> Void {
        let status:Int = Int(self.systemInfoModel.after_status)!
        
        switch status {
        case 1:
            self.agreeBtn.setTitle("同意申请", for: .normal)
        case 2:
            self.agreeBtn.setTitle("已同意", for: .normal)
            self.bgView.isHidden = true
        case 3:
            self.agreeBtn.setTitle("确认收货", for: .normal)
        case 4:
            self.agreeBtn.setTitle("已收货", for: .normal)
            self.bgView.isHidden = true
        case 5:
            self.refuseBtn.setTitle("已拒绝", for: .normal)
            self.bgView.isHidden = true
        case 6,8,9:
            self.bgView.isHidden = true
        default:
            self.bgView.isHidden = false
        }
    }

    func initFrameView() -> Void {
        
        self.myTableView.register(UINib (nibName: "ShopsHeadTableViewCell", bundle: nil), forCellReuseIdentifier: "ShopsHeadTableViewCell")
        self.myTableView.register(UINib (nibName: "RefundTableViewCell", bundle: nil), forCellReuseIdentifier: "RefundTableViewCell")
        //RefundNoImageTableViewCell
        self.myTableView.register(UINib (nibName: "RefundNoImageTableViewCell", bundle: nil), forCellReuseIdentifier: "RefundNoImageTableViewCell")
        //BuyerTableViewCell
        self.myTableView.register(UINib (nibName: "BuyerTableViewCell", bundle: nil), forCellReuseIdentifier: "BuyerTableViewCell")
        self.myTableView.showsVerticalScrollIndicator = false
        self.myTableView.separatorStyle = .none
        self.myTableView.estimatedRowHeight = 200;
        self.myTableView.backgroundColor = self.backgroundColor()
        self.myTableView.rowHeight = UITableView.automaticDimension;
        self.myTableView.tableFooterView = UIView.init()
        
        self.agreeBtn.layer.borderWidth = 0.5
        self.agreeBtn.isSelected = true
        self.agreeBtn.layer.borderColor = self.mainColor().cgColor
        self.agreeBtn.setTitleColor(self.bodyTextColor(), for: .normal)
        self.agreeBtn.setTitleColor(self.mainColor(), for: .selected)
        self.agreeBtn .addTarget(self, action: #selector(self.clickAgreeButton), for: .touchUpInside)
        
        self.contactBtn.setTitleColor(self.bodyTextColor(), for: .normal)
        self.contactBtn.setTitleColor(self.mainColor(), for: .selected)
        self.contactBtn.layer.borderWidth = 0.5
        self.contactBtn.isSelected = true
        self.contactBtn.setTitleColor(UIColor.mainColor(), for: .normal)
        self.contactBtn.layer.borderColor = self.mainColor().cgColor
        self.contactBtn .addTarget(self, action: #selector(self.clickContactButtonEvent), for: .touchUpInside)
        
        self.refuseBtn.setTitleColor(self.bodyTextColor(), for: .normal)
        self.refuseBtn.setTitleColor(self.mainColor(), for: .selected)
        self.refuseBtn.layer.borderWidth = 0.5
        self.refuseBtn.isSelected = true
        self.refuseBtn.layer.borderColor = self.mainColor().cgColor
        self.refuseBtn.addTarget(self, action: #selector(self.clickRefuseBtnEvent), for: .touchUpInside)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.afterList != nil {
            return self.afterList.count + 3
        }
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.section == 0 && self.goodsInfoModel != nil{ //商品信息
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShopsHeadTableViewCell") as! ShopsHeadTableViewCell
            cell.backgroundColor = self.backgroundColor()
            cell.selectionStyle = .none
            cell.logoIm.sd_setImage(with: URL(myString: (self.goodsInfoModel.goods_thumb)), placeholderImage: UIImage(named:"默认"))
            cell.nameLab.text = self.goodsInfoModel.goods_name
            cell.moneyLab.text = String.init(format: "¥%@", self.goodsInfoModel.price)
            cell.attrLab.text = String.init(format: "规格：%@", self.goodsInfoModel.attr_name)
            if Int(self.goodsInfoModel.delivery_status) == 0{
                cell.statusLab.text = "买家已付款"
            }else {
                cell.statusLab.text = "买家已发货"
            }
            return cell;
        }
        if indexPath.section == 1 { //售后信息
            let cell = tableView.dequeueReusableCell(withIdentifier: "RefundTableViewCell") as! RefundTableViewCell
            cell.backgroundColor = self.backgroundColor()
            cell.selectionStyle = .none
            if self.afterInforModel == nil {
                return cell
            }
            if Int(self.afterInforModel.after_type) == 3{
                cell.titleLab.text = "买家发起了退款申请"
            }else{
                cell.titleLab.text = "买家发起了退款退货申请"
            }
            cell.dataLab.text = self.longTime(to: self.afterInforModel.apply_time,withFormat: "MM-dd HH:mm")
            cell.moneyLab.text = String.init(format: "退款金额:%@", self.afterInforModel.refund_money)
            cell.reFundResonLab.text = String.init(format: "退款原因:%@", self.afterInforModel.after_reason)
            cell.explainLab.text = String.init(format: "退款说明:%@", self.afterInforModel.refund_explain)
            var array:Array<String>!
            if !self.afterInforModel.after_img.isEmpty {
                array = self.afterInforModel.after_img.components(separatedBy: NSCharacterSet(charactersIn:",") as CharacterSet)
                if array.count>0 {
                    if array.count == 1 {
                        cell.imageOne.sd_setImage(with: URL(myString: array[0]))
                    }
                    if array.count == 2 {
                        cell.imageOne.sd_setImage(with: URL(myString: array[0]))
                        cell.imageTwo.sd_setImage(with: URL(myString: array[1]))
                    }
                    if array.count == 3 {
                        cell.imageOne.sd_setImage(with: URL(myString: array[0]))
                        cell.imageTwo.sd_setImage(with: URL(myString: array[1]))
                        cell.imageThree.sd_setImage(with: URL(myString: array[2]))
                    }
                }
                if self.userInforModel != nil {
                    cell.nameLab.text = self.userInforModel.user_name
                    cell.headIm.sd_setImage(with: URL(myString: (self.userInforModel.photo_url)), placeholderImage: UIImage(named:"user_default_head"))
                }
                
                return cell;
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "RefundNoImageTableViewCell") as! RefundNoImageTableViewCell
                cell.backgroundColor = self.backgroundColor()
                cell.selectionStyle = .none
                if self.userInforModel != nil {
                    cell.nameLab.text = self.userInforModel.user_name
                    cell.headIm.sd_setImage(with: URL(myString: (self.userInforModel.photo_url)), placeholderImage: UIImage(named:"user_default_head"))
                }
                guard let model = self.afterInforModel else {
                    return cell
                }
                
                if Int(model.after_type) == 3{
                    cell.titleLab.text = "买家发起了退款申请"
                }else{
                    cell.titleLab.text = "买家发起了退款退货申请"
                }
                cell.dataLab.text = self.longTime(to: model.apply_time,withFormat: "MM-dd HH:mm")
                cell.moneyLab.text = "退款金额:\(model.refund_money!)\n\n" + "退款原因:\(model.after_reason!)\n\n" + "退款说明:\(model.refund_explain!)"
                return cell
            }
        }
        if indexPath.section == self.sectionCount+2 { //系统信息
            let cell = tableView.dequeueReusableCell(withIdentifier: "RefundNoImageTableViewCell") as! RefundNoImageTableViewCell
            cell.backgroundColor = self.backgroundColor()
            cell.selectionStyle = .none
            if self.systemInfoModel == nil {
                return cell
            }
            
            print("%@",self.systemInfoModel)
            if Int(self.systemInfoModel.is_complete) == 1{
                cell.titleLab.text = "售后处理已完成"
            }else{
                cell.titleLab.text = "请处理"
            }
            if Int(self.afterInforModel.after_type) == 1 {
                cell.titleLab.text = "请处理退款退货"
            }
            if Int(self.afterInforModel.after_type) == 3 {
                cell.titleLab.text = "请处理退款"
            }
            cell.nameLab.text = "传说系统"
            let timeCount:Int = Int(self.systemInfoModel.end_tiem)! - Int(self.systemInfoModel.service_time)!
            self.startCountdownTime(timeCount: timeCount, cell: cell)
            cell.dataLab.text = self.longTime(to: self.systemInfoModel.notice_time,withFormat: "MM-dd HH:mm")
            
            if Int(self.systemInfoModel.after_status) == 1 || Int(self.systemInfoModel.after_status) == 3{
                cell.countDownBtn.isHidden = false
                
                if FrankTools.iphone5(){
                    cell.countDownBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                    cell.titleLab.font = UIFont.systemFont(ofSize: 12)
                }
                
                cell.moneyLab.text = String.init(format: "如同意申请，请点击同意退款\n\n如不同意申请，请联系买家后再拒绝退款\n\n如逾期未处理，系统将自动退款给买家")
                
            }else{
                cell.countDownBtn.isHidden = true
            }
            if Int(self.systemInfoModel.after_status) == 2 {
                let complete:Int = Int(self.systemInfoModel.is_complete)!
                if complete == 1 {
                    cell.titleLab.text = "退款完成"
                    cell.moneyLab.text = String.init(format: "退款金额：%@\n\n您同意了退款申请，系统将自动完成退款",self.systemInfoModel.refund_money)
                }else {
                    cell.moneyLab.text = "您同意了售后申请"
                }
            }
            if Int(self.systemInfoModel.after_status) == 3 {
                cell.moneyLab.text = String.init(format: "收到买家退货后，请及时退款\n\n如拒绝退款，请先联系买家确认\n\n如逾期未处理，系统将自动退款给买家")
            }
            if Int(self.systemInfoModel.after_status) == 4 {
                cell.titleLab.text = "退款已完成"
                cell.moneyLab.text = String.init(format: "退款金额：%@\n\n您已确认收货，系统将自动完成退款", self.systemInfoModel.refund_money)
            }
            if Int(self.systemInfoModel.after_status) == 5 {
                cell.moneyLab.text = "您已拒绝买家的售后申请"
//                cell.moneyLab.text = String.init(format: "拒绝说明：%@", self.systemInfoModel.)
            }
            if Int(self.systemInfoModel.after_status) == 6 {
                cell.moneyLab.text = "买家已取消售后申请"
            }
            if Int(self.systemInfoModel.after_status) == 8 {
                cell.moneyLab.text = "系统自动取消了售后申请"
                cell.titleLab.text = "退款已关闭"
            }
            if Int(self.systemInfoModel.after_status) == 9 {
                cell.titleLab.text = "退款已完成"
                cell.moneyLab.text = String.init(format: "退款金额：%@\n\n系统自动完成退款", self.systemInfoModel.refund_money)
            }
            return cell;
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "BuyerTableViewCell") as! BuyerTableViewCell
            cell.backgroundColor = self.backgroundColor()
            cell.selectionStyle = .none
            if self.afterList == nil {
                return cell
            }
            let model:AfterSaleListModel = self.afterList[indexPath.section-2]
            if Int(model.flag) == 0 { //表示买家信息
                let cell = tableView.dequeueReusableCell(withIdentifier: "RefundNoImageTableViewCell") as! RefundNoImageTableViewCell
                cell.backgroundColor = self.backgroundColor()
                cell.selectionStyle = .none
                cell.countDownBtn.isHidden = true
                cell.titleLab.text = "售后申请中"
                if Int(model.after_status) == 3 {
                    cell.titleLab.text = "买家已退货"
                    cell.moneyLab.text = String.init(format: "物流公司：%@\n\n物流单号：%@", model.express_company,model.express_num)
                }
                if Int(model.after_status) == 6 {
                    cell.titleLab.text = "售后已完成"
                    cell.moneyLab.text = String.init(format: "用户取消了售后申请")
                }
                cell.dataLab.text = self.longTime(to: model.create_time,withFormat: "MM-dd HH:mm")
                
                if self.sellerInfoModel != nil {
                    cell.nameLab.text = self.userInforModel.user_name
                    cell.headIm.sd_setImage(with: URL(myString: (self.userInforModel.photo_url)), placeholderImage: UIImage(named:"user_default_head"))
                }
                return cell
            }
            cell.dataLab.text = self.longTime(to: model.create_time,withFormat: "MM-dd HH:mm")
            cell.nameLab.text = self.sellerInfoModel.seller_name
            cell.headIm.sd_setImage(with: URL(myString: (self.sellerInfoModel.photo_url)), placeholderImage: UIImage(named:"user_default_head"))
            cell.titleLab.text = "售后处理中"
            if Int(model.after_status) == 2 {
                cell.resonLab.text = "您已同意售后申请"
            }
            if Int(model.after_status) == 4 {
                cell.resonLab.text = "您已收货"
            }
            if Int(model.after_status) == 5 {
                cell.resonLab.text = "您拒绝了售后申请"
                cell.titleLab.text = "售后处理已完成"
            }
            return cell;
        }
        
    }
    
    func startCountdownTime(timeCount:Int,cell:RefundNoImageTableViewCell) -> Void {
        let day:Int = timeCount/(24*3600)
        let hour:Int = (timeCount%(24*3600))/3600
        let minutes:Int = (timeCount%3600)/60
        var dayStr:String = String.init(format: "%d", day)
        var hourStr:String = String.init(format: "%d", hour)
        var minutesStr:String = String.init(format: "%d", minutes)
        if day<=0 {
            dayStr = String.init(format: "00")
        }
        if day>=10000 {
            dayStr = String.init(format: "%.1f万",Double(day)/10000)
        }else{
            dayStr = String.init(format: "%d",day)
        }
        if hour<10 && hour > 0{
            hourStr = String.init(format: "0%d", hour)
        }
        if minutes<10 && minutes>0 {
            minutesStr = String.init(format: "0%d", minutes)
        }
        let timeStr:String = String.init(format: "剩%@天%@时%@分", dayStr,hourStr,minutesStr)
        cell.countDownBtn.setTitle(timeStr, for: .normal)
    }
    
    @objc func clickAgreeButton(button_:UIButton) -> Void {
        print("点击同意按钮")
        if button_.titleLabel?.text == "同意申请" {
            let userModel:UserInfoModel = SaveEngine.getUserInfo()
            if Int(self.afterInforModel.after_type) == 1 && userModel.after_address.isEmpty {
                let alterView = UIAlertView.init(title: "您还没有设置售后地址，前往设置", message: "", delegate: self, cancelButtonTitle: "去设置")
                alterView.tag = 4;
                alterView.show()
                return;
            }
            
            let alterView = UIAlertView.init(title: "您确定同意售后申请？", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            alterView.tag = 2;
            alterView.show()
        }
        if button_.titleLabel?.text == "确认收货" {
            let alterView = UIAlertView.init(title: "您确定已收货", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            alterView.tag = 3;
            alterView.show()
        }
        
        
    }
    
    @objc func clickContactButtonEvent(button_:UIButton) -> Void {
        print("点击联系买家")
        if self.sellerInfoModel == nil {
            let alter = UIAlertView.init(title: "提示", message: "暂无买家信息", delegate: nil, cancelButtonTitle: "知道了")
            alter.show()
            return
        }
        if self.sellerInfoModel.telephone.isEmpty {
            let alter = UIAlertView.init(title: "提示", message: "暂无买家信息", delegate: nil, cancelButtonTitle: "知道了")
            alter.show()
        }else{
            self.detailPhone(self.sellerInfoModel.telephone)
        }
    }
    
    @objc func clickRefuseBtnEvent(button_:UIButton) -> Void {//RefuseViewController
        print("点击拒绝申请按钮")
        if button_.titleLabel?.text == "已拒绝" {
            let alter = UIAlertView.init(title: "提示", message: "您已拒绝", delegate: nil, cancelButtonTitle: "知道了")
            alter.show()
        }else {
            let refuseVc = RefuseViewController()
            refuseVc.after_id = self.after_id
            self.navigationController?.pushViewController(refuseVc, animated: true)
        }
        
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1  && alertView.tag == 2{
            let dict = ["device_id":SaveEngine.getDeviceUUID(),
                        "token":SaveEngine.getToken(),
                        "after_id":self.after_id]
            self.showHud(in: self.view, hint: "")
            self.requestHTTPData(self.getHttpUrl("api/After/sellerAgreeAfter"), parameters:dict, success:{(response:Any) in
                self.hideHud()
                print(response)
                _ = self.navigationController?.popViewController(animated: true)
            }, failed:{(errorDic:Any) in
                self.hideHud()
                let dic:NSDictionary = errorDic as! NSDictionary
                FrankTools.showMessage(dic["error_msg"] as! String)
                print(errorDic)
            })
        }
        if buttonIndex == 1 && alertView.tag == 3 {
            let dict = ["device_id":SaveEngine.getDeviceUUID(),
                        "token":SaveEngine.getToken(),
                        "after_id":self.after_id]
            self.showHud(in: self.view, hint: "")
            self.requestHTTPData(self.getHttpUrl("api/After/sellerVerifyGoods"), parameters:dict, success:{(response:Any) in
                self.hideHud()
                print(response)
                _ = self.navigationController?.popViewController(animated: true)
            }, failed:{(errorDic:Any) in
                self.hideHud()
                let dic:NSDictionary = errorDic as! NSDictionary
                FrankTools.showMessage(dic["error_msg"] as! String)
                print(errorDic)
            })
        }
        if alertView.tag == 4 {
            self.navigationController?.pushViewController(ShippingAddressViewController(), animated: true)
        }
    }
}
