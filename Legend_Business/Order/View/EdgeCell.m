//
//  EdgeCell.m
//  legend_business_ios
//
//  Created by msb-ios-dev on 16/3/4.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "EdgeCell.h"

@implementation EdgeCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)layoutSubviews{
    
    [super layoutSubviews];

    self.textLabel.frame = CGRectMake(10, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
}
@end
