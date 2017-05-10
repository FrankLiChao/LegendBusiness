//
//  UploadImageCell.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/17.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

 @objc protocol UploadImageCellDelegate : NSObjectProtocol {
    
    /**
     点击添加图片响应协议
     
     - parameter cell:   当前cell
     - parameter button: 添加图片按钮
     */
    func clickAddNewImageButton(_ cell: UploadImageCell , cellIndex: IndexPath?)
    @objc optional func checkImageDetail(_ cell: UploadImageCell,cellIndex:IndexPath?, selectIndex: NSInteger)
    @objc optional func deleteImage(_ cell: UploadImageCell,cellIndex:IndexPath?, selectIndex: NSInteger)
}


class UploadImageCell: UITableViewCell , UploadImageViewDelegate{
    
    weak var delegate:UploadImageCellDelegate?
    
    let scrollView  =  UIScrollView()
    var contentArray : NSArray?
    var cellIndex : IndexPath?
    
    convenience init(reuseIdentifier: String?,leadEdge:CGFloat) {
        
        self.init(style:.default,reuseIdentifier:reuseIdentifier)
        self.backgroundColor = UIColor.clear
        
        scrollView.backgroundColor = UIColor.white
        self.contentView.addSubview(scrollView)
        UitlCommon.setFlat(view: scrollView, radius: Configure.SYS_CORNERRADIUS())
        
        scrollView.autoPinEdge(.top, to: .top, of: self.contentView)
        scrollView.autoPinEdge(.bottom, to: .bottom, of: self.contentView)
        scrollView.autoPinEdge(.left, to: .left, of: self.contentView, withOffset: leadEdge);
        scrollView.autoPinEdge(.right, to: .right, of: self.contentView, withOffset: -leadEdge);
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func setUIWithData(_ datas: NSArray?){ //CustomUploadImageView
        
        contentArray = datas;
        
        for view in self.scrollView.subviews{
            view.removeFromSuperview()
        }
        
        var contentW : CGFloat = 0.0;
        
        if datas != nil {
            for i in 0 ..< datas!.count {
                
                let imageV  = datas!.object(at: i) as! CustomUploadImageView
                
                
//                if value.isKindOfClass(UIImage) {
//                    imageV = UploadImageView.creareWithImage(value as! UIImage)
//                }
//                else if value.isKindOfClass(NSString) {
//                    imageV = UploadImageView.creareWithImageURL(value as! String)
//                }
//                else{
//                    imageV = UploadImageView(frame: CGRectZero)
//                }
//                imageV?.delegate = self
                
                imageV.tag = i;
                
                imageV.frame =  CGRect(
                    x: Configure.SYS_UI_SCALE(15) + CGFloat(i) * (Configure.SYS_UI_SCALE(53) + Configure.SYS_UI_SCALE(15)),
                    y: Configure.SYS_UI_SCALE(15),
                    width: Configure.SYS_UI_SCALE(53),
                    height: Configure.SYS_UI_SCALE(53))
//
                scrollView.addSubview(imageV)
                UitlCommon.setFlat(view:imageV, radius: 0, borderColor: Configure.SYS_UI_COLOR_LINE_COLOR(), borderWidth: 1)
                
                contentW = imageV.frame.size.width  + imageV.frame.origin.x
            }
            
        }
        let addImageButton = UIButton(type: .custom)
        addImageButton.backgroundColor = UIColor.white
        addImageButton.setImage(UIImage(named: "add_button"), for: UIControlState())
        addImageButton.frame = CGRect(x: contentW + Configure.SYS_UI_SCALE(15) , y: Configure.SYS_UI_SCALE(15), width: Configure.SYS_UI_SCALE(53), height: Configure.SYS_UI_SCALE(53))
        addImageButton.addTarget(self, action: #selector(UploadImageCell.addNewImage(_:)), for: .touchUpInside)
        UitlCommon.setFlat(view: addImageButton, radius: 0, borderColor: Configure.SYS_UI_COLOR_LINE_COLOR(), borderWidth: 1)
        scrollView .addSubview(addImageButton)
        
        scrollView.contentSize = CGSize(width: addImageButton.frame.size.width + addImageButton.frame.origin.x + Configure.SYS_UI_SCALE(15) ,height: 0)
    }
    
    
    func addNewImage(_ button : UIButton?){
        

        if delegate != nil {
            
            if self.delegate!.responds(to: #selector(UploadImageCellDelegate.clickAddNewImageButton(_:cellIndex:))) {
                self.delegate?.clickAddNewImageButton(self, cellIndex: cellIndex)
            }
        }
        
    }
    
    //UploadImageViewDelegate
    func uploadCheckImageDetail( _ view: UploadImageView,index: NSInteger){
    
        if delegate != nil {
            
            if self.delegate!.responds(to: Selector(("checkImageDetail:cellIndex:index:"))) {
                self.delegate?.checkImageDetail!(self,cellIndex:cellIndex, selectIndex: index)
            }
        }
        
    }
    func upLoadImageDelete( _ view: UploadImageView,index: NSInteger){
        
        if delegate != nil {
            
            if self.delegate!.responds(to: Selector(("deleteImage:cellIndex:index:"))) {
                self.delegate?.deleteImage!(self,cellIndex:cellIndex, selectIndex: index)
            }
        }

        
    }
    
}
