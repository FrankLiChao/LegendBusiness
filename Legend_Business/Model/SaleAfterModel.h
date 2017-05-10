//
//  SaleAfterModel.h
//  legend_business_ios
//
//  Created by Frank on 2016/11/25.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaleAfterModel : NSObject

@property (nonatomic, strong)NSString *after_id;
@property (nonatomic, strong)NSString *user_id;
@property (nonatomic, strong)NSString *order_id;
@property (nonatomic, strong)NSString *after_num;
@property (nonatomic, strong)NSString *after_status;
@property (nonatomic, strong)NSString *after_type;
@property (nonatomic, strong)NSString *is_complete;
@property (nonatomic, strong)NSString *attr_id;
@property (nonatomic, strong)NSString *attr_name;
@property (nonatomic, strong)NSString *price;
@property (nonatomic, strong)NSString *consignee;
@property (nonatomic, strong)NSString *order_type;
@property (nonatomic, strong)NSString *mobile;
@property (nonatomic, strong)NSString *goods_name;
@property (nonatomic, strong)NSString *goods_thumb;
@property (nonatomic, strong)NSString *express_company;
@property (nonatomic, strong)NSString *express_num;
@property (nonatomic, strong)NSString *after_reason;
@property (nonatomic, strong)NSString *service_time;
@property (nonatomic, strong)NSString *end_tiem;
@property (nonatomic, strong)NSString *delivery_status;//发货状态 0 付款 1 发货
@property (nonatomic, strong)NSArray *after_img;

+ (NSArray <SaleAfterModel *> *)parseResponse:(id)response;

@end
