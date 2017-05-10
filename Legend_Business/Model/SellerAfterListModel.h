//
//  SellerAfterListModel.h
//  legend_business_ios
//
//  Created by heyk on 16/3/4.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductModel.h"




@interface SellerAfterListModel : NSObject

@property (nonatomic,strong)NSString *after_id;
@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *order_id;

@property (nonatomic,strong)NSString *after_num;

@property (nonatomic,strong)NSString *after_reason;
@property (nonatomic,strong)NSString *refuse_reason;
@property (nonatomic,strong)NSString *create_time;
@property (nonatomic,strong)NSArray  *after_img;
@property (nonatomic,strong)NSString *is_complete;//"是否完成"，(1：完成；2：未完成；)

@property (nonatomic,strong)NSString *after_type;//售后类型（1：退货；2：换货；）
@property (nonatomic,strong)NSString *apply_time;
@property (nonatomic,strong)NSString *modifi_time;
@property (nonatomic,strong)NSString *consignee;
@property (nonatomic,strong)NSString *mobile;
@property (nonatomic,strong)NSString *order_sn;
@property (nonatomic,strong)NSString *goods_thumb;
@property (nonatomic,strong)NSString *express_company;
@property (nonatomic,strong)NSString *express_num;
@property (nonatomic,strong)NSString *order_type;
@property (nonatomic,strong)NSString *return_addr;

- (ProuductType)goodsType;

@end
