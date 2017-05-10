//
//  PrudctHeaderInfoCell.h
//  legend
//
//  Created by heyk on 16/1/12.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@protocol PrudctHeaderInfoCellDelegate <NSObject>

-(void)buyAction:(ProductModel*)model;

@end
@interface PrudctHeaderInfoCell : UITableViewCell

@property (nonatomic,weak)IBOutlet UIScrollView *scrollView;
@property (nonatomic,weak)IBOutlet UIView *scrollContentView;
@property (nonatomic,weak)IBOutlet UIPageControl *pageControl;
@property (nonatomic,weak)IBOutlet NSLayoutConstraint *scrollHeight;
@property (nonatomic,weak)IBOutlet NSLayoutConstraint *scrollWidth;

@property (nonatomic,weak)IBOutlet UILabel *nameLabel;
@property (nonatomic,weak)IBOutlet UILabel *priceLabel;
@property (nonatomic,weak)IBOutlet UILabel *stockLabel;
@property (nonatomic,weak)IBOutlet UILabel *freePostageLabel;
@property (nonatomic,weak)IBOutlet UILabel *postageLabel;
@property (nonatomic,weak)IBOutlet NSLayoutConstraint *priceBackHeight;
@property (nonatomic,weak)IBOutlet NSLayoutConstraint *freePostageHeight;

@property (nonatomic,weak)IBOutlet UIView   *tipView;
@property (nonatomic,weak)IBOutlet UIButton *sevenReturnButton;
@property (nonatomic,weak)IBOutlet UIButton *saleFreeButton;
@property (nonatomic,weak)IBOutlet NSLayoutConstraint *tipHeight;
@property (nonatomic,weak)IBOutlet NSLayoutConstraint *sevenReturnX;
@property (nonatomic,weak)IBOutlet NSLayoutConstraint *saleFreeX;

@property (nonatomic,weak)IBOutlet UIButton *propertyButton;
@property (nonatomic,weak)IBOutlet NSLayoutConstraint *propertyHeight;

@property (nonatomic,weak)IBOutlet UIView   *infoView;
@property (nonatomic,weak)IBOutlet UILabel  *infoDetailLabel;
@property (nonatomic,weak)IBOutlet UILabel  *infoTitleLabel;
@property (nonatomic,weak)IBOutlet NSLayoutConstraint *infoHeight;

@property (nonatomic,strong) UIFont *inforDetailFont UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIFont *nameFont UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIFont *priceFont UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIFont *stockFont UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIFont *infoTitleFont UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIFont *tipFont UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIFont *freePostageFont UI_APPEARANCE_SELECTOR;

@property (nonatomic,weak)IBOutlet id<PrudctHeaderInfoCellDelegate>delegate;


+(float)cellHeightWithModel:(ProductModel*)model;
-(void)setUIWithMode:(ProductModel*)model;

@end
