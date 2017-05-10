//
//  ProductDetailsViewController.h
//  legend
//
//  Created by heyk on 16/1/11.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "BaseViewController.h"

@interface ProductDetailsViewController : BaseViewController

@property (nonatomic,weak)IBOutlet UITableView              *aTableView;
@property (nonatomic,weak)IBOutlet UIButton                 *buyButton;
@property (nonatomic,weak)IBOutlet NSLayoutConstraint       *buyButtonHeight;

@property (nonatomic,strong)NSString *googsID;

@end

