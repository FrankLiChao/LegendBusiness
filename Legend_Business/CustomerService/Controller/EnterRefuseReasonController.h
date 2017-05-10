//
//  EnterRefuseReasonController.h
//  legend_business_ios
//
//  Created by heyk on 16/3/4.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef enum {

    InPutTextViewType_AfterRefuse,//售后拒绝
    InPutTextViewType_Comments,//评价回复
    InPutTextViewType_Modify_Seller_Info,//修改店铺介绍
    
}InPutTextViewType;

@interface EnterRefuseReasonController : BaseViewController

@property (nonatomic,strong)id content;
@property (nonatomic,strong)NSString *ID;
@property (nonatomic)InPutTextViewType type;


@end
