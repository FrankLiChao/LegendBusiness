//
//  OrderListModel.h
//  legend_business_ios
//
//  Created by heyk on 16/3/3.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductModel.h"

typedef enum  {

    OrderStatusType_All = -1,
    OrderStatusType_UnPay = 0,//未付款
    OrderStatusType_UnSend  = 1,//已付款待发货
    OrderStatusType_UnRecieve = 2,//已发货待收货
    OrderStatusType_Done = 3,//列表请求时是完成。
    OrderStatusType_UnComment= 3,//已收货待评价
    OrderStatusType_HaveComments= 4,//已评价
    OrderStatusType_HaveReturnGoods = 5,//已退货
    OrderStatusType_HaveDelete = 6,//6已删除
    OrderStatusType_InVailed = 7,//7无效（超时未付款的
    
    
}OrderStatusType;



@interface GoodsAttr : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *value;

@end


@interface GoodsInfo : NSObject

@property (nonatomic,strong) NSString *goods_name;
@property (nonatomic,strong) NSString *goods_number;
@property (nonatomic,strong) NSString *goods_thumb;
@property (nonatomic,strong) NSArray <GoodsAttr*> *goods_attr;

@end


@interface OrderListModel : NSObject

@property (nonatomic,strong) NSString *order_id;
@property (nonatomic,strong) NSString *order_sn;
@property (nonatomic,strong) NSString *consignee;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *tel;
@property (nonatomic,strong) NSString *create_time;
@property (nonatomic,strong) NSString *order_status;
@property (nonatomic, strong)NSString *shipping_number;
@property (nonatomic,strong) NSString *goods_thumb;
@property (nonatomic,strong) NSString *order_type;//ProuductType :1:服务类商品订单2:充值类商品订单3:普通类商品订单

- (NSString*)dateStr;
- (ProuductType)goodsType;


@end


@interface OrderModel : OrderListModel

@property (nonatomic,strong) NSString *true_income;//实际收入
@property (nonatomic,strong) NSString *order_amount;
@property (nonatomic,strong) NSString *share_money;
@property (nonatomic,strong) NSString *shipping_fee;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *area;
@property (nonatomic,strong) NSString *pay_time;
@property (nonatomic,strong) NSString *shipping_time;
@property (nonatomic,strong) NSString *seller_id;
@property (nonatomic,strong) NSString *to_buyer;
@property (nonatomic,strong) NSString *pay_note;
@property (nonatomic,strong) NSString *exchange_code;
@property (nonatomic,strong) NSArray <GoodsInfo*>*goods_list;


@end
