//
//  SecondGoodsCategoryController.h
//  legend_business_ios
//
//  Created by heyk on 16/3/2.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsCategoryModel.h"

@protocol SecondGoodsCategoryControllerDelegate <NSObject>

@optional
-(void)selectGoodsCategoryModel:(GoodsCategoryModel*)model1 parentModel:(GoodsCategoryModel*)model2;


@end

@interface SecondGoodsCategoryController : BaseViewController

@property (nonatomic,strong)NSArray<GoodsCategoryModel*> *dataArray;
@property (nonatomic,strong)GoodsCategoryModel *parentModel;
@property (nonatomic,weak)id<SecondGoodsCategoryControllerDelegate>delegate;

@end
