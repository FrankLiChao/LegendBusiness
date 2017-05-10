//
//  AddGoodsCell.h
//  legend_business_ios
//
//  Created by heyk on 16/3/2.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddGoodsCell;

@protocol AddGoodsCellDelegate <NSObject>

@optional

- (void)clickAddHomePageImage;
- (void)clickAddCoverImage;
- (void)deleteAttributionCell:(AddGoodsCell*)cell;
- (void)addNewAttributin;
- (void)switchValueChanged:(BOOL)bOpen;
- (void)goodsTitleChange:(NSString*)str;


@end


@interface AddGoodsCell : UITableViewCell

@property (nonatomic,weak) id<AddGoodsCellDelegate>delegate;

@property (nonatomic,weak) IBOutlet UILabel  *myTitleLabel;
@property (nonatomic,weak) IBOutlet UILabel  *myDetailLabel;


@property (nonatomic,weak) IBOutlet UITextField *priceField;
@property (nonatomic,weak) IBOutlet UITextField *stockField;


@end


@interface AddGoodsCell1 : AddGoodsCell

@property (nonatomic,weak) IBOutlet UITextField *titleField;
@property (nonatomic,weak) IBOutlet UIButton  *homePageImageView;
@property (nonatomic,weak) IBOutlet UIButton  *coverpImageView;
@property (nonatomic,weak) IBOutlet UILabel  *homePageLabel;
@property (nonatomic,weak) IBOutlet UILabel  *coverLabel;


+ (AddGoodsCell1*)createCellWithNib;

- (CustomUploadImageView*)homePageImage;
- (CustomUploadImageView*)coverImage;

@end


@interface AddGoodsCell2 : AddGoodsCell//有分割线

+ (AddGoodsCell2*)createCellWithNib;

@end


@interface AddGoodsCell3 : AddGoodsCell

+ (AddGoodsCell3*)createCellWithNib;

@end


@interface AddGoodsCell4 : AddGoodsCell //自定义商品规格

@property (nonatomic,weak) IBOutlet UITextField *specsField;
@property (nonatomic,strong) NSString *attrId;


+ (AddGoodsCell4*)createCellWithNib;


@end


@interface AddGoodsCell5 : AddGoodsCell //默认商品规格


+ (AddGoodsCell5*)createCellWithNib;


@end


@interface AddGoodsCell6 : AddGoodsCell //添加规格


+ (AddGoodsCell6*)createCellWithNib;


@end

@interface AddGoodsCell7 : AddGoodsCell //返点

@property (nonatomic,weak)IBOutlet UITextField *contentField;
@property (nonatomic,weak)IBOutlet UIView *sperateLine;

+ (AddGoodsCell7*)createCellWithNib;


@end

@interface AddGoodsCell8 : AddGoodsCell //带switch开关

@property (nonatomic,weak)IBOutlet UISwitch *control;

+ (AddGoodsCell8*)createCellWithNib;



@end


@interface AddGoodsCell9 : AddGoodsCell // 普通选择类不带分割线


+ (AddGoodsCell9*)createCellWithNib;



@end


@interface AddGoodsCell10 : AddGoodsCell // 普通选择类带分割线


+ (AddGoodsCell10*)createCellWithNib;



@end
