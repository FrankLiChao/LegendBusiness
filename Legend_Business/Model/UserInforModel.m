//
//  userInforModel.m
//  legend_business_ios
//
//  Created by Frank on 2016/11/26.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "UserInforModel.h"

@implementation UserInforModel

+ (UserInforModel *)parseResponse:(id)response{
    if ([response isKindOfClass:[NSDictionary class]]) {//seller_share_info
        return [UserInforModel mj_objectWithKeyValues:[response objectForKey:@"user_info"]];
    }
    return [[UserInforModel alloc] init];
}

@end

@implementation SellerInfoModel

+ (SellerInfoModel *)parseResponse:(id)response{
    if ([response isKindOfClass:[NSDictionary class]]) {//seller_share_info
        return [SellerInfoModel mj_objectWithKeyValues:[response objectForKey:@"seller_info"]];
    }
    return [[SellerInfoModel alloc] init];
}

@end
