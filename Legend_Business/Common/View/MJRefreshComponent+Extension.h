//
//  MJRefreshComponent+Extension.h
//  legend_business_ios
//
//  Created by heyk on 16/3/8.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

typedef enum {

    MJExtensionStatus_Idle = 1,
    MJExtensionStatus_Pulling,
    MJExtensionStatus_Refreshing,
    MJExtensionStatus_WillRefresh,
    MJExtensionStatus_NoMoreData,

}MJExtensionStatus;

@interface MJRefreshComponent(Extension)

- (void)setExtensionStatus:(MJExtensionStatus)st;
- (MJExtensionStatus)extensionStatus;

@end
