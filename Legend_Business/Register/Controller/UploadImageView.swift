//
//  UploadImageView.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/17.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

@objc protocol UploadImageViewDelegate : NSObjectProtocol {
    
    @objc optional func uploadCheckImageDetail( _ view: UploadImageView,index: NSInteger)
    @objc optional func upLoadImageDelete( _ view: UploadImageView,index: NSInteger)
}


class UploadImageView: UIView {

    weak var delegate:UploadImageViewDelegate?
    
    var imageButton : UIButton?
    var deleteButton: UIButton?
    var imageData: UIImage?
    var imageURL: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageButton = UIButton(type: .custom)
        imageButton?.frame = self.bounds;
        imageButton?.backgroundColor = Configure.SYS_UI_COLOR_BG_COLOR();
        imageButton?.addTarget(self, action: #selector(UploadImageView.showImageDetail(_:)), for: .touchUpInside)
        self.addSubview(imageButton!)
        
        deleteButton = UIButton(type: .custom)
        deleteButton?.frame = CGRect(x: self.frame.size.width/2, y: 0, width: self.frame.size.width/2, height: self.frame.size.width/3);
        deleteButton?.backgroundColor = UIColor.clear;
        deleteButton?.setImage(UIImage(named: "delete_black"), for:UIControlState())
        deleteButton?.addTarget(self, action: #selector(UploadImageView.deleteImage(_:)), for: .touchUpInside)
        self.addSubview(deleteButton!)
        
        if self.imageData != nil {
            self.imageButton?.setBackgroundImage(self.imageData, for: UIControlState())
        }
        else if(imageURL != nil){
            imageButton?.sd_setBackgroundImage(with: URL(myString: imageURL!), for: UIControlState())
        }
 
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    class func creareWithImage(_ image: UIImage) -> UploadImageView{
    
        let instance = UploadImageView.init(frame: CGRect(x: 0, y: 0, width: Configure.SYS_UI_SCALE(53), height: Configure.SYS_UI_SCALE(53)))
        instance.imageButton?.setBackgroundImage(image, for: UIControlState())
        return instance
    }
    
    class func creareWithImageURL(_ imageURL: String) -> UploadImageView{
        
        let instance = UploadImageView.init(frame: CGRect(x: 0, y: 0, width: Configure.SYS_UI_SCALE(53), height: Configure.SYS_UI_SCALE(53)))
        
        instance.imageButton?.sd_setBackgroundImage(with: URL(myString: imageURL), for: UIControlState())
        
        return instance
    }
    
    func showImageDetail(_ button : UIButton?){
    
        if delegate != nil {
            
            if self.delegate!.responds(to: #selector(UploadImageViewDelegate.uploadCheckImageDetail(_:index:))) {
                self.delegate?.uploadCheckImageDetail!(self, index: self.tag)
            }
        }
    }
    
    func deleteImage(_ button : UIButton?){
    
        
        if delegate != nil {
            
            if self.delegate!.responds(to: #selector(UploadImageViewDelegate.upLoadImageDelete(_:index:))) {
                self.delegate?.upLoadImageDelete!(self, index: self.tag)
            }
        }
        
    }
}
