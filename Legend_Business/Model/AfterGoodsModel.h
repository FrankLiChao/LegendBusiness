//
//  goodsModel.h
//  legend_business_ios
//
//  Created by Frank on 2016/11/26.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AfterGoodsModel : NSObject

@property (nonatomic, strong)NSString *goods_id;//--商品id
@property (nonatomic, strong)NSString *order_id;//--订单id
@property (nonatomic, strong)NSString *goods_name;//商品名称
@property (nonatomic, strong)NSString *price;//价格
@property (nonatomic, strong)NSString *goods_thumb;//略缩图
@property (nonatomic, strong)NSString *attr_id;//属性Id
@property (nonatomic, strong)NSString *attr_name;//属性名
@property (nonatomic, strong)NSString *delivery_status;//--买家发货状态  0 未发货 1 发货

+ (AfterGoodsModel *)parseResponse:(id)response;

@end
