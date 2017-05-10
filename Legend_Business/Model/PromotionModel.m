//
//  PromotionModel.m
//  legend_business_ios
//
//  Created by msb-ios-dev on 16/3/6.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "PromotionModel.h"

@implementation AnsweAdvInfo

@end

@implementation PromotionListModel


- (AdvType)advType{

    if (!self.tpl_type ) return AdvType_None;
    else if ([self.tpl_type intValue] == 4) return AdvType_Share;
    else if ([self.tpl_type intValue] == 2) return AdvType_Answer;
    
    return AdvType_None;
}
- (NSString*)advTypeName{

    if ([self advType] == AdvType_Share) {
        return @"分享类广告";
    }
    else if ([self advType] == AdvType_Answer){
        return @"问答类广告";
    }
    return @"";
}
- (AdvStatus)advStatus{

    return [self.status intValue];
}
- (int)getCount{
    
    if ([_target_money floatValue]>0 && [_unit_price floatValue]>0) {
        
        NSLog(@"price = %f,total price = %f",[_target_money floatValue],[_unit_price floatValue]);
        
        int count = (int)([_target_money floatValue]/[_unit_price floatValue]/3.8);
        return count;
    }
    return 0;
}

@end

@implementation PromotionModel

- (id)initWithListModel:(PromotionListModel*)model{

    self = [super init];
    if (self) {
//        self.title = model.title;
//        self.count = model.count;
//        self.price = model.price;
//        self.uint_price = model.uint_price;
//        self.status = model.status;
//        self.finshPrice = model.finshPrice;
//        self.finishCount = model.finishCount;
//        self.adv_type = model.adv_type;
//        self.adv_type_id = model.adv_type_id;

        
    }
    return self;
}

- (id)initWithGoodsModel:(ProductListModel*)model{
    self = [super init];
    if (self) {
        
        self.goodsTitle = model.goods_name;
        self.goodId = model.goods_id;
        self.goods_thumb = model.goods_thumb;
    }
    return self;
}

- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}




- (NSDate*)beginDate{

    NSDate *date = [self dateFromString:self.beginTime];
    return date;
}

- (NSDate*)endDate{
    NSDate *date = [self dateFromString:self.endTime];
    return date;
}

@end