//
//  goodsModel.m
//  legend_business_ios
//
//  Created by Frank on 2016/11/26.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "AfterGoodsModel.h"

@implementation AfterGoodsModel

+ (AfterGoodsModel *)parseResponse:(id)response{
    if ([response isKindOfClass:[NSDictionary class]]) {//seller_share_info
        return [AfterGoodsModel mj_objectWithKeyValues:[response objectForKey:@"goods_info"]];
    }
    return [[AfterGoodsModel alloc] init];
}

@end
