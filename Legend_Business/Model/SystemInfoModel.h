//
//  SystemInfoModel.h
//  legend_business_ios
//
//  Created by Frank on 2016/11/26.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemInfoModel : NSObject

@property (nonatomic, strong)NSString *service_time;//--服务器时间
@property (nonatomic, strong)NSString *end_tiem;//--截止时间
@property (nonatomic, strong)NSString *after_status;//--当前售后状态
@property (nonatomic, strong)NSString *notice_time;//日期
@property (nonatomic, strong)NSString *is_complete;//--完成状态 1 完成 2未完成
@property (nonatomic, strong)NSString *refund_money;//退款金额

+ (SystemInfoModel *)parseResponse:(id)response;

@end
