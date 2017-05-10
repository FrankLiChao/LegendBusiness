//
//  CustomerSeverListCell.h
//  legend_business_ios
//
//  Created by heyk on 16/3/4.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomerSeverListCell;


@protocol CustomerSeverListCellDelegate <NSObject>

//确认收货
- (void)sureReciveAction:(CustomerSeverListCell*)cell;

//同意退货
- (void)agreeRetueAction:(CustomerSeverListCell*)cell;

//拒绝申请
- (void)refuseAction:(CustomerSeverListCell*)cell;

//查看订单详情
- (void)checkOrderDetail:(CustomerSeverListCell*)cell;
//查看图片详情
- (void)checkPicDetail:(NSString*)imageUrl;

@end

@interface CustomerSeverListCell : UITableViewCell

@property (nonatomic,weak)IBOutlet UIView *contentBackView;
@property (nonatomic,weak)IBOutlet UILabel *reasonLabel;
@property (nonatomic,weak)IBOutlet UIScrollView  *imageScrollView;
@property (nonatomic,weak)IBOutlet UIView  *buyerInfoView;
@property (nonatomic,weak)IBOutlet UILabel *orderLabel;
@property (nonatomic,weak)IBOutlet UILabel *buyerNameLabel;
@property (nonatomic,weak)IBOutlet UIImageView *buyerHeadView;
@property (nonatomic,weak)IBOutlet UILabel *buyerPhoneLabel;


@property (nonatomic,weak)IBOutlet UIButton *agreeRetureButton;
@property (nonatomic,weak)IBOutlet UIButton *refuseButton;
@property (nonatomic,weak)IBOutlet UIButton *sureRetureButton;
@property (nonatomic,weak)IBOutlet UILabel *expressNumberLabel;


@property (nonatomic,weak)IBOutlet NSLayoutConstraint *imageConstaitHeight;

@property (nonatomic,weak)id<CustomerSeverListCellDelegate> delegate;



@property (nonatomic,strong) UIFont* reasonFont UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIFont* expressFont UI_APPEARANCE_SELECTOR;
@property (nonatomic,assign) float  imageHeight UI_APPEARANCE_SELECTOR;
@property (nonatomic,assign) float  buyerInfoHeight UI_APPEARANCE_SELECTOR;
@property (nonatomic,assign) float  footBarHeight UI_APPEARANCE_SELECTOR;


- (void)showUnDealCellWithModel:(SellerAfterListModel*)model;
- (void)showDealingCellWithModel:(SellerAfterListModel*)model;

+ (float)cellHeight:(SellerAfterListModel*)model;
@end
