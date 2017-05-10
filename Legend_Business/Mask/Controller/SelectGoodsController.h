//
//  SelectGoodsController.h
//  legend_business_ios
//
//  Created by heyk on 16/3/5.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol SelectGoodsControllerDelegate <NSObject>

@optional
- (void)selectGoods:(ProductListModel*)model;


@end

@interface SelectGoodsController : BaseViewController

@property (nonatomic,weak) id<SelectGoodsControllerDelegate>delegate;

@end
