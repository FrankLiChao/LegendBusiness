//
//  ProductPicCell.h
//  legend
//
//  Created by heyk on 16/1/14.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductPicCell : UITableViewCell

@property (nonatomic,strong)UIImageView *contentImageView;
@property (nonatomic, assign) BOOL didSetupConstraints;

-(void)setContentWithURL:(NSString*)url;

@end
