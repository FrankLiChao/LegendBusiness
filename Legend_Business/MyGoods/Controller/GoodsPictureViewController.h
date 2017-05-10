//
//  GoodsPictureViewController.h
//  legend_business_ios
//
//  Created by heyk on 16/3/2.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomUploadImageView.h"

@protocol GoodsPictureViewControllerDelegate <NSObject>

@optional
-(void)addGoodsPic:(NSArray<CustomUploadImageView*>*)goodPicsView;


@end

@interface GoodsPictureViewController : BaseViewController

@property (nonatomic,weak)id<GoodsPictureViewControllerDelegate>delegate;

@property (nonatomic,strong)NSMutableArray *currentPicsView;

@end
