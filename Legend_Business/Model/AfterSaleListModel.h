//
//  AfterSaleListModel.h
//  legend_business_ios
//
//  Created by Frank on 2016/11/26.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AfterSaleListModel : NSObject

@property (nonatomic, strong)NSString *create_time;//--时间
@property (nonatomic, strong)NSString *after_status;//--售后状态 2.商家同意售后 3.买家发货 4.商家收货 5.商家拒绝 6.用户取消 7.换货 8.系统自动取消 9.系统自动退款
@property (nonatomic, strong)NSString *express_company;//--用户发货物流公司
@property (nonatomic, strong)NSString *express_num;//--用户发货物流单号
@property (nonatomic, strong)NSString *refuse_reason;//--拒绝原因
@property (nonatomic, strong)NSString *money_refund;//--退款金额
@property (nonatomic, strong)NSString *flag;//--买家还是卖家 1 卖家 0 买家 2系统

+ (NSArray <AfterSaleListModel *> *)parseResponse:(id)response;

@end
