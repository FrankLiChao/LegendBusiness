//
//  CheckOrderDetailCell.h
//  legend_business_ios
//
//  Created by msb-ios-dev on 16/3/3.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"

@interface CheckOrderDetailCell : UITableViewCell

@property (nonatomic,assign) float topBarHeight UI_APPEARANCE_SELECTOR;

- (void)setUIWithModel:(OrderModel*)model;
+ (float)cellHeight:(OrderModel*)model;

@end
