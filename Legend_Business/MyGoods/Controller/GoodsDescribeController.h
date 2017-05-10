//
//  Good GoodsDescribeController.h
//  legend_business_ios
//
//  Created by heyk on 16/3/2.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GoodsDescribeControllerDelegate <NSObject>

@optional
-(void)addGoodDesrible:(NSString*)dex contentTag:(id)tag;


@end

@interface GoodsDescribeController : BaseViewController

@property (nonatomic,weak) id<GoodsDescribeControllerDelegate>delegate;
@property (nonatomic,strong) id contentTag;//用于区分标记
@property (nonatomic,strong) NSString* content;
@property (nonatomic,strong) NSString* strTitle;

@end
