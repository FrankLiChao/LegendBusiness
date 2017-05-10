//
//  GoodsCategoryModel.h
//  legend_business_ios
//
//  Created by heyk on 16/3/2.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GoodsCategoryModel : NSObject

@property (nonatomic,strong)NSString *cat_id;
@property (nonatomic,strong)NSString *cat_name;
@property (nonatomic,strong)NSString *parent_id;
@property (nonatomic,strong)NSString *lev;
@property (nonatomic,strong)NSArray<GoodsCategoryModel*> *child;

@end


@interface SellerCategoryModel : NSObject

@property (nonatomic,strong)NSString *seller_cat_id;
@property (nonatomic,strong)NSString *seller_cat_name;
@property (nonatomic,strong)NSString *parent_id;
@property (nonatomic,strong)NSString *lev;
@property (nonatomic,strong)NSArray<SellerCategoryModel*> *child;

@end

@interface CategoryModel : NSObject

@property (nonatomic,strong)NSNumber *cat_id;
@property (nonatomic,strong)NSString *cat_name;


@end