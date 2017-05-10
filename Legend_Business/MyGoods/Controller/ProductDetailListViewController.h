//
//  ProductDetailListViewController.h
//  legend
//
//  Created by heyk on 16/1/13.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductModel.h"

@protocol ProductDetailListViewControllerDelegate <NSObject>
@optional
-(void)pullToShowProudctDetail:(UIViewController*)vc;

@end

@interface ProductDetailListViewController : BaseViewController

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,weak)id<ProductDetailListViewControllerDelegate>delegate;

@property (nonatomic,strong)ProductModel *currentModel;


@end
