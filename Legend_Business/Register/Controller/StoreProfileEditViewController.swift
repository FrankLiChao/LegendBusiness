//
//  ProfileEditViewController.swift
//  legend_business_ios
//
//  Created by msb-ios-dev on 16/2/16.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class StoreProfileEditViewController: BaseViewController,UploadImageCellDelegate,TextEditeCellDelegate ,UploadUpdateDelegate,TypeSelectControllerDelegate{
    
    @IBOutlet var tableView : UITableView?
    @IBOutlet var doneButton : UIButton?
    
    var idImageViewList =  NSMutableArray()
    var licenseViewList =  NSMutableArray()
    var apitudeViewList =  NSMutableArray()
    var otherapitudeViewList =  NSMutableArray()
    
    var currentSelectIndex : IndexPath?//当前选中正在操作的cell index
    
    var currentSettltModel : SettleModel?
    
    
    deinit {
        print("StoreProfileEditViewController 释放")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "商家入驻"
        self.navigationItem.hidesBackButton = true
        
        let nib1 = UINib(nibName: "TextEditeCell", bundle: nil)
        tableView!.register(nib1, forCellReuseIdentifier: "TextEditeCell")
        
        UitlCommon.setFlat(view: doneButton!, radius: Configure.SYS_CORNERRADIUS())
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "退出登录", style: .plain, target: self, action: #selector(StoreProfileEditViewController.logout))
        
        
        self.showHud(in: self.view, hint: "")
        self.getSettle({ (settleModel) -> Void in
            
            self.hideHud()
            self.currentSettltModel = settleModel
            
            if  self.currentSettltModel == nil {
                self.currentSettltModel = SettleModel()
            }
            
            var _ : String
            
            for  imageURl in self.currentSettltModel!.id_img {
                let index = IndexPath.init(row: 0, section: 1);
                
                let imageView = CustomUploadImageView.createDownImageView(imageURl as! String ,tag:index )
                imageView?.delegate = self
                self.idImageViewList.add(imageView!)
            }
            
            for  imageURl in self.currentSettltModel!.license {
                
                let index = IndexPath.init(row: 0, section: 2);
                
                let imageView = CustomUploadImageView.createDownImageView(imageURl as! String, tag: index)
                imageView?.delegate = self
                self.licenseViewList.add(imageView!)
            }
            for  imageURl in self.currentSettltModel!.apitude {
                
                let index = IndexPath.init(row: 0, section: 3);
                
                let imageView = CustomUploadImageView.createDownImageView(imageURl as! String, tag: index)
                imageView?.delegate = self
                self.apitudeViewList.add(imageView!)
            }
            for  imageURl in self.currentSettltModel!.other_apitude {
                
                let index = IndexPath.init(row: 0, section: 3);
                
                let imageView = CustomUploadImageView.createDownImageView(imageURl as! String,tag: index)
                imageView?.delegate = self
                self.otherapitudeViewList.add(imageView!)
            }
            
            self.tableView?.reloadData()
            
            }, failed:{(errorDes) -> Void in
                
                self.hideHud()
                self.currentSettltModel = SettleModel()
                
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
    
    
    func logout(){
        
        DefaultService.loginOut()
        
    }
    
    @IBAction func clickDoneButton(_ button: UIButton?){
        
        UitlCommon.closeAllKeybord()
        
        if UitlCommon.isNull(self.currentSettltModel!.company){
            self.showHint("请填写公司名称")
            return
        }
        if UitlCommon.isNull(self.currentSettltModel!.operate){
            self.showHint("请选择公司经营类型")
            return
        }
        if UitlCommon.isNull(self.currentSettltModel!.contact_phone){
            self.showHint("请填写公司联系电话")
            return
        }
        
        
        
        if(self.idImageViewList.count == 0) {
            
            self.showHint("请上传身份证件图片")
            return
        }
        
        if(self.licenseViewList.count == 0) {
            
            self.showHint("请上传营业照图片")
            return
        }
        
        let idImageURLList = NSMutableArray()
        let licenseURLList = NSMutableArray()
        let apitudeURLList = NSMutableArray()
        let otherapitudeURLList = NSMutableArray()
        
        
        var _ : CustomUploadImageView
        
        for uploadImageView in self.idImageViewList {
            
            if (uploadImageView as AnyObject).status == ImageUploadStatus_Failed{
                
                self.showHint("请删除上传失败的图片")
                return
            }
            else if (uploadImageView as AnyObject).status == ImageUploadStatus_Uploading {
                
                self.showHint("请等待图片上传完成")
                return
            }
            
            idImageURLList.add((uploadImageView as! CustomUploadImageView).url)
        }
        
        
        for uploadImageView in self.licenseViewList {
            
            if (uploadImageView as AnyObject).status == ImageUploadStatus_Failed{
                
                self.showHint("请删除上传失败的图片")
                return
            }
            else if (uploadImageView as AnyObject).status == ImageUploadStatus_Uploading {
                
                self.showHint("请等待图片上传完成")
                return
            }
            licenseURLList.add((uploadImageView as! CustomUploadImageView).url)
        }
        
        for uploadImageView in self.apitudeViewList {
            
            if (uploadImageView as AnyObject).status == ImageUploadStatus_Failed{
                
                self.showHint("请删除上传失败的图片")
                return
            }
            else if (uploadImageView as AnyObject).status == ImageUploadStatus_Uploading {
                
                self.showHint("请等待图片上传完成")
                return
            }
            apitudeURLList.add((uploadImageView as! CustomUploadImageView).url)
        }
        
        for uploadImageView in self.otherapitudeViewList {
            
            if (uploadImageView as AnyObject).status == ImageUploadStatus_Failed{
                
                self.showHint("请删除上传失败的图片")
                return
            }
            else if (uploadImageView as AnyObject).status == ImageUploadStatus_Uploading {
                
                self.showHint("请等待图片上传完成")
                return
            }
            otherapitudeURLList.add((uploadImageView as! CustomUploadImageView).url)
        }
        
        
        
        
        self.showHud(in: self.view, hint:"")
        
        self.setSettle(currentSettltModel?.company,
            contact_phone: currentSettltModel?.contact_phone,
            operate: currentSettltModel?.operate,
            id_img: idImageURLList as [AnyObject],
            license: licenseURLList as [AnyObject],
            apitude: apitudeURLList as [AnyObject],
            other_apitude: otherapitudeURLList as [AnyObject],
            comple:{(bSuccess, errorDes) -> Void in
                
                if bSuccess {
                    self.getUserInfo({ (userModel) -> Void in
                        DefaultService.showReviewController()
                        
                        }, failed: { (errorDes) -> Void in
                            self.hideHud()
                            self.showHint(errorDes)
                    })
                }
                else{
                    self.hideHud()
                    self.showHint(errorDes)
                }
        })
        
        
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section <= 4 {return 1}
        else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat{
        
        if indexPath.section == 0{ return Configure.SYS_UI_SCALE(134) }
        else { return Configure.SYS_UI_SCALE(80) }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0{ return Configure.SYS_UI_SCALE(44) }
        else { return Configure.SYS_UI_SCALE(60) }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0{
            let lable = InsetsLabel(frame:CGRect(x: 0,y: 0,width: Configure.SYS_UI_WINSIZE_WIDTH(),height: Configure.SYS_UI_SCALE(44)), insets: UIEdgeInsetsMake(0, 20, -5, 0))
            lable.backgroundColor = Configure.SYS_UI_COLOR_BG_COLOR()
            lable.font = UIFont.systemFont(ofSize: Configure.SYS_UI_SCALE(14))
            lable.textColor = Configure.SYS_UI_COLOR_TEXT_BLACK()
            lable.text = "基本信息"
            return lable
        }
        else if(section <= 4){
            
            let lable = InsetsLabel(frame:CGRect(x: 0,y: 0,width: Configure.SYS_UI_WINSIZE_WIDTH(),height: Configure.SYS_UI_SCALE(44)), insets: UIEdgeInsetsMake(0, 20, -5, 0))
            lable.backgroundColor = Configure.SYS_UI_COLOR_BG_COLOR()
            lable.font = UIFont.systemFont(ofSize: Configure.SYS_UI_SCALE(14))
            lable.textColor = Configure.SYS_UI_COLOR_TEXT_BLACK()
            lable.numberOfLines = 0;
            lable.lineBreakMode = .byWordWrapping
            
            var str1 : NSString?
            var str2 : NSString?
            
            
            if section == 1 {
                str1  = "上传身份证\n"
                str2  = "( 身份证正反面照片 图片要求清晰，否则会影响审核通过 )"
            }
            else if section == 2 {
                str1  = "上传营业执照\n"
                str2  = "( 请提供营业执照副本 图片要求清晰，否则会影响审核通过 )"
            }
            else if section == 3 {
                str1  = "上传资质证明（选填）\n"
                str2  = "( 图片要求清晰，否则会影响审核通过 )"
            }
            else if section == 4 {
                str1  = "上传第三方资质证明（选填）\n"
                str2  = "( 图片要求清晰，否则会影响审核通过 )"
            }
            
            let attr = NSMutableAttributedString(string: (str1 as! String) + (str2 as! String))
            attr.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(14)), range: NSMakeRange(0, str1!.length))
            attr.addAttribute(NSForegroundColorAttributeName, value:Configure.SYS_UI_COLOR_TEXT_BLACK() , range: NSMakeRange(0, str1!.length))
            
            attr.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(12)), range: NSMakeRange( str1!.length, str2!.length))
            attr.addAttribute(NSForegroundColorAttributeName, value:Configure.SYS_UI_COLOR_TEXT_GRAY() , range: NSMakeRange( str1!.length, str2!.length))
            
            let paragraphStyle  = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5.0
            
            attr.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0,str1!.length + str2!.length))
            lable.attributedText = attr
            
            
            return lable
        }
        else {return nil}
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if indexPath.section == 0 {
            
            let cellIdentifier : String = "TextEditeCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TextEditeCell
            cell.delegate = self
            cell.companyNameField?.text  = currentSettltModel?.company
            cell.companyTypeField?.text = currentSettltModel?.operate_name
            cell.companyPhoneField?.text = currentSettltModel?.contact_phone
            
            return cell;
        }
        else{
            let cellIdentifier = "UploadImageCell"
            
            var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? UploadImageCell
            
            if (cell == nil){
                cell = UploadImageCell(reuseIdentifier: cellIdentifier,leadEdge: 10)
                cell?.delegate = self
            }
            
            cell?.cellIndex = indexPath
            
            
            if indexPath.section == 1{
                cell?.setUIWithData(idImageViewList)
            }
            else if (indexPath.section == 2){
                cell?.setUIWithData(licenseViewList)
            }
            else if (indexPath.section == 3){
                cell?.setUIWithData(apitudeViewList)
            }
            else if (indexPath.section == 4){
                cell?.setUIWithData(otherapitudeViewList)
            }
            return cell!;
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        
        
    }
    
    /**
     *  UploadImageCellDelegate
     */
    func clickAddNewImageButton(_ cell: UploadImageCell , cellIndex: IndexPath?){
        
        currentSelectIndex = cellIndex
        
        weak var weakSelf = self
        
        self.takeNormalPic({ (image) -> Void in
            
            if image != nil{
            
                let uploadImageView = CustomUploadImageView.createUploadImageView(image, type: UploadImageType_Settle, tag: weakSelf!.currentSelectIndex) { (url, image, index) -> Void in
                    
                    
                }
                uploadImageView?.delegate = weakSelf
                if weakSelf!.currentSelectIndex?.section == 1 {//身份证
                    
                    weakSelf!.idImageViewList.add(uploadImageView!)
                }
                else if(weakSelf!.currentSelectIndex?.section == 2){//营业执照
                    
                    weakSelf!.licenseViewList.add(uploadImageView!)
                }
                else if(weakSelf!.currentSelectIndex?.section == 3){//资质证明
                    
                    weakSelf!.apitudeViewList.add(uploadImageView!)
                }
                else if(weakSelf!.currentSelectIndex?.section == 4){//第三方资质证明
                    
                    weakSelf!.otherapitudeViewList.add(uploadImageView!)
                }
                
                weakSelf!.tableView?.reloadData()

            }
            else{
                weakSelf!.currentSelectIndex = nil;
            
            }
        })
        
       // UitlCommon.showPicAction(self, delegate: self)
        
    }
    
    func deleteImage(_ cell: UploadImageCell,cellIndex:IndexPath?, selectIndex: NSInteger){
        
        //  cell.contentArray?.removeObjectAtIndex(index)
        tableView?.reloadData()
    }
    
    //MARK --TextEditeCellDelegate
    func companyNameChange(_ name:String?){
        
        self.currentSettltModel?.company = name
//        print(name)
//        print(self.currentSettltModel?.company)
    }

    func companyPhoneChange(_ name:String?){
        
        self.currentSettltModel?.contact_phone = name
    }
    
    
//    /**
//     *  UIImagePickerControllerDelegate
//     */
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
//        
//        picker.dismissViewControllerAnimated(true, completion: nil)
//        
//        let img = info[UIImagePickerControllerEditedImage] as! UIImage
//        
//        print("w = \(img.size.width),h = \(img.size.height)")
//        
//        let uploadImageView = CustomUploadImageView.createUploadImageView(img, type: UploadImageType_Settle, tag: currentSelectIndex) { (url, image, index) -> Void in
//            
//            
//        }
//        uploadImageView.delegate = self
//        if currentSelectIndex?.section == 1 {//身份证
//            
//            idImageViewList.addObject(uploadImageView)
//        }
//        else if(currentSelectIndex?.section == 2){//营业执照
//            
//            licenseViewList.addObject(uploadImageView)
//        }
//        else if(currentSelectIndex?.section == 3){//资质证明
//            
//            apitudeViewList.addObject(uploadImageView)
//        }
//        else if(currentSelectIndex?.section == 4){//第三方资质证明
//            
//            otherapitudeViewList.addObject(uploadImageView)
//        }
//        
//        tableView?.reloadData()
//    }
//    
//    func imagePickerControllerDidCancel(picker: UIImagePickerController){
//        
//        currentSelectIndex = nil
//        
//        picker.dismissViewControllerAnimated(true, completion: nil)
//        
//    }
//    
    //MARK -- UploadUpdateDelegate
    func checkImageDetail(_ view :CustomUploadImageView){
        
        deleteUploadImage(view)
    }
    func deleteUploadImage(_ view :CustomUploadImageView){
        
        let index = view.contentTag
        if (index as AnyObject).section == 1 {//身份证
            
            idImageViewList.remove(view)
        }
        else if((index as AnyObject).section == 2){//营业执照
            
            licenseViewList.remove(view)
        }
        else if((index as AnyObject).section == 3){//资质证明
            
            apitudeViewList.remove(view)
        }
        else if((index as AnyObject).section == 4){//第三方资质证明
            
            otherapitudeViewList.remove(view)
        }
        
        tableView?.reloadData()
    }
    func companyCatogeryClick(){
    
        
        let vc = TypeSelectController(nibName: "TypeSelectController", bundle: nil)
        vc.delegate = self
        vc.type = SelectViewType_StoryType
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func selectTypeModel(_ model: Any){
        let m = model as AnyObject
        self.currentSettltModel?.operate_name = m.seller_cat_name
        self.currentSettltModel?.operate = m.seller_cat_id
        self.tableView?.reloadData()
    }
    
}
