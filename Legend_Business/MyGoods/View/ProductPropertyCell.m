//
//  ProductPropertyCell.m
//  legend
//
//  Created by heyk on 16/1/14.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "ProductPropertyCell.h"
#import "PureLayout.h"

@implementation ProductPropertyCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.contentImageView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.contentImageView];
        
        [_contentImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView];
        [_contentImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView];
        [_contentImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView];
        [_contentImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView];
        
    
        
        
        //        self.propertyNameLabel = [self createLabelWitTextColor:SYS_UI_COLOR_TEXT_GRAY];
        //        self.propertyContentLabel = [self createLabelWitTextColor:SYS_UI_COLOR_TEXT_BLACK];
        //        [self.contentView addSubview:_propertyNameLabel];
        //        [self.contentView addSubview:_propertyContentLabel];
        //
        //        [_propertyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.left.equalTo(self.contentView.mas_left).offset(12);
        //            make.top.equalTo(self.contentView.mas_top);
        //            make.bottom.equalTo(self.contentView.mas_bottom);
        //            make.width.equalTo(@100);
        //        }];
        //
        //        [_propertyContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        //            make.left.equalTo(self.propertyNameLabel.mas_right);
        //            make.right.equalTo(self.contentView.mas_right);
        //            make.top.equalTo(self.contentView.mas_top);
        //            make.bottom.equalTo(self.contentView.mas_bottom);
        //        }];
        //
        //        UIView *spearet = [[UIView alloc] initWithFrame:CGRectZero];
        //        spearet.backgroundColor = SYS_UI_COLOR_LINE_IN_LIGHT;
        //        [self addSubview:spearet];
        //
        //        [spearet mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        //            make.right.equalTo(self.mas_right);
        //            make.left.equalTo(self.mas_left);
        //            make.height.equalTo(@1);
        //            make.bottom.equalTo(self.mas_bottom);
        //        }];
        //
    }
    
    return self;
    
}

- (void)updateConstraints
{
    __block float imageHeight = _contentImageView.image.size.height*[UIScreen mainScreen].bounds.size.width/_contentImageView.image.size.width;
    
    [_contentImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView];
    [_contentImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView];
    [_contentImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView];
    [_contentImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView];
   [_contentImageView autoSetDimension:ALDimensionHeight toSize:imageHeight];
    
    
    
    [super updateConstraints];
}



-(UILabel*)createLabelWitTextColor:(UIColor *)color{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = color;
    
    return label;
}
@end
