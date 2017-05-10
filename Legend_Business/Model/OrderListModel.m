//
//  OrderListModel.m
//  legend_business_ios
//
//  Created by heyk on 16/3/3.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "OrderListModel.h"

@implementation GoodsAttr


@end
@implementation GoodsInfo
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"goods_attr" : @"GoodsAttr",
             };
}
@end

@implementation OrderListModel

- (NSString*)dateStr{

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.create_time doubleValue]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
}

- (ProuductType)goodsType{


    if ([self.order_type intValue] == ProuductType_Server) {
        return ProuductType_Server;
    }
    else if([self.order_type intValue] == ProuductType_Recharege){
        return ProuductType_Recharege;
    }
    else if([self.order_type intValue] == ProuductType_Normal){
        return ProuductType_Normal;
    }
    else return ProuductType_UnKown;
}
@end


@implementation OrderModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"goods_list" : @"GoodsInfo",
             };
}



@end