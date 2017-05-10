//
//  LocationSever.m
//  legend
//
//  Created by msb-ios-dev on 15/10/30.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import "LocationSever.h"
#import "EncryptionUserDefaults.h"
#import "DefineKey.h"
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>



@import MapKit;


@interface LocationSever()<CLLocationManagerDelegate,BMKGeoCodeSearchDelegate,BMKGeneralDelegate>{
    
    __block BOOL         bGecoding;
    BMKGeoCodeSearch    *bdGeocoder;
    
}

@property (nonatomic,strong)NSString *city;
@property (nonatomic,strong)NSString *area;
@property (nonatomic,strong)NSString *street;
@property (nonatomic,strong)CLLocationManager   *locationManager;
@property (nonatomic,strong)BMKMapManager       *manger;
@property (nonatomic,copy)LocationInitBlock     initBlock;

@end

@implementation LocationSever


+ (LocationSever *)sharedInstance
{
    static LocationSever *localSever = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        localSever = [[self alloc] init];
        localSever.manger = [[BMKMapManager alloc] init];
    });
    return localSever;

}

- (void)initLocation:(LocationInitBlock)block{
    
    [self.manger start:BADIDU_LOACTION_API_KEY generalDelegate:self];
    self.initBlock = block;
    if ([CLLocationManager locationServicesEnabled]) {
        if (!_locationManager) {
            self.locationManager = [[CLLocationManager alloc] init];
            _locationManager.distanceFilter = 1000.0f;
            _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
            _locationManager.delegate = self;
        }
        
        
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined && [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && [_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
            [_locationManager requestWhenInUseAuthorization];
        }
     
        self.initBlock(YES);
    }
    else {
        
        self.initBlock(NO);
    }

}



-(void)update{
    
 
    [self.manger start:BADIDU_LOACTION_API_KEY generalDelegate:self];
    
    if ([CLLocationManager locationServicesEnabled]) {
        if (!_locationManager) {
            self.locationManager = [[CLLocationManager alloc] init];
            _locationManager.distanceFilter = 1000.0f;
            _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
            _locationManager.delegate = self;
        }
        
        
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined && [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && [_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
            [_locationManager requestWhenInUseAuthorization];
        }
        
      //  [_locationManager startUpdatingLocation];
    }
    else {
        
     
    }
    
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    
    
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations

{
    
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    
    CLLocation *currentLocation = [locations lastObject];
    
    if (bGecoding) {
        return;
    }
    bGecoding = YES;
    //根据经纬度反向地理编译出地址信息
    
    if (!bdGeocoder) {
        bdGeocoder =[[BMKGeoCodeSearch alloc]init];
        bdGeocoder.delegate = self;
    }
    
    
    BMKReverseGeoCodeOption *reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeOption.reverseGeoPoint = currentLocation.coordinate;
    
    [bdGeocoder reverseGeoCode:reverseGeoCodeOption];
    
    reverseGeoCodeOption = nil;
    
    [manager stopUpdatingLocation];
    [self.manger stop];
    
}

- (void)locationManager:(CLLocationManager *)manager

       didFailWithError:(NSError *)error {
    
    if (error.code == kCLErrorDenied) {
        
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
        
    }
    
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if (status == kCLAuthorizationStatusAuthorizedAlways||
        status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
       // [self update];
    }
}


- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    bGecoding = NO;
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        BMKAddressComponent *addressDetail = result.addressDetail;
        
        //将获得的所有信息显示到label上
     

        //NSString *province =  addressDetail.province?addressDetail.province:@"";
        self.city = addressDetail.city?addressDetail.city:@"";
        self.area = addressDetail.district?addressDetail.district:@"";
        
        self.street = addressDetail.streetName?addressDetail.streetName:@"";
        
        //  NSString *locationStr = [NSString stringWithFormat:@"%@%@%@%@",province,city,area,street];
        
       /* NSString *locationStr = [NSString stringWithFormat:@"%f%f",result.location.latitude,result.location.longitude];
        NSString *oldLocationStr =  [[NSUserDefaults standardUserDefaults] objectForKey:kUserAddress];
        
        RecieveAddressModel *model = [RecieveAddressModel new];
        model.provice = province;
        model.city = self.city;
        model.area = self.area;
        model.street = self.street;
        model.lng = [NSNumber numberWithFloat:result.location.longitude];
        model.lat = [NSNumber numberWithFloat:result.location.latitude];
        
        NSData *addrData = [model encodedToData];
        
        [[NSUserDefaults standardUserDefaults] setObject:addrData forKey:kUserAddressModel];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (_locationBlock) {
            _locationBlock(model,YES);
            _locationBlock = nil;
        }
        
        
        if ((!oldLocationStr||![locationStr isEqualToString:oldLocationStr]) ) {
            
            [[NSUserDefaults standardUserDefaults] setObject:locationStr forKey:kUserAddress];
            WebEngine *engine = [[WebEngine alloc] init];
            engine.delegate = self;
            [engine changeUserAddressWithProvince:province City:self.city Area:self.area Street:self.street latitus:result.location.latitude longtigue:result.location.longitude];

        }*/
        
    }

}

- (void)onGetPermissionState:(int)iError{
//    if(self.locationBlock){
//        
//        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kUserAddressModel];
//        
//        if (data) {
//           RecieveAddressModel *model = [RecieveAddressModel   new];
//            [model initWithEncodeData:data];
//              _locationBlock(model,NO);
//        }
//        else _locationBlock(nil,NO);
//        _locationBlock = nil;
//    }
}



@end
