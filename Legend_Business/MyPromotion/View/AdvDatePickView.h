//
//  AdvDatePickView.h
//  legend_business_ios
//
//  Created by heyk on 16/3/7.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^AdvDatePickViewSelect)(id content);

@interface AdvDatePickView : UIView

+ (AdvDatePickView*)getInstance;
- (void)showWithValue:(NSString*)value selectBlock:(AdvDatePickViewSelect)block;

@end
