//
//  SellerAfterListModel.m
//  legend_business_ios
//
//  Created by heyk on 16/3/4.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "SellerAfterListModel.h"


@implementation SellerAfterListModel


- (ProuductType)goodsType{
    
    if ([self.order_type intValue] == ProuductType_Server) {
        return ProuductType_Server;
    }
    else if([self.order_type intValue] == ProuductType_Recharege){
    
        return ProuductType_Recharege;
    }
    else if([self.order_type intValue] == ProuductType_Normal){
        
        return ProuductType_Normal;
    }
    return ProuductType_UnKown;
}

@end
