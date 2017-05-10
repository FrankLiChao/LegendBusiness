//
//  EditeGoodsController.h
//  legend_business_ios
//
//  Created by heyk on 16/3/4.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface EditeGoodsController : BaseViewController
@property (nonatomic,weak)IBOutlet UITableView *tableView;
@property (nonatomic,weak)IBOutlet UIView *footView;
@property (nonatomic,weak)IBOutlet UIButton *saveButton;


+ (EditeGoodsController*)createWithEditModel:(NSString*)goodsId;


@end
