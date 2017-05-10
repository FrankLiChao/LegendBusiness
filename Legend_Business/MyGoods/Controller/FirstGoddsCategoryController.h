//
//  FirstGoddsCategoryController.h
//  legend_business_ios
//
//  Created by heyk on 16/3/2.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FirstGoddsCategoryControllerDelegate <NSObject>

@optional
-(void)selectGoodsCategoryModel:(GoodsCategoryModel*)model parentModel:(GoodsCategoryModel*)model;


@end

@interface FirstGoddsCategoryController : BaseViewController

@property (nonatomic,weak)id<FirstGoddsCategoryControllerDelegate>delegate;

@end
