//
//  PromotionModel.h
//  legend_business_ios
//
//  Created by msb-ios-dev on 16/3/6.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    
    AdvType_None = 0,
    AdvType_Answer = 2,
    AdvType_Share = 4,
    
}AdvType;

typedef enum{
    
    AdvStatus_UnPay = 0,//0:未支付
    AdvStatus_Waiting = 1,//1支付未审核
    AdvStatus_Doing = 2,//2正在进行中
    AdvStatus_Not_Passed = 3,//3审核不通过
    AdvStatus_Done = 4,//4已完成
}AdvStatus;

@interface AnsweAdvInfo : NSObject

@property (nonatomic,strong)NSString *question;
@property (nonatomic,strong)NSString *answer;

@end


@interface PromotionListModel : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSString *target_number;//目标数量
@property (nonatomic,strong) NSString *finish_number;//已完成广告数量
@property (nonatomic,strong) NSString *target_money;
@property (nonatomic,strong) NSString *unit_price;
@property (nonatomic,strong) NSString *remainder_money;
@property (nonatomic,strong) NSString *status; //任务状态 0:未支付,1支付未审核,2正在进行中,3审核不通过,4已完成
@property (nonatomic,strong) NSString *tpl_type;//广告类型：2回答4分享


- (AdvType)advType;
- (NSString*)advTypeName;
- (AdvStatus)advStatus;
- (int)getCount;


@end


@interface PromotionModel : PromotionListModel

@property (nonatomic,strong) NSArray  <AnsweAdvInfo*>*advInfoArray;
@property (nonatomic,strong) NSString *goodsTitle;

@property (nonatomic,strong) NSString *beginTime;
@property (nonatomic,strong) NSString *endTime;
@property (nonatomic,strong) NSString *shareInfo;
@property (nonatomic,strong) NSString *goodId;
@property (nonatomic,strong) NSString *goods_thumb;
- (id)initWithListModel:(PromotionListModel*)model;

- (id)initWithGoodsModel:(ProductListModel*)model;


- (NSDate*)beginDate;
- (NSDate*)endDate;

@end



