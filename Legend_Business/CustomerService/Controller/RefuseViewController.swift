//
//  RefuseViewController.swift
//  legend_business_ios
//
//  Created by Frank on 2016/11/24.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class RefuseViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate {
    @IBOutlet weak var selectBtn: UIButton! //选择按钮
    @IBOutlet weak var refuseTx: UITextField!//拒绝说明
    @IBOutlet weak var uploadBtn: UIButton!//点击上传
    @IBOutlet weak var sureBtn: UIButton!//提交按钮
    @IBOutlet weak var bgView: UIView!//图片的背景View
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var imageTwo: UIImageView!
    @IBOutlet weak var imageThree: UIImageView!
    
    var tableView:UITableView!
    var selectedIndex:Int!
    var after_id:String!
    
    
    let dataArray = ["请选择拒绝的原因","退回的商品影响二次销售","买家退回的商品不是我家店铺的","未收到货","买家退回的商品不全"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "拒绝申请"
        self.view.backgroundColor = UIColor.white
        self.setBackButton()
        initFrameView()
    }

    func initFrameView() -> Void {
        self.refuseTx.layer.borderColor = self.bodyTextColor().cgColor
        self.refuseTx.layer.borderWidth = 0.5
        let leftview = UIImageView(image: UIImage(named: "normalImage"))
        leftview.frame = CGRect(x: 0, y: 0, width: 10.0, height: 10.0)
        self.refuseTx.leftViewMode = UITextField.ViewMode.always
        self.refuseTx.leftView = leftview
        
        
        self.selectBtn.layer.borderColor = self.bodyTextColor().cgColor
        self.selectBtn.layer.borderWidth = 0.5
        self.selectBtn.addTarget(self, action: #selector(self.clickSelectButtonEvent(button_:)), for: .touchUpInside)
        
        self.sureBtn.layer.cornerRadius = 6
        self.sureBtn.layer.masksToBounds = true
        self.sureBtn.addTarget(self, action: #selector(self.clickSureButtonEvent), for: .touchUpInside)
    }
    
    @objc func clickSureButtonEvent() -> Void {
        if (self.refuseTx.text?.isEmpty)! {
            self.showHint("请输入拒绝原因")
            return
        }
        let alterView = UIAlertView.init(title: "确认提交拒绝申请", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alterView.show()
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            let dict = ["device_id":SaveEngine.getDeviceUUID(),
                        "token":SaveEngine.getToken(),
                        "after_id":self.after_id,
                        "refuse_reason":self.refuseTx.text]
            self.showHud(in: self.view, hint: "")
            self.requestHTTPData(self.getHttpUrl("api/After/sellerRefuseAfter"), parameters:dict, success:{(response:Any) in
                self.hideHud()
                print(response)
                let dic = response as! NSDictionary
                FrankTools.showMessage((dic["msg"] as? String)!)
                _ = self.navigationController?.popViewController(animated: true)
            }, failed:{(errorDic:Any) in
                self.hideHud()
                let dic = errorDic as! NSDictionary
                FrankTools.showMessage((dic["error_msg"] as? String)!)
            })
        }
    }
    
    @objc func clickSelectButtonEvent(button_:UIButton) -> Void {
        self.tableView = UITableView(frame: CGRect(x: button_.frame.minX, y: button_.frame.minY, width: button_.frame.width, height: 0), style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.layer.borderWidth = 0.5
        self.tableView.layer.borderColor = self.seperateColor().cgColor
        self.tableView.backgroundColor = .white
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.separatorColor = self.seperateColor()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.view.addSubview(self.tableView)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.tableView.frame.size.height = CGFloat(40 * self.dataArray.count)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        
        cell?.textLabel?.text = self.dataArray[indexPath.row]
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell?.textLabel?.textColor = self.bodyTextColor()
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.selectBtn.setTitle(self.dataArray[indexPath.row], for: .normal)
        self.selectBtn.setTitleColor(indexPath.row == 0 ? self.noteTextColor():self.bodyTextColor(), for: .normal)
        self.dismissView()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func dismissView() -> Void {
        UIView.animate(withDuration: 0.25, animations: {
            var frame:CGRect = self.tableView.frame;
            frame.size.height = 0;
            self.tableView.frame = frame;
        }, completion:  { (complete : Bool) in
            self.tableView.removeFromSuperview()
        })
    }
    
    func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent){
        self.view.endEditing(true)
        self.dismissView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
