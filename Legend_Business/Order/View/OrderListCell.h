//
//  OrderListCell.h
//  legend_business_ios
//
//  Created by heyk on 16/3/3.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *orderNumLabel;
@property (nonatomic,weak) IBOutlet UILabel *reciverNameLabel;
@property (nonatomic,weak) IBOutlet UILabel *dateLabel;
@property (nonatomic,weak) IBOutlet UILabel *statusLabel;
@property (nonatomic,weak) IBOutlet UIImageView *contentImageView;


@end
