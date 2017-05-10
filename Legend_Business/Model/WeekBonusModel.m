//
//  WeekBonusModel.m
//  legend_business_ios
//
//  Created by Frank on 2016/11/25.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "WeekBonusModel.h"

@implementation WeekBonusModel

+ (WeekBonusModel *)parseResponse:(id)response{
    if ([response isKindOfClass:[NSDictionary class]]) {//seller_share_info
        return [WeekBonusModel mj_objectWithKeyValues:[response objectForKey:@"seller_share_info"]];
    }
    return [[WeekBonusModel alloc] init];
}

+ (WeekBonusModel *)parseWeekResponse:(id)response{
    if ([response isKindOfClass:[NSDictionary class]]) {//seller_share_info
        return [WeekBonusModel mj_objectWithKeyValues:[response objectForKey:@"share_detail"]];
    }
    return [[WeekBonusModel alloc] init];
}

@end
