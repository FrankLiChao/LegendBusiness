//
//  GoodsMoreView.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/24.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

@objc protocol GoodsMoreViewDelegate: NSObjectProtocol {


    @objc optional func clickEditButton(_ targete: GoodsMoreView?,index: IndexPath);
    @objc optional func clickDeleteButton(_ targete: GoodsMoreView?,index: IndexPath);
    @objc optional func clickDownButton(_ targete: GoodsMoreView?,index: IndexPath);
    @objc optional func clickExtensionButton(_ targete: GoodsMoreView?,index: IndexPath);
    @objc optional func clickShelvesButton(_ targete: GoodsMoreView?,index: IndexPath);
    
}

class GoodsMoreView: UIView {

    var contentView : UIView?
    var targetPoint  = CGPoint(x: 0, y: 0)
    var currentIndex : IndexPath?
    var bShelves : Bool = false //上架
    var bShowEdit:Bool  = true //是否显示编辑按钮
    
    weak var delegate : GoodsMoreViewDelegate?
    

    convenience init(targetPoint : CGPoint, delegate: GoodsMoreViewDelegate?, index: IndexPath){
        
        self.init(frame: UIScreen.main.bounds)
    
        self.backgroundColor = UIColor.clear
        
        self.targetPoint = targetPoint
        
        self.delegate = delegate
        self.currentIndex = index

        let tap = UITapGestureRecognizer(target: self, action: #selector(GoodsMoreView.tapBack))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
        
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(GoodsMoreView.tapBack))
        self.addGestureRecognizer(pan)
        
        bShowEdit = true;
    
    }
    
    
    func tapBack(){
    
        self.removeFromSuperview()
    }
    func showWithoutEdit(){
        
        bShowEdit = false;
        self.show()
    }
    
    func show(){
    
   
        var contentW : CGFloat = 235
        if  !bShowEdit {
        
            contentW = 185
        }
        contentView = UIView(frame: CGRect(x: targetPoint.x - contentW - 5,y: targetPoint.y-30,width: contentW,height: 50))
        contentView?.backgroundColor = UIColor.clear
        self.addSubview(contentView!)
        
        let backImage = UIImage(named: "goods_more_back")
        
        let backView = UIImageView(image: backImage?.stretchableImage(withLeftCapWidth: 2, topCapHeight:10))
        backView.frame = contentView!.bounds
        contentView!.addSubview(backView)
        
        var buttonWidth = (contentW - 5 - 30)/3
        
        if bShowEdit {
        
            buttonWidth = (contentW - 5 - 30)/4
        }
        
        let previewButton = UIButton(type: .custom)
        previewButton.frame = CGRect(x: 15, y: 0, width: 0, height: 0)
     
        if bShowEdit {
        
            
            previewButton.frame = CGRect(x: 15, y: 0, width: CGFloat(buttonWidth), height: 50)
            previewButton.addTarget(self, action: #selector(GoodsMoreView.clicEdit(_:)), for: .touchUpInside)
            previewButton.setTitleColor(UIColor.white, for: UIControlState())
            previewButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            previewButton.setUpImageDownTitle(UIImage(named: "编辑")!, title: "编辑")
            
            contentView?.addSubview(previewButton)
            
        }
        
   
        
        let downButton = UIButton(type: .custom)
        
        
        if bShelves {
    
            downButton.frame = CGRect(x: previewButton.frame.size.width + previewButton.frame.origin.x, y: 0, width: CGFloat(buttonWidth), height: 50)
            downButton.addTarget(self, action: #selector(GoodsMoreView.clickShelves(_:)), for: .touchUpInside)
            downButton.setTitleColor(UIColor.white, for: UIControlState())
            downButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            downButton.setUpImageDownTitle(UIImage(named: "上架")!, title: "上架")
            
            contentView?.addSubview(downButton)
        }
        else{
       
            downButton.frame = CGRect(x: previewButton.frame.size.width + previewButton.frame.origin.x, y: 0, width: CGFloat(buttonWidth), height: 50)
            downButton.addTarget(self, action: #selector(GoodsMoreView.clickDown(_:)), for: .touchUpInside)
            downButton.setTitleColor(UIColor.white, for: UIControlState())
            downButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            downButton.setUpImageDownTitle(UIImage(named: "下架")!, title: "下架")
            
            contentView?.addSubview(downButton)
        }
        
        
        
        
     
        
        let extensionButton = UIButton(type: .custom)
        extensionButton.frame = CGRect(x: downButton.frame.size.width + downButton.frame.origin.x, y: 0, width: CGFloat(buttonWidth), height: 50)
        extensionButton.addTarget(self, action: #selector(GoodsMoreView.clickExtension(_:)), for: .touchUpInside)
        extensionButton.setTitleColor(UIColor.white, for: UIControlState())
        extensionButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        extensionButton.setUpImageDownTitle(UIImage(named: "推广")!, title: "推广")
        
        contentView?.addSubview(extensionButton)
        
        
        let deleteButton = UIButton(type: .custom)
        deleteButton.frame = CGRect(x: extensionButton.frame.size.width + extensionButton.frame.origin.x, y: 0, width: CGFloat(buttonWidth), height: 50)
        deleteButton.addTarget(self, action: #selector(GoodsMoreView.clickDelete(_:)), for: .touchUpInside)
        deleteButton.setTitleColor(UIColor.white, for: UIControlState())
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        deleteButton.setUpImageDownTitle(UIImage(named: "删除白")!, title: "删除")
        
        contentView?.addSubview(deleteButton)
        
        UIApplication.shared.keyWindow?.addSubview(self)

    }
    
    
    func clicEdit(_ button : UIButton?){
    
        if self.delegate != nil && delegate!.responds(to: #selector(GoodsMoreViewDelegate.clickEditButton(_:index:))) {
        
            delegate!.clickEditButton!(self, index: currentIndex!)
        }
        
        self.tapBack()
    
    }
    func clickDown(_ button : UIButton?){
        if self.delegate != nil && delegate!.responds(to: #selector(GoodsMoreViewDelegate.clickDownButton(_:index:))) {
            
            delegate!.clickDownButton!(self, index: currentIndex!)
        }
        self.tapBack()
    }
    func clickDelete(_ button : UIButton?){
        
        if self.delegate != nil && delegate!.responds(to: #selector(GoodsMoreViewDelegate.clickDeleteButton(_:index:))) {
            
            delegate!.clickDeleteButton!(self, index: currentIndex!)
        }
        self.tapBack()
    }
    
    func clickExtension(_ button : UIButton?){
        
        if self.delegate != nil && delegate!.responds(to: #selector(GoodsMoreViewDelegate.clickExtensionButton(_:index:))) {
            delegate!.clickExtensionButton!(self, index: currentIndex!)
        }
        self.tapBack()
    
    }
    
    func clickShelves(_ button : UIButton?){
        if self.delegate != nil && delegate!.responds(to: #selector(GoodsMoreViewDelegate.clickShelvesButton(_:index:))) {
            delegate!.clickShelvesButton!(self, index: currentIndex!)
        }
        self.tapBack()
    }
    
    
}
