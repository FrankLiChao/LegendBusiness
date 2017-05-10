//
//  Product.m
//  legend
//
//  Created by heyk on 16/1/7.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "ProductModel.h"


@implementation BannerModel


@end


@implementation ProductAttributionModel


@end


@implementation ProductAttributionListModel



@end


@implementation ProductGalleryListModel



@end


@implementation ProductNotBuyAttrListModel



@end

@implementation ProductModel




//+ (NSValueTransformer *)buy_attr_listJSONTransformer  {
//    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass: [ProductAttributionListModel class]];
//}

@end


@implementation ProductAttrModel



@end

@implementation ProductDetailModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"goods_size" : @"ProductAttrModel",
             };
}



@end



@implementation ProductListModel



@end