//
//  SaleAfterModel.m
//  legend_business_ios
//
//  Created by Frank on 2016/11/25.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "SaleAfterModel.h"

@implementation SaleAfterModel

+ (NSArray <SaleAfterModel *> *)parseResponse:(id)response{
    NSArray *arr = [SaleAfterModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"list"]];
    return arr;
}

@end
