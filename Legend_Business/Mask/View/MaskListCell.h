//
//  MaskListCell.h
//  legend_business_ios
//
//  Created by msb-ios-dev on 16/3/6.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaskListCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView *headImageV;
@property (nonatomic,weak) IBOutlet UILabel *desLabel;
@property (nonatomic,weak) IBOutlet UILabel *percentLabel;
@property (nonatomic,weak) IBOutlet UILabel *totalNumLabel;
@end
