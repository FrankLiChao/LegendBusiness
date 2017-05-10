//
//  MJRefreshComponent+Extension.m
//  legend_business_ios
//
//  Created by heyk on 16/3/8.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "MJRefreshComponent+Extension.h"

@implementation MJRefreshComponent(Extension)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setExtensionStatus:(MJExtensionStatus)st{

    if (st == MJExtensionStatus_Idle) {
        
            self.state = MJRefreshStateIdle;
    }
    else if (st == MJExtensionStatus_Pulling){
       self.state = MJRefreshStatePulling;
    
    }
    else if (st == MJExtensionStatus_Refreshing){
        
        self.state = MJRefreshStateRefreshing;
        
    }
    else if (st == MJExtensionStatus_WillRefresh){
        
        self.state = MJRefreshStateWillRefresh;
        
    }
    else if (st == MJExtensionStatus_NoMoreData){
        
        self.state = MJRefreshStateNoMoreData;
    }
}


- (MJExtensionStatus)extensionStatus{

    if (self.state == MJRefreshStateIdle) {
        return MJExtensionStatus_Idle;
    }
    else if(self.state == MJRefreshStatePulling){
        return MJExtensionStatus_Pulling;
    }
    else if(self.state == MJRefreshStateRefreshing){
        return MJExtensionStatus_Refreshing;
    }
    else if(self.state == MJRefreshStateWillRefresh){
        return MJExtensionStatus_WillRefresh;
    }
    else if(self.state == MJRefreshStateNoMoreData){
        return MJExtensionStatus_NoMoreData;
    }
    return MJExtensionStatus_Idle;
    
}

@end
