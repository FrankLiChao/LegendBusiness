//
//  AfterInforModel.m
//  legend_business_ios
//
//  Created by Frank on 2016/11/26.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "AfterInforModel.h"

@implementation AfterInforModel

+ (AfterInforModel *)parseResponse:(id)response{
    if ([response isKindOfClass:[NSDictionary class]]) {//seller_share_info
        return [AfterInforModel mj_objectWithKeyValues:[response objectForKey:@"after_info"]];
    }
    return [[AfterInforModel alloc] init];
}

@end
