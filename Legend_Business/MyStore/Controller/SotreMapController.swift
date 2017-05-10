//
//  SotreMapController.swift
//  legend_business_ios
//
//  Created by msb-ios-dev on 16/2/20.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit
import MapKit

class SotreMapController: BaseViewController,BMKGeoCodeSearchDelegate,BMKGeneralDelegate {
    
    
    @IBOutlet var mapView : MKMapView?
    @IBOutlet var addrBarHeight : NSLayoutConstraint?
    @IBOutlet var addrTitleLabel : UILabel?
    @IBOutlet var addrDetailLabel : UILabel?
    @IBOutlet var fastLocalButton : UIButton?
    @IBOutlet var spinder : UIActivityIndicatorView?
    
    var contentModel : AnyObject?
    
    var oldAddress : String?
    var oldCoordinate =  CLLocationCoordinate2DMake(-1, -1)
    
    var coordinate : CLLocationCoordinate2D? //修改后的经纬度
    var addressModel : AddressModel? //修改后的地址
    
    var semaphore = DispatchSemaphore(value: 0)
    
    var BDGeocoder : BMKGeoCodeSearch!
    
    var currentAnnotation : MyAnnotation?
    var oldAnnotation : MyAnnotation?
    
    
    deinit {
        
        BDGeocoder.delegate = nil
        BDGeocoder = nil
        
        self.mapView?.delegate = nil
        
        print("SotreMapController 释放")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "店铺地址"
        self.setBackButton()
        self.addRightBarItem(withTitle: "完成", method: #selector(SotreMapController.clickSave))
        
        self.addrBarHeight?.constant = Configure.SYS_UI_SCALE(60)
        addrTitleLabel?.font = UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(14))
        addrDetailLabel?.font =  UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(12))
        fastLocalButton?.titleLabel!.font =  UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(14))
        addrDetailLabel?.text = oldAddress//"\(oldAddress?.province)" + "\(oldAddress?.city)" + "\(oldAddress?.area)" + "\(oldAddress?.street)"
        
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(SotreMapController.longPressAction(_:)))
        longPress.minimumPressDuration = 0.5
        longPress.allowableMovement = 10.0;
        mapView?.addGestureRecognizer(longPress)
        
        weak var weakSelf = self
        LocationSever.sharedInstance().initLocation { (_sucess:Bool) -> Void in
            
            let sucess = _sucess
            if sucess {
              //  weakSelf!.mapView?.showsUserLocation = true
                if (weakSelf!.oldCoordinate.longitude < 0 && weakSelf!.oldCoordinate.latitude < 0) && weakSelf!.oldAddress == nil{//没有传地址
                    
                    weakSelf!.mapView?.userTrackingMode = .follow
                    
                    weakSelf!.showCurrentLoation()
                    
                }
            }
        }
        
        BDGeocoder = BMKGeoCodeSearch()
        BDGeocoder.delegate = self;
        
        self.perform(#selector(SotreMapController.showOldAddress), with: nil, afterDelay: 0.5)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func longPressAction(_ gesture: UIGestureRecognizer){//添加新地址
        
        if gesture.state == .ended{ return }
        
        let touchPoint = gesture.location(in: mapView)
        let touchMapCoordinate = mapView?.convert(touchPoint, toCoordinateFrom: mapView)
        
        self.coordinate = touchMapCoordinate
        
        self.mapView?.removeAnnotations((self.mapView?.annotations)!)
        currentAnnotation = MyAnnotation(coordinates: coordinate!, title: "", subTitle: "")
        mapView!.addAnnotation(currentAnnotation!)
        
        self.addrDetailLabel?.text = nil
        spinder!.startAnimating()
        
        weak var weakSelf = self
        
        DefaultService.myCustomQueque().async { () -> Void in
            
            let reverseGeoCodeOption = BMKReverseGeoCodeOption()
            reverseGeoCodeOption.reverseGeoPoint = weakSelf!.coordinate!
            weakSelf!.BDGeocoder.reverseGeoCode(reverseGeoCodeOption)
        }
        
    }
    
    func showOldAddress(){
        
        if self.oldAddress == nil {
            
            if (self.oldCoordinate.longitude >= 0 && self.oldCoordinate.latitude >= 0){//传了个经纬度
                
                self.showHud(in: self.view , hint: "定位中")
                
                let reverseGeoCodeOption = BMKReverseGeoCodeOption()
                reverseGeoCodeOption.reverseGeoPoint = self.oldCoordinate
                BDGeocoder.reverseGeoCode(reverseGeoCodeOption)
            }
        }
        else if(self.oldCoordinate.longitude < 0 && self.oldCoordinate.latitude < 0){//传了个地址，没传经纬度
            
            self.showHud(in: self.view , hint: "定位中")
            
            let geoCodeOption = BMKGeoCodeSearchOption()
            geoCodeOption.address = oldAddress// "\(oldAddress?.province)" + "\(oldAddress?.city)" + "\(oldAddress?.area)" + "\(oldAddress?.street)"
            
            
            print(geoCodeOption.address)
            let bSuccess =  BDGeocoder.geoCode(geoCodeOption)
            if !bSuccess {
            
                self .hideHud()
            }
            
        }
    }
    
    func showCurrentLoation(){
        
        
        DefaultService.myCustomQueque().async(execute: { () -> Void in
            
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                self.mapView?.removeAnnotations((self.mapView?.annotations)!)
                
                self.mapView?.showsUserLocation = true
                self.mapView?.userTrackingMode = .follow
                
                self.showHud(in: self.view, hint: "定位中...")
                
                
            })
            
            let _ = self.semaphore.wait(timeout: DispatchTime.distantFuture)
            
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                
                let reverseGeoCodeOption = BMKReverseGeoCodeOption()
                reverseGeoCodeOption.reverseGeoPoint = self.mapView!.userLocation.coordinate
                
                
                print("\(self.mapView!.userLocation.coordinate.latitude)" + "," + "\(self.mapView!.userLocation.coordinate.longitude)")
               let bSuccess =   self.BDGeocoder.reverseGeoCode(reverseGeoCodeOption)
               
                if bSuccess {
                
                    
                    self .hideHud()
                }
                else{
                     self .hideHud()
                     self.showHint("地址解析错误")
                }
                self.coordinate = self.mapView!.userLocation.coordinate
                
            })
        })
        
    }
    
    func clickSave(){
        if contentModel != nil && contentModel!.isKind(of: UserInfoModel.self) && self.addressModel != nil{
            let model = contentModel as! UserInfoModel
            let str = addressModel?.mj_JSONString()
            
            weak var weakSelf = self
            self.showHud(in: self.view, hint: "保存中，请稍后")
            let type: ChangeUserInfoType = ChangeUserInfoType_Address
            self.changeUsrInfo(type, value: str, comple: { (bSuccess, message) -> Void in
                weakSelf?.hideHud()
                if bSuccess {
                    weakSelf?.showHint("修改地址成功")
                    model.address = weakSelf?.addrDetailLabel?.text
//                    SaveEngine.saveUserInfo(model)
                    let _ = weakSelf?.navigationController?.popViewController(animated: true)
                } else {
                    weakSelf?.showHint(message)
                }
            })
            
        } else {     let _ = self.navigationController?.popViewController(animated: true)  }//地址没有修改
    }
    
    @IBAction func clickFastLocation(){
        
        showCurrentLoation()
        
    }
    
    // MARK: - mapView delegate
    func mapView(_ mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation){
        
        
        
    }
    func mapView(_ mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        
        semaphore.signal()
        
        if  (currentAnnotation?.coordinate.longitude == annotation.coordinate.longitude && currentAnnotation?.coordinate.latitude == annotation.coordinate.latitude) || (oldAnnotation?.coordinate.longitude == annotation.coordinate.longitude && oldAnnotation?.coordinate.latitude == annotation.coordinate.latitude) {
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Loation") as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Loation")
            }
            
            annotationView!.canShowCallout = true;
            
            if #available(iOS 9.0, *) {
                annotationView!.pinTintColor = UIColor.red
            } else {
                annotationView!.pinColor = .red
            }
            
            annotationView!.animatesDrop = true;
            annotationView!.isHighlighted = true;
            annotationView!.isDraggable = false;
            
            
            return annotationView
        }
        return nil
    }
    
    
    //MARK -BMKGeoCodeSearchDelegate
    
    func onGetGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        self .hideHud()
        
        if error == BMK_SEARCH_NO_ERROR {
            
            self.oldCoordinate = result.location
            oldAnnotation = MyAnnotation(coordinates: result.location, title: result.address, subTitle: result.address)
            mapView!.addAnnotation(oldAnnotation!)
            
            mapView?.setRegion(MKCoordinateRegion(center: result.location, span: MKCoordinateSpanMake(0.01, 0.01)), animated: true)
        }
        
        
    }
    
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        self .hideHud()
        print("address = \(result.address)")
        
        if error == BMK_SEARCH_NO_ERROR {
            if result.location.latitude == self.oldCoordinate.latitude && result.location.longitude == self.oldCoordinate.longitude {
                
                self.addrDetailLabel?.text = result.address;
                
                self.oldAddress = result.address
                
                oldAnnotation = MyAnnotation(coordinates: result.location, title: result.address, subTitle: nil)
                mapView!.addAnnotation(oldAnnotation!)
                
                mapView?.setRegion(MKCoordinateRegion(center: result.location, span: MKCoordinateSpanMake(0.01, 0.01)), animated: true)
            }
            else{
                
                self.addressModel = AddressModel()
                addressModel?.province = result.addressDetail.province
                addressModel?.city = result.addressDetail.city
                addressModel?.area = result.addressDetail.district
                addressModel?.street = result.addressDetail.streetName
                addressModel?.lng = NSNumber(value: coordinate!.longitude as Double)
                addressModel?.lat = NSNumber(value: coordinate!.latitude as Double)
                
                
                if spinder!.isAnimating {//正在找寻新地址
                    
                    spinder!.stopAnimating()
                    self.addrDetailLabel?.text = result.address;
                    
                }
                else{
                    
                    
                    self.addrDetailLabel?.text = result.address;
                    
                    currentAnnotation = MyAnnotation(coordinates: result.location, title: result.address, subTitle: result.address)
                    mapView!.addAnnotation(currentAnnotation!)
                }
                
            }
        }
        
    }
}
