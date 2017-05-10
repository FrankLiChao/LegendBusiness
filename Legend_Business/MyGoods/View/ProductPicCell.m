//
//  ProductPicCell.m
//  legend
//
//  Created by heyk on 16/1/14.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "ProductPicCell.h"
#import "PureLayout.h"

@implementation ProductPicCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.contentImageView];
        self.contentImageView.contentMode = UIViewContentModeScaleAspectFit;

    }
    
    return self;
    
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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



-(void)setContentWithURL:(NSString*)url{

}

@end
