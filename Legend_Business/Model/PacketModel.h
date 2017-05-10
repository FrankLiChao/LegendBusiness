//
//  PacketModel.h
//  legend_business_ios
//
//  Created by heyk on 16/3/8.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PacketModel : NSObject

@property (nonatomic,strong) NSString *money; //余额
@property (nonatomic,strong) NSString *freeze_money;//--交易中的金额（即冻结的金额）
@property (nonatomic,strong) NSString *withdraw_money;//--已提现的金额
@property (nonatomic,strong) NSNumber *is_bundle_card;//是否绑定过银行卡


@end


typedef enum {

    CashStatusType_Doing = 0,//提现中
    CashStatusType_Success = 1,//提现成功
    CashStatusType_Failed = 2,//提现失败

}CashStatusType;

@interface CashModel : NSObject


@property (nonatomic,strong) NSString *money;//--提现金额）
@property (nonatomic,strong) NSString *withdraw_id;//-提现id
@property (nonatomic,strong) NSString *apply_time;//提现时间
@property (nonatomic,strong) NSString *logo;//银行icon
@property (nonatomic,strong) NSString *status;//状态

@property (nonatomic,strong) NSString *goods_amount;//订单商品金额
@property (nonatomic,strong) NSString *goods_name;
@property (nonatomic,strong) NSString *order_id;
@property (nonatomic,strong) NSString *user_avatar;
@property (nonatomic,strong) NSString *user_name; //下单人名称
@property (nonatomic,strong) NSString *create_time;//订单创建时间



- (NSMutableAttributedString*)createTimeStr;
- (NSMutableAttributedString*)applyTimeStr;

- (CashStatusType)cashStatus;

@end


@interface CashHistoryModel : NSObject


@property (nonatomic,strong) NSString *month;
@property (nonatomic,strong) NSArray <CashModel*> *list;


- (NSString*)monthStr;

@end


