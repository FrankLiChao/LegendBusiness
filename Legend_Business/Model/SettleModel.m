//
//  SettleModel.m
//  legend_business_ios
//
//  Created by heyk on 16/3/1.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "SettleModel.h"

@implementation SettleModel

- (NSString*)company{
    if (_company == nil) {
        return @"";
    }
    return _company;
}

- (NSString*)contact_phone{
    if (_contact_phone == nil) {
        return @"";
    }
    return _contact_phone;
}

- (NSString*)operate{
    if (_operate == nil) {
        return @"";
    }
    return _operate;
}

- (NSString*)operate_name{
    if (_operate_name == nil) {
        return @"";
    }
    return _operate_name;
}

- (NSArray*)id_img{

    if(!_id_img) _id_img = [NSArray array];
    return _id_img;
}
- (NSArray*)license{
    
    if(!_license) _license = [NSArray array];
    return _license;
}
- (NSArray*)apitude{
    
    if(!_apitude) _apitude = [NSArray array];
    return _apitude;
}
- (NSArray*)other_apitude{
    
    if(!_other_apitude) _other_apitude = [NSArray array];
    return _other_apitude;
}



@end
