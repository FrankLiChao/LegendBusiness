//
//  AfterSaleListModel.m
//  legend_business_ios
//
//  Created by Frank on 2016/11/26.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "AfterSaleListModel.h"

@implementation AfterSaleListModel

+ (NSArray <AfterSaleListModel *> *)parseResponse:(id)response{
    NSArray *arr = [AfterSaleListModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"after_f_info"]];
    return arr;
}

@end
