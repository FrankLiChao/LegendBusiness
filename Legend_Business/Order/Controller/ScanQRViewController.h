//
//  ScanQRViewController.h
//  legend_business_ios
//
//  Created by Frank on 2016/12/9.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderDetailController.h"

@interface ScanQRViewController : BaseViewController

@property (nonatomic, weak)OrderDetailController *delegate;

@end
