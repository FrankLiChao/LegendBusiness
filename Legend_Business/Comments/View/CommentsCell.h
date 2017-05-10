//
//  CommentsCell.h
//  legend_business_ios
//
//  Created by heyk on 16/3/4.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentsCell;
@interface CustomButton : UIButton

@property (nonatomic,strong) NSString *imageUrl;

@end

@protocol CommentsCellDelgate <NSObject>

- (void)replyComments:(CommentsCell*)cell;
- (void)checkImageDetail:(NSString*)imageUrl;


@end

@interface CommentsCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView *headImageV;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *timeLabel;
@property (nonatomic,weak) IBOutlet UIImageView *startV1;
@property (nonatomic,weak) IBOutlet UIImageView *startV2;
@property (nonatomic,weak) IBOutlet UIImageView *startV3;
@property (nonatomic,weak) IBOutlet UIImageView *startV4;
@property (nonatomic,weak) IBOutlet UIImageView *startV5;
@property (nonatomic,weak) IBOutlet UILabel *commentsLabel;
@property (nonatomic,weak) IBOutlet UILabel *attrLabel;
@property (nonatomic,weak) IBOutlet UIButton *replayButton;
@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic,weak) IBOutlet UILabel *replyLabel;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *scrollHeight;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *replyLabelHeight;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *goodsInfoHeight;


@property (nonatomic,assign) float  imageHeight UI_APPEARANCE_SELECTOR;
@property (nonatomic,assign) float  goodsAttrHeight UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIFont* commentFont UI_APPEARANCE_SELECTOR;

@property (nonatomic,weak) id<CommentsCellDelgate>delegate;

+ (float)cellHeight:(CommentsModel*)model;

- (void)setUIWithModel:(CommentsModel*)model;

@end
