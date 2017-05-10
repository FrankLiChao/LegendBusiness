//
//  OrderDetailController.h
//  legend_business_ios
//
//  Created by msb-ios-dev on 16/3/3.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface OrderDetailController : BaseViewController

@property (nonatomic,strong)NSString *orderId;

-(void)refreshUI:(NSString *)expressOrderId;
@end
