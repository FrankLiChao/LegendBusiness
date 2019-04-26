//
//  AddOrEditGoodsViewController.swift
//  legend_business_ios
//
//  Created by Tsz on 2016/11/24.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class AddOrEditGoodsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, GoodsImagesTableViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FirstGoddsCategoryControllerDelegate, GoodsPictureViewControllerDelegate, UIAlertViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    weak var goodsNameTextField: UITextField!
    weak var displayPriceTextField: UITextField!
    weak var isEndorseSwith: UISwitch!
    weak var shippingFeeTextField: UITextField!
    weak var shippingFreeTextField: UITextField!
    
    @objc var goods_id: Int = 0
    var currentGoods: ProductModel?
    var tempImages: [UIImage] = []
    var tempImageURLs: [String] = []
    var tempGoodsImgDesc: [CustomUploadImageView] = []
    var tempParentCategory: GoodsCategoryModel?
    var tempCategory: GoodsCategoryModel?
    var tempAttributes: [ProductAttrModel] = []
    var currentPickIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.goods_id == 0 ? "添加商品" : "编辑商品"
        if self.goods_id != 0 {
            self.showHud(in: self.view, hint:"请稍后");
            self.getGoodInfo("\(self.goods_id)", success: { [unowned self] (goods: ProductDetailModel?) in
                if let goods = goods {
                    
                    self.currentGoods = ProductModel()
                    self.currentGoods!.goods_name = goods.goods_name
                    self.currentGoods!.shop_price = goods.shop_price
                    self.currentGoods!.is_endorse = goods.is_endorse
                    self.currentGoods!.shipping = goods.shipping
                    self.currentGoods!.shipping_free = goods.shipping_free
                    self.currentGoods!.goods_thumb = goods.goods_thumb
                    self.currentGoods!.is_endorse = goods.is_endorse
                    
                    let category = GoodsCategoryModel()
                    category.cat_id = goods.cat_id
                    category.cat_name = goods.cat_name
                    category.parent_id = goods.parent_id
                    self.tempCategory = category
                    
                    self.tempAttributes = goods.goods_size
                    self.tempImageURLs = goods.gallery_img as! [String]
                    
                    for gUrl in self.tempImageURLs {
                        let index = self.tempImageURLs.index(of: gUrl)!
                        self.tempImages.append(UIImage())
                        let manager = SDWebImageManager.shared()!
                        let thisURL = URL(myString: gUrl)!
                        let option = SDWebImageOptions(rawValue: 1<<8)
                        manager.downloadImage(with: thisURL, options:option, progress:nil, completed:{ [unowned self] (image: UIImage?, _ , _ , finished: Bool, _) in
                            if finished == true {
                                self.tempImages[index] = image!
                            } else {
                                self.tempImages.remove(at: index)
                            }
                            self.tableView.reloadData()
                        })
                    }
                    
                    var customArr: [CustomUploadImageView] = []
                    let good_desc = goods.goods_desc as! [String]
                    for url: String in good_desc {
                        let view = CustomUploadImageView.createDownImageView(url, tag: nil)!
                        customArr.append(view)
                    }
                    self.tempGoodsImgDesc = customArr
                    
                    self.hideHud()
                    self.tableView.reloadData()
                }
            }, failed: { [unowned self] (errorDesc: String?) in
                self.hideHud()
                self.showHint(errorDesc)
                let _ = self.navigationController?.popViewController(animated: true)
            })
        } else {
            self.currentGoods = ProductModel()
            self.tempAttributes.append(ProductAttrModel())
        }
        
        
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 74))
        footerView.backgroundColor = .clear
        let saveBtn = UIButton(type: .custom)
        saveBtn.frame = CGRect(x: 20, y: 10, width: footerView.bounds.width - 40, height: 44)
        saveBtn.titleLabel?.font = Configure.SYS_UI_BUTTON_FONT()
        saveBtn.backgroundColor = Configure.SYS_UI_COLOR_BG_RED()
        saveBtn.layer.cornerRadius = Configure.SYS_CORNERRADIUS()
        saveBtn.layer.masksToBounds = true
        saveBtn.setTitleColor(.white, for: .normal)
        saveBtn.setTitle("保存上架", for: .normal)
        saveBtn.addTarget(self, action: #selector(saveBtnClicked(_:)), for: .touchUpInside)
        footerView.addSubview(saveBtn)
        
        self.tableView.tableFooterView = footerView
        self.tableView.register(UINib(nibName:"GoodsAddOrEditHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "GoodsAddOrEditHeaderView")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Custom
    @objc func saveBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        func showAlertWithMessage(_ message: String) {
            let alert = UIAlertView(title: "提示", message: message, delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        }
        
        guard self.tempImages.count > 0 else {
            showAlertWithMessage("请选择商品轮播图")
            return
        }
        for url in self.tempImageURLs {
            if url == "" {
                showAlertWithMessage("请等待图片上传完成")
                return
            }
        }
        guard self.currentGoods!.goods_name != nil else {
            showAlertWithMessage("请输入商品名称")
            return
        }
        guard self.currentGoods!.shop_price != nil else {
            showAlertWithMessage("请输入展示价格")
            return
        }
        guard self.tempCategory != nil else {
            showAlertWithMessage("请选择商品分类")
            return
        }
        guard self.tempGoodsImgDesc.count > 0 else {
            showAlertWithMessage("请设置图文详情")
            return
        }
        for attr in self.tempAttributes {
            if attr.attr_name == nil {
                showAlertWithMessage("请输入规格")
                return
            } else if attr.price == nil {
                showAlertWithMessage("请输入价格")
                return
            } else if attr.goods_number == nil {
                showAlertWithMessage("请输入库存")
                return
            }
        }
        guard self.currentGoods!.shipping != nil else {
            showAlertWithMessage("请输入邮费")
            return
        }
        guard self.currentGoods!.shipping_free != nil else {
            showAlertWithMessage("请输入包邮金额")
            return
        }
        
        var goodsImgDescURL: [String] = []
        for view in self.tempGoodsImgDesc {
            goodsImgDescURL.append(view.url)
        }
        
        var goodsAttrs: [[String:String]] = []
        for attr in self.tempAttributes {
            var goodsAttr: [String: String] = [:]
            if let attr_id = attr.attr_id {
                goodsAttr["attr_id"] = "\(attr_id)"
            }
            
            goodsAttr["attr_name"] = attr.attr_name!
            goodsAttr["price"] = "\(attr.price!)"
            goodsAttr["goods_number"] = "\(attr.goods_number!)"
            if let warn_number = attr.warn_number {
                goodsAttr["warn_number"] = "\(warn_number)"
            } else {
                goodsAttr["warn_number"] = ""
            }
            if let recommend_reward = attr.recommend_reward {
                goodsAttr["recommend_reward"] = "\(recommend_reward)"
            } else {
                goodsAttr["recommend_reward"] = ""
            }
            if let share_reward = attr.share_reward {
                goodsAttr["share_reward"] = "\(share_reward)"
            } else {
                goodsAttr["share_reward"] = ""
            }
            goodsAttrs.append(goodsAttr)
        }
        
        if self.goods_id == 0 {
            self.showHud(in: self.view, hint:"添加中，请稍后");
            self.addGoods(self.currentGoods!.goods_name, categoryId: self.tempCategory!.cat_id, price: Float(self.currentGoods!.shop_price)!, goodsNum: 0, shareMoney: 0, goodsBrief: "", goodsPicDes: goodsImgDescURL, galleryImage: self.tempImageURLs, goodsImage: "", goodsThumb: self.currentGoods!.goods_thumb, attrList: goodsAttrs, isPrepare: false, prepareTime: 0, sellerTip: "", isEndorse: self.isEndorseSwith.isOn, shippingFee: self.currentGoods!.shipping, shippingFree: self.currentGoods!.shipping_free, success: { [unowned self] (goodsId: String?) in
                self.hideHud()
                self.showHint("添加成功")
                let _ = self.navigationController?.popViewController(animated: true)
            }, failed: { [unowned self] (errorDesc: String?) in
                self.hideHud()
                self.showHint(errorDesc)
            })
        } else {
            self.editGoods("\(self.goods_id)", goodsName:self.currentGoods!.goods_name, categoryId: self.tempCategory!.cat_id, price: Float(self.currentGoods!.shop_price)!, goodsNum: 0, shareMoney: 0, goodsBrief: "", goodsPicDes: goodsImgDescURL, galleryImage: self.tempImageURLs, goodsImage: "", goodsThumb: self.currentGoods!.goods_thumb, attrList: goodsAttrs, isPrepare: false, prepareTime: 0, sellerTip: "", isEndorse: self.isEndorseSwith.isOn, shippingFee: self.currentGoods!.shipping, shippingFree: self.currentGoods!.shipping_free, success: { [unowned self] (goodsId: String?) in
                self.hideHud()
                self.showHint("编辑成功")
                let _ = self.navigationController?.popViewController(animated: true)
                }, failed: { [unowned self] (errorDesc: String?) in
                    self.hideHud()
                    self.showHint(errorDesc)
            })
        }
    }
    
    @objc func toggleEndorseSwitch(_ sender: UISwitch) {
        self.view.endEditing(true)
        
        if sender.isOn == false {
            let alert = UIAlertView(title: "提示", message: "当前商品正在代言中，取消代言不影响之前参与代言用户收益，是否取消？", delegate: self, cancelButtonTitle: "不取消", otherButtonTitles: "取消代言")
            alert.show()
            
            let indexPath = IndexPath(row: 5, section: 0)
            if let cell = self.tableView.cellForRow(at: indexPath) as? GoodsSwitchTableViewCell {
                sender.isOn = true
                self.currentGoods!.is_endorse = true
                cell.detailLabel.text = "是"
            }
            return
        }
        self.currentGoods!.is_endorse = sender.isOn
    }
    
    @objc func addNewAttr(_ sender: UIButton) {
        self.view.endEditing(true)
        self.tempAttributes.append(ProductAttrModel())
        self.tableView.reloadData()
    }
    
    @objc func deleteAttr(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.tempAttributes.count <= 1 {
            let alert = UIAlertView(title: "提示", message: "请至少保留一个规格", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        let alert = UIAlertView(title: "提示", message: "是否要删除该规格？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "删除")
        alert.tag = sender.tag
        alert.show()
    }
    
    //MARK: - UITableViewDataSource & UITalbeViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 6
        case 1:
            return self.tempAttributes.count
        case 2:
            return 2
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 0.1
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "GoodsAddOrEditHeaderView") as! GoodsAddOrEditHeaderView
        header.backgroundColor = .white
        header.contentView.backgroundColor = .white
        header.addAttrBtn.addTarget(self, action: #selector(addNewAttr(_:)), for: .touchUpInside)
        switch section {
        case 0:
            header.titleLabel.text = "展示轮播图"
            header.infoLabel.isHidden = true
            header.infoLabel.text = ""
            header.addAttrBtn.isHidden = true
            header.line.isHidden = true
        case 1:
            header.titleLabel.text = "规格管理"
            header.infoLabel.isHidden = false
            header.infoLabel.text = "(*为必填)"
            header.addAttrBtn.isHidden = false
            header.line.isHidden = false
        case 2:
            header.titleLabel.text = "运费管理"
            header.infoLabel.isHidden = true
            header.infoLabel.text = ""
            header.addAttrBtn.isHidden = true
            header.line.isHidden = false
        default: break
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0  {
            if indexPath.row == 0 {
                return 90
            }
        } else if indexPath.section == 1 {
            return 185
        }
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsImagesTableViewCell") as! GoodsImagesTableViewCell
                cell.delegate = self
                cell.fetchDataSource = { [unowned self] () -> [UIImage] in
                    return self.tempImages
                }
                cell.line.isHidden = false
                cell.collectionView.reloadData()
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsInfoTableViewCell") as! GoodsInfoTableViewCell
                cell.titleLabel.text = "商品名称"
                cell.infoTextField.text = self.currentGoods?.goods_name ?? nil
                cell.infoTextField.attributedPlaceholder = NSAttributedString(string: "请输入商品名称", attributes: [NSAttributedString.Key.foregroundColor: Configure.SYS_UI_COLOR_PLACEHOLDER()])
                cell.infoTextField.textAlignment = .right
                cell.infoTextField.textColor = Configure.SYS_UI_COLOR_TEXT_GRAY()
                cell.line.isHidden = false
                cell.infoTextField.keyboardType = .default
                cell.infoTextField.delegate = self
                cell.infoTextField.textAlignment = .right
                self.goodsNameTextField = cell.infoTextField
                self.goodsNameTextField.tag = 1;
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsInfoTableViewCell") as! GoodsInfoTableViewCell
                cell.titleLabel.text = "展示价格"
                cell.infoTextField.text = self.currentGoods?.shop_price ?? nil
                cell.infoTextField.attributedPlaceholder = NSAttributedString(string: "请输入展示价格", attributes: [NSAttributedString.Key.foregroundColor: Configure.SYS_UI_COLOR_PLACEHOLDER()])
                cell.infoTextField.textAlignment = .right
                cell.infoTextField.textColor = Configure.SYS_UI_COLOR_BG_RED()
                cell.line.isHidden = false
                cell.infoTextField.keyboardType = .decimalPad
                cell.infoTextField.delegate = self
                cell.infoTextField.textAlignment = .right
                self.displayPriceTextField = cell.infoTextField
                self.displayPriceTextField.tag = 2;
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsSelectTableViewCell") as! GoodsSelectTableViewCell
                cell.titleLabel.text = "商品分类"
                cell.detailLabel.text = self.tempCategory == nil ? "请选择商品分类" : "\((self.tempCategory!.cat_name)!)"
                cell.detailLabel.textColor = Configure.SYS_UI_COLOR_PLACEHOLDER()
                cell.line.isHidden = false
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsSelectTableViewCell") as! GoodsSelectTableViewCell
                cell.titleLabel.text = "图文详情"
                cell.detailLabel.text = self.tempGoodsImgDesc.count > 0 ? "查看详情" : "请设置图文详情"
                cell.detailLabel.textColor = Configure.SYS_UI_COLOR_PLACEHOLDER()
                cell.line.isHidden = false
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsSwitchTableViewCell") as! GoodsSwitchTableViewCell
                cell.titleLabel.text = "是否为代言商品"
                cell.detailLabel.textColor = Configure.SYS_UI_COLOR_PLACEHOLDER()
                if let is_endorse = self.currentGoods?.is_endorse {
                    cell.accessorySwitch.isOn = is_endorse
                    cell.detailLabel.text = is_endorse ? "是" : "否"
                }
                cell.line.isHidden = true
                cell.accessorySwitch.addTarget(self, action: #selector(toggleEndorseSwitch(_:)), for: .valueChanged)
                self.isEndorseSwith = cell.accessorySwitch
                return cell
            }
        } else if indexPath.section == 1 {
            let attr = self.tempAttributes[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsAttrTableViewCell") as! GoodsAttrTableViewCell
            cell.attrNameTextField.tag = 11
            cell.attrNameTextField.delegate = self
            cell.attrNameTextField.keyboardType = .default
            cell.attrNameTextField.text = attr.attr_name
            cell.attrPriceTextField.tag = 12
            cell.attrPriceTextField.delegate = self
            cell.attrPriceTextField.keyboardType = .decimalPad
            cell.attrPriceTextField.text = attr.price != nil ? "\(attr.price!)" : nil
            cell.stockTextField.tag = 13
            cell.stockTextField.delegate = self
            cell.stockTextField.keyboardType = .numberPad
            cell.stockTextField.text = attr.goods_number != nil ? "\(attr.goods_number!)" : nil
            cell.stockWarningTextField.tag = 14
            cell.stockWarningTextField.delegate = self
            cell.stockWarningTextField.keyboardType = .numberPad
            cell.stockWarningTextField.text = attr.warn_number != nil ? "\(attr.warn_number!)" : nil
            cell.directAwardTextField.tag = 15
            cell.directAwardTextField.delegate = self
            cell.directAwardTextField.keyboardType = .decimalPad
            cell.directAwardTextField.text = attr.recommend_reward != nil ? "\(attr.recommend_reward!)" : nil
            cell.relativeAwardTextField.tag = 16
            cell.relativeAwardTextField.delegate = self
            cell.relativeAwardTextField.keyboardType = .decimalPad
            cell.relativeAwardTextField.text = attr.share_reward != nil ? "\(attr.share_reward!)" : nil
            cell.deleteBtn.tag = indexPath.row
            cell.deleteBtn.addTarget(self, action: #selector(deleteAttr(_:)), for: .touchUpInside)
            if let warn_number = attr.warn_number, let goods_number = attr.goods_number {
                let w = Int(warn_number)!
                let n = Int(goods_number)!
                if w >= n {
                    cell.notEnoughStockLabel.isHidden = false
                } else {
                    cell.notEnoughStockLabel.isHidden = true
                }
            } else {
                cell.notEnoughStockLabel.isHidden = true
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsInfoTableViewCell") as! GoodsInfoTableViewCell
            cell.infoTextField.textAlignment = .right
            cell.infoTextField.textColor = Configure.SYS_UI_COLOR_TEXT_BLACK()
            if indexPath.row == 0 {
                cell.titleLabel.text = "邮费"
                cell.infoTextField.text = self.currentGoods?.shipping ?? nil
                cell.infoTextField.attributedPlaceholder = NSAttributedString(string: "请输入邮费", attributes: [NSAttributedString.Key.foregroundColor: Configure.SYS_UI_COLOR_PLACEHOLDER()])
                cell.line.isHidden = false
                cell.infoTextField.keyboardType = .decimalPad
                cell.infoTextField.delegate = self
                cell.infoTextField.textAlignment = .left
                self.shippingFeeTextField = cell.infoTextField
                self.shippingFeeTextField.tag = 3;
            } else {
                cell.titleLabel.text = "满额包邮"
                cell.infoTextField.text = self.currentGoods?.shipping_free ?? nil
                cell.infoTextField.attributedPlaceholder = NSAttributedString(string: "请输入包邮金额", attributes: [NSAttributedString.Key.foregroundColor: Configure.SYS_UI_COLOR_PLACEHOLDER()])
                cell.line.isHidden = true
                cell.infoTextField.keyboardType = .decimalPad
                cell.infoTextField.delegate = self
                cell.infoTextField.textAlignment = .left
                self.shippingFreeTextField = cell.infoTextField
                self.shippingFreeTextField.tag = 4;
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 3 {
                let select = FirstGoddsCategoryController(nibName:"FirstGoddsCategoryController", bundle: nil)
                select.delegate = self
                self.navigationController?.pushViewController(select, animated: true)
            } else if indexPath.row == 4 {
                let imageDesc = GoodsPictureViewController(nibName:"GoodsPictureViewController", bundle: nil)
                imageDesc.delegate = self
                let array: NSArray = self.tempGoodsImgDesc as NSArray
                imageDesc.currentPicsView = array.mutableCopy() as! NSMutableArray
                self.navigationController?.pushViewController(imageDesc, animated: true)
            }
        }
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            self.currentGoods!.goods_name = textField.text?.trim()
        } else if textField.tag == 2 {
            self.currentGoods!.shop_price = textField.text?.trim()
        } else if textField.tag == 3 {
            self.currentGoods!.shipping = textField.text?.trim()
        } else if textField.tag == 4 {
            self.currentGoods!.shipping_free = textField.text?.trim()
        } else {
            func getParentTableViewCellBySubview(subview: UIView) -> UITableViewCell? {
                guard let superView = subview.superview else {
                    return nil
                }
                if superView.isKind(of: UITableViewCell.self) {
                    return superView as? UITableViewCell
                }
                return getParentTableViewCellBySubview(subview: superView)
            }
            guard let cell = getParentTableViewCellBySubview(subview: textField) else {
                return
            }
            
            let indexPath = self.tableView.indexPath(for: cell)
            
            let attr: ProductAttrModel = self.tempAttributes[indexPath!.row]
            switch textField.tag {
            case 11:
                attr.attr_name = textField.text?.trim()
            case 12:
                attr.price = textField.text?.trim()
            case 13:
                attr.goods_number = textField.text?.trim()
            case 14:
                attr.warn_number = textField.text?.trim()
            case 15:
                attr.recommend_reward = textField.text?.trim()
            case 16:
                attr.share_reward = textField.text?.trim()
            default: break
            }
            self.tempAttributes[indexPath!.row] = attr
        }
    }
    
    //MARK: - GoodsImagesTableViewCellDelegate
    func goodsImagesTableViewCell(_ cell: GoodsImagesTableViewCell, didTappedImageAt index: Int) {
        guard index == self.tempImages.count else {
            return
        }
        let sheet = UIAlertController(title: "选中照片", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "拍照", style: .default, handler: { [unowned self] (action: UIAlertAction) in
            self.currentPickIndex = index
            let pickVC = UIImagePickerController()
            pickVC.sourceType = .camera
            pickVC.allowsEditing = true
            pickVC.delegate = self
            self.present(pickVC, animated: true, completion: nil)
        }))
        sheet.addAction(UIAlertAction(title: "从手机相册获取", style: .default, handler: { [unowned self] (action: UIAlertAction) in
            self.currentPickIndex = index
            let pickVC = UIImagePickerController()
            pickVC.sourceType = .photoLibrary
            pickVC.allowsEditing = true
            pickVC.delegate = self
            self.present(pickVC, animated: true, completion: nil)
        }))
        self.present(sheet, animated: true, completion: nil)
    }
    
    func goodsImagesTableViewCell(_ cell: GoodsImagesTableViewCell, didTappedDeleteBtnAt index: Int) {
        self.tempImages.remove(at: index)
        self.tempImageURLs.remove(at: index)
        self.tableView.reloadData()
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.tempImages.append(editImage)
            self.tempImageURLs.append("")
            let index = self.tempImages.index(of: editImage)!
            if index == 0 {
                //Generate thumb image
                let thumbImageData = editImage.compressImage(with: 200)
                if let thumbImage = UIImage(data: thumbImageData!) {
                    self.uploadImage(thumbImage, type: UploadImageType_Edit, progress:{ (progress: Progress?) in
                    }, success: { [unowned self] (imageURL: String?) in
                        self.currentGoods!.goods_thumb = imageURL;
                    }, failed: { [unowned self] (errorDes: String?) in
                        self.showHint(errorDes!)
                        self.tempImages.remove(at: index)
                        self.tempImageURLs.remove(at: index)
                        self.tableView.reloadData()
                    })
                }
            }
            let compressImageData = UIImage(data: editImage.compressImage(with: 500)!)
            self.uploadImage(compressImageData, type: UploadImageType_Edit, progress:{ (progress: Progress?) in
                if let progress = progress, let index = self.currentPickIndex {
                    let name = Notification.Name(rawValue : "GoodsImagesCollectionViewCell.Progress")
                    NotificationCenter.default.post(name: name, object: progress, userInfo: ["index": index])
                }
            }, success: { [unowned self] (imageURL: String?) in
                if let imageURL = imageURL {
                    self.tempImageURLs[index] = imageURL
                }
            }, failed: { [unowned self] (errorDes: String?) in
                self.showHint(errorDes!)
                self.tempImages.remove(at: index)
                self.tempImageURLs.remove(at: index)
                self.tableView.reloadData()
            })
            self.tableView.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.currentPickIndex = nil
    }
    
    //MARK: - UIAlertViewDelegate
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if alertView.buttonTitle(at: buttonIndex) == "取消代言" {
            let indexPath = IndexPath(row: 5, section: 0)
            if let cell = self.tableView.cellForRow(at: indexPath) as? GoodsSwitchTableViewCell {
                cell.accessorySwitch.isOn = false
                self.currentGoods!.is_endorse = false
                cell.detailLabel.text = "否"
            }
        } else if alertView.buttonTitle(at: buttonIndex) == "删除" {
            self.tempAttributes.remove(at: alertView.tag)
            self.tableView.reloadData()
        }
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func select(_ model: GoodsCategoryModel?, parentModel: GoodsCategoryModel?) {
        self.tempCategory = model
        self.tempParentCategory = parentModel
        self.tableView.reloadData()
    }
    
    //MARK: - GoodsPictureViewControllerDelegate
    func addGoodsPic(_ goodPicsView: [CustomUploadImageView]?) {
        if let imgDesc = goodPicsView {
            self.tempGoodsImgDesc = imgDesc
        }
        self.tableView.reloadData()
    }
}

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}

extension UIImage {
    func compressImage(with maxSize: CGFloat) -> Data? {
        let newSize = self.scaleImage(with: maxSize)
        let newImage = self.resizeImage(with: newSize)
        let compress: CGFloat = 0.9
        let data = newImage.jpegData(compressionQuality: compress)
//        while (data?.count)! > maxLength && compress > 0.01 {
//            compress -= 0.02
//            data = UIImageJPEGRepresentation(newImage, compress)
//        }
        return data
    }
    
    func scaleImage(with imageLength: CGFloat) -> CGSize {
        var newWidth: CGFloat = 0.0
        var newHeight: CGFloat = 0.0
        let width = self.size.width
        let height = self.size.height
        if (width > imageLength || height > imageLength){
            if width > height {
                newWidth = imageLength;
                newHeight = newWidth * height / width;
            } else if height > width {
                newHeight = imageLength;
                newWidth = newHeight * width / height;
            } else {
                newWidth = imageLength;
                newHeight = imageLength;
            }
        }
        return CGSize(width: newWidth, height: newHeight)
    }
    
    func resizeImage(with newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
}

