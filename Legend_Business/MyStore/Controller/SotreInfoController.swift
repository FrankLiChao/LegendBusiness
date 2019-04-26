//
//  SotreInfoController.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/18.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit


class SotreInfoController: BaseViewController, TypeSelectControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet var tableView : UITableView!
    
    fileprivate var myContext = 0
    
    var currentInfoMode = SaveEngine.getUserInfo() {
        willSet {
            self.removeMyObserver()
        }
        didSet {
            self.addModelObserver()
            tableView?.reloadData()
        }
    }
    

    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "店铺信息"
        self.setBackButton()
        
        //tableView?.tableFooterView = UIView()
        tableView.separatorColor = Configure.SYS_UI_COLOR_LINE_COLOR()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        addModelObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.currentInfoMode = SaveEngine.getUserInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        removeMyObserver()
    }
    
    
    // MARK: - Custom methods
    func addModelObserver(){
        currentInfoMode?.addObserver(self,
            forKeyPath: "thumb_img",
            options: .new,
            context: &myContext)
        
        currentInfoMode?.addObserver(self,
            forKeyPath: "seller_name",
            options: .new,
            context: &myContext)
        currentInfoMode?.addObserver(self,
            forKeyPath: "seller_cat_name",
            options: .new,
            context: &myContext)
        
        currentInfoMode?.addObserver(self,
            forKeyPath: "address",
            options: .new,
            context: &myContext)
        
        currentInfoMode?.addObserver(self,
            forKeyPath: "telephone",
            options: .new,
            context: &myContext)
        
        currentInfoMode?.addObserver(self,
            forKeyPath: "content",
            options: .new,
            context: &myContext)
        currentInfoMode?.addObserver(self,
                                     forKeyPath: "after_address",
                                     options: .new,
                                     context: &myContext)
    }
    
    func removeMyObserver(){
        currentInfoMode?.removeObserver(self, forKeyPath: "thumb_img")
        currentInfoMode?.removeObserver(self, forKeyPath: "seller_cat_name")
        currentInfoMode?.removeObserver(self, forKeyPath: "address")
        currentInfoMode?.removeObserver(self, forKeyPath: "seller_name")
        currentInfoMode?.removeObserver(self, forKeyPath: "telephone")
        currentInfoMode?.removeObserver(self, forKeyPath: "content")
        currentInfoMode?.removeObserver(self, forKeyPath: "after_address")
    }
    
    override func observeValue(forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?)
    {
        SaveEngine.saveUserInfo(currentInfoMode)
        self.tableView?.reloadData()
    }
    
    //MARK: - Custom
    func selectTypeModel(_ model:Any){
        currentInfoMode?.seller_cat_id = (model as AnyObject).seller_cat_id
        currentInfoMode?.seller_cat_name = (model as AnyObject).seller_cat_name
    }
    
    //MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.row {
//        case 0, 3, 4:
//            return 70
//        case 1, 2, 5:
//            return 45
//        default:
//            return 100
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreIconCell")
            let imageView = cell?.contentView.viewWithTag(1) as? UIImageView
            if imageView != nil{
                UitlCommon.setFlat(view:imageView!, radius: 27.5)
                if currentInfoMode?.storeIcon != nil {
                    imageView?.image = currentInfoMode?.storeIcon
                } else if currentInfoMode?.thumb_img != nil {
                    imageView?.sd_setImage(with: URL(myString: (currentInfoMode?.thumb_img!)!), placeholderImage: UIImage(named:"默认"))
                }
            }
            return cell!
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreInfoCell")
            let label  = cell?.contentView.viewWithTag(1) as! UILabel
            label.text = "店铺名称"
            let detailLabel = cell?.contentView.viewWithTag(2) as! UILabel
            detailLabel.text = currentInfoMode?.seller_name
            return cell!
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreInfoCell")
            let label  = cell?.contentView.viewWithTag(1) as! UILabel
            label.text = "经营类型"
            let detailLabel = cell?.contentView.viewWithTag(2) as! UILabel
            detailLabel.text = currentInfoMode?.seller_cat_name
            return cell!
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreInfoCell")
            let label  = cell?.contentView.viewWithTag(1) as! UILabel
            label.text = "门店地址"
            let detailLabel = cell?.contentView.viewWithTag(2) as! UILabel
            detailLabel.text = currentInfoMode?.address
            return cell!
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreInfoCell")
            let label  = cell?.contentView.viewWithTag(1) as! UILabel
            label.text = "售后地址"
            let detailLabel = cell?.contentView.viewWithTag(2) as! UILabel
            if let afterAddressDic = JSONParser.parseToDictionary(with: currentInfoMode?.after_address) as? Dictionary<String, Any>,
                let province = afterAddressDic["province"] as? String,
                let city = afterAddressDic["city"] as? String,
                let area = afterAddressDic["area"] as? String,
                let address = afterAddressDic["address"] as? String {
                detailLabel.text = "\(province) " + "\(city) " + "\(area) " + "\(address)"
            } else {
                detailLabel.text = "";
            }
            return cell!
        } else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreInfoCell")
            let label  = cell?.contentView.viewWithTag(1) as! UILabel
            label.text = "客服电话"
            let detailLabel = cell?.contentView.viewWithTag(2) as! UILabel
            detailLabel.text = currentInfoMode?.telephone
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreInfoCell")
            let label  = cell?.contentView.viewWithTag(1) as! UILabel
            label.text = "店铺介绍"
            let detailLabel = cell?.contentView.viewWithTag(2) as! UILabel
            detailLabel.text = currentInfoMode?.content
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {//设置头像
            weak var weakSelf = self
            self.takeEditPick({ (image) -> Void in
                if image != nil{
                    weakSelf!.uploadImage(image!,
                        type: UploadImageType_SellerLogo,
                        progress: { (progress) -> Void in
                        }, success: { (url) -> Void in
                            weakSelf!.changeUsrInfo(ChangeUserInfoType_Thumb_image, value: url, comple: { (bSuccess, des) -> Void in
                                weakSelf!.hideHud();
                                if bSuccess {
                                    weakSelf!.showHint("设置成功");
                                    weakSelf!.currentInfoMode?.storeIcon = image
                                    weakSelf!.currentInfoMode?.thumb_img = url
                                } else {
                                    weakSelf!.showHint(des);
                                }
                            })
                        }, failed: {(des) -> Void in
                            weakSelf!.hideHud();
                            weakSelf!.showHint(des);
                    })
                }
            })
        } else if (indexPath.row == 1){
            let vc = ModefyBackNameViewController(nibName: "ModefyBackNameViewController", bundle:nil)
            vc.type = ModefyType_SotreName
            vc.oldValue = currentInfoMode?.seller_name
            vc.strtitle = "店铺名称"
            vc.contentModel = currentInfoMode
            self.navigationController?.pushViewController(vc, animated: true)
        } else if (indexPath.row == 2){
            let vc = TypeSelectController(nibName: "TypeSelectController", bundle: nil)
            vc.delegate = self
            vc.type = SelectViewType_StoryType
            self.navigationController?.pushViewController(vc, animated: true)
        } else if (indexPath.row == 3){
            let vc = ShopAddressController(nibName: "ShopAddressController", bundle:nil)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if (indexPath.row == 4){
            let vc = ShippingAddressViewController()
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        } else if (indexPath.row == 5){
            let vc = ModefyBackNameViewController(nibName: "ModefyBackNameViewController", bundle:nil)
            vc.type = ModefyType_SotrePhone
            vc.oldValue = currentInfoMode?.telephone
            vc.strtitle = "客服电话"
            vc.contentModel = currentInfoMode
            self.navigationController?.pushViewController(vc, animated: true)
        } else if (indexPath.row == 6){
            let vc = EnterRefuseReasonController(nibName: "EnterRefuseReasonController", bundle: nil)
            vc.content = currentInfoMode
            vc.type = InPutTextViewType_Modify_Seller_Info
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
