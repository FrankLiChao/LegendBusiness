//
//  GoodsCategoryModel.m
//  legend_business_ios
//
//  Created by heyk on 16/3/2.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "GoodsCategoryModel.h"
#import "MJExtension.h"

@implementation GoodsCategoryModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"child" : @"GoodsCategoryModel",
             };
}


@end


@implementation SellerCategoryModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"child" : @"SellerCategoryModel",
             };
}

@end

@implementation CategoryModel
@end