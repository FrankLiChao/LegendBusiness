//
//  SystemInfoModel.m
//  legend_business_ios
//
//  Created by Frank on 2016/11/26.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "SystemInfoModel.h"

@implementation SystemInfoModel

+ (SystemInfoModel *)parseResponse:(id)response{
    if ([response isKindOfClass:[NSDictionary class]]) {//seller_share_info
        return [SystemInfoModel mj_objectWithKeyValues:[response objectForKey:@"system_info"]];
    }
    return [[SystemInfoModel alloc] init];
}

@end
