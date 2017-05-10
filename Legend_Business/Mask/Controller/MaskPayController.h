//
//  MaskPayController.h
//  legend_business_ios
//
//  Created by msb-ios-dev on 16/3/6.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef enum {

    PayControllerType_Mask,//任务支付
    PayControllerType_Adv_Answer,//问答类发布广告支付
    PayControllerType_Adv_Share,//发布分享类广告支付

}PayControllerType;

@interface SelectButton : UIButton

- (void)setSelected:(BOOL)selected;

@end

@interface MaskPayController : BaseViewController


//@property (nonatomic,strong) MaskListModel *model;


@property (nonatomic,strong) NSString *orderId;//订单号
@property (nonatomic,strong) NSNumber *myMoney;//余额
@property (nonatomic,strong) NSNumber *orderMoney;//总价格
@property (nonatomic,strong) NSString *list_image;
@property (nonatomic,strong) NSString *time_limit;
@property (nonatomic,strong) NSString *demand;
@property (nonatomic,strong) NSString *unit_price;
@property (nonatomic,strong) NSString *target_number;
@property (nonatomic)PayControllerType type;


@end
