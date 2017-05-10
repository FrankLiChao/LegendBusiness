//
//  PaySever.h
//  legend
//
//  Created by heyk on 16/1/8.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Order.h"
@interface PaySever : NSObject

+(void)weChatPay:(Order*)model comple:(void(^)(BOOL bsuccess))comple;

+(void)aliPay:(Order*)model comple:(void(^)(BOOL bsuccess,NSString *message))comple;


@end
