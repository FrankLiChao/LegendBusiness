//
//  UitlCommon.swift
//  Legend_Business
//
//  Created by heyk on 16/2/15.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit
import Foundation



class UitlCommon: NSObject {

    @objc class func UIColorFromRGB(_ value: NSInteger) -> UIColor{
    
        let color = UIColor(red: ((CGFloat)((value & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((value & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(value & 0xFF))/255.0, alpha:1)
        return color
    }
    
    @objc class  func setFlat(view v: UIView, radius: CGFloat) {
        
        let downButtonLayer = v.layer
        downButtonLayer.masksToBounds = true
        downButtonLayer.cornerRadius = radius
    }
    
    @objc class func setFlat(view v: UIView, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        
        let downButtonLayer = v.layer
        downButtonLayer.masksToBounds = true
        downButtonLayer.cornerRadius = radius
        downButtonLayer.borderColor = borderColor.cgColor
        downButtonLayer.borderWidth = borderWidth
    }
    
    @objc class func setDashedFlat(view v: UIView, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat, bounds: CGRect) {//虚线
        

        let downButtonLayer = v.layer
        downButtonLayer.masksToBounds = true
        downButtonLayer.cornerRadius = radius
     
        let _border = CAShapeLayer()
        _border.strokeColor = borderColor.cgColor;
        
        _border.fillColor = nil;
        
        _border.path = UIBezierPath(rect: bounds).cgPath
        
        _border.frame = bounds
        
        _border.lineWidth = borderWidth
        
        _border.lineCap = CAShapeLayerLineCap(rawValue: "round")
        
        _border.lineDashPattern = [NSNumber(value: 2 as Int32),NSNumber(value: 2 as Int32)]
        
        downButtonLayer.addSublayer(_border)

    }

    @objc class func isNull( _ value: String) -> Bool {

        let str : NSString = NSString(string: value)
        if (str.isEqual( to: "(null)")) {
            return true;
        }
        
        let clearSpace = str.replacingOccurrences(of: " ", with: "")
        let clearSpace1 : NSString  = clearSpace.replacingOccurrences(of: "\n", with: "") as NSString
        if clearSpace1.isEqual(to: "") || str.length == 0 {
            
            return true
        }
        
        return false;

    }
    
    @objc class func isVaildePhoneNum(_ phoneNum: String) -> Bool{
    
        let mobileRegex = "^(0|86|17951)?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$"
        let mobileTest = NSPredicate(format:"SELF MATCHES %@",mobileRegex)
        
        return mobileTest.evaluate(with: phoneNum)
    }
    
    @objc class func closeAllKeybord(){
    
    
        for window in UIApplication.shared.windows {
        
             UitlCommon.searchInputViewAndClose(window.subviews as NSArray)
       
        }
    }
    
    
    @objc class func searchInputViewAndClose(_ viewArray : NSArray){
    
        for view in viewArray{
        
            if (view as AnyObject).isKind(of: UITextField.self) || (view as AnyObject).isKind(of: UITextView.self) {
                
                let _ = (view as AnyObject).resignFirstResponder()
            }
            if (view as AnyObject).subviews.count > 0{
                
                UitlCommon.searchInputViewAndClose((view as AnyObject).subviews as NSArray)
            }
        }
    
    }
    
    /*
    class func showPicAction(vc :UIViewController,delegate:protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>? ){
    
        

            if #available(iOS 8.0, *) {
                let sheet = UIAlertController(title: "选中图片", message: nil, preferredStyle: .ActionSheet)
                
                let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler:nil)
                let deleteAction = UIAlertAction(title: "拍照", style: .Default, handler: { action -> Void in
                    
                    let pickVC = UitlCommon.choosePictur(.Camera, supVc: vc)
                    pickVC.delegate = delegate;
                })
                
                let archiveAction = UIAlertAction(title: "从手机相册获取", style: .Default, handler: { action -> Void in
                    
                    let pickVC = UitlCommon.choosePictur(.PhotoLibrary, supVc: vc)
                    pickVC.delegate = delegate;
                    
                })
                
                sheet.addAction(cancelAction)
                sheet.addAction(deleteAction)
                sheet.addAction(archiveAction)
                
                vc.presentViewController(sheet, animated: true, completion: nil)
                
            } else {
                
                
                let sheet = UIActionSheet(title: "选中图片", delegate: nil, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
                
                sheet.addButtonWithTitle("拍照")
                sheet.addButtonWithTitle("从手机相册获取")
                
                sheet.showInView(vc.view)
            }  
  


        
    }
    
    class func choosePictur(model : UIImagePickerControllerSourceType, supVc: UIViewController) -> UIImagePickerController{
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = model
        imagePicker.allowsEditing = true
      //  imagePicker.delegate = supVc
      //  imagePicker.videoQuality = .TypeMedium
        supVc.presentViewController(imagePicker, animated: true, completion: nil)
      
        return imagePicker
    }
    */
    
    //用于作输入限制
    @objc class func getCurrentTextFiledText(_ currentStr: String,newText: String) ->String{
    
        let newStr = NSMutableString(string: currentStr)
        if newText == "" {
        
            if UitlCommon.isNull(currentStr){
                
                return newStr as String
            }
            else { newStr.replaceCharacters(in: NSMakeRange(newStr.length - 1, 1), with: "")}
        }
        else {
            newStr.append(newText)
        }
        
        return newStr as String
    }
    
    @objc class func createImageWithColor(_ color: UIColor) -> UIImage{
    
        let rect = CGRect(x: 0.0, y: 0.0, width: 2.0, height: 2.0)//CGRect
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext() //CGContextRef
        context?.setFillColor(color.cgColor)
        context?.fill(rect);
        let theImage = UIGraphicsGetImageFromCurrentImageContext()//UIImage
        UIGraphicsEndImageContext();
        
        return theImage!;
    }
    
    @objc class  func setKeyStringAttr(_ keyString: String?,fullStr: String,keyColor: UIColor,otherColor: UIColor) -> NSMutableAttributedString{
        
        var key : String!
        if keyString == nil ||  UitlCommon.isNull(keyString!){
             key = " "
        }
        else {
        
           key = keyString!
        }
        
        let regex = try! NSRegularExpression(pattern: key, options: .caseInsensitive)
        let matches  = regex.matches(in: fullStr, options: .reportCompletion, range: NSMakeRange(0, (fullStr as NSString).length))
        
        let string = NSMutableAttributedString(string: fullStr)
        string.addAttribute(NSAttributedString.Key.foregroundColor, value: otherColor, range:  NSMakeRange(0, (fullStr as NSString).length))
    

        for (_,match) in matches.enumerated() {
        
            let matchRange = match.range
            string.addAttribute(NSAttributedString.Key.foregroundColor, value: keyColor, range: matchRange)
        }
        
        return string;
        
    }

    
}
