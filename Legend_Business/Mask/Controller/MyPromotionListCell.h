//
//  MUPromotionListCell.h
//  legend_business_ios
//
//  Created by msb-ios-dev on 16/3/6.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyPromotionListCell;


@protocol MyPromotionListCellDelegate <NSObject>

- (void)clickEditPromotion:(MyPromotionListCell*)cell;


@end

@interface MyPromotionListCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
@property (nonatomic,weak) IBOutlet UILabel *numLabel;
@property (nonatomic,weak) IBOutlet UILabel *priceLabel;
@property (nonatomic,weak) IBOutlet UILabel *statusLabel;
@property (nonatomic,weak) IBOutlet UIButton *editButton;

@property (nonatomic,weak) id<MyPromotionListCellDelegate>delegate;

- (void)setUIWithModel:(PromotionListModel*)model;

@end
