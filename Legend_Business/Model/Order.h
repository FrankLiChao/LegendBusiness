//
//  Order.h
//  AlixPayDemo
//
//  Created by 方彬 on 11/2/13.
//
//

#import <Foundation/Foundation.h>



typedef enum : NSInteger{
    ProductWay_None,//未知
    ProductWay_Recharge = 1,//充值
    ProductWay_Goods = 2,//商品
    
}ProductWay;//交易商品类型




@interface SignaturedataModel :NSObject

@property (nonatomic,strong)NSString *appid;
@property (nonatomic,strong)NSString *partnerid;
@property (nonatomic,strong)NSString *prepayid;
@property (nonatomic,strong)NSString *weixin_package;
@property (nonatomic,strong)NSString *noncestr;
@property (nonatomic,strong)NSString *timestamp;
@property (nonatomic,strong)NSString *sign;
@end

@interface Order : NSObject

@property (nonatomic,strong)NSNumber *pay_type;
@property (nonatomic,strong)NSString *order_no;
@property (nonatomic,strong)NSString *signature_data;
@property (nonatomic,strong)SignaturedataModel *sigatureData;
@property ProductWay product_type;//商品type

@end

//钱包处啊
@interface PacketOrderModel : NSObject

@property (nonatomic,strong)NSNumber *create_time;
@property (nonatomic,strong)NSString *goods_amount;
@property (nonatomic,strong)NSString *user_name;
@property (nonatomic,strong)NSString *user_avatar;
@property (nonatomic,strong)NSString *goods_name;
@property (nonatomic,strong)NSString *order_id;


@end
