//
//  WeekBonusModel.h
//  legend_business_ios
//
//  Created by Frank on 2016/11/25.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeekBonusModel : NSObject

@property (nonatomic, strong)NSString *seller_id;//商家Id
@property (nonatomic, strong)NSString *endorse_days;//代言周期天数
@property (nonatomic, strong)NSString *endorse_money;//分红金额
@property (nonatomic, strong)NSString *status;//--状态：0.申请审核中，请勿重复提交 1.每月最多有一次申请机会，本月审核不通过，可再次提交 2.审核通过 4.本月没有申请更改代言周期
@property (nonatomic, strong)NSString *msg;//本月没有申请更改代言周期,每月最多有一次申请机会
@property (nonatomic, strong)NSString *is_endorse_days;//是否设置代言周期
@property (nonatomic, strong)NSString *is_endorse_money;//是否设置分红周期

+ (WeekBonusModel *)parseResponse:(id)response;

+ (WeekBonusModel *)parseWeekResponse:(id)response;
@end
