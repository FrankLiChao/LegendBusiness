//
//  CommentsModel.m
//  legend_business_ios
//
//  Created by heyk on 16/3/4.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "CommentsModel.h"

@implementation CommentsModel

- (NSString*)dateStr{

    if ([UitlCommon isNull:self.create_time]) {
        return @"";
    }
    else{
     
        NSArray *array = [self.create_time componentsSeparatedByString:@" "];
        if (array.count>0) {
            return [array firstObject];
        }
        else return @"";
        
    }
}

- (NSString*)goodsAttr{


    if (self.goods_attr) {
        
        NSArray *array = [self.goods_attr mj_JSONObject];
        
        NSMutableString *str = [NSMutableString string];
        for (NSDictionary *dic in array) {
            
            [str appendString:@" "];
            [str appendString:[dic objectForKey:@"name"]];
            [str appendString:@": "];
            [str appendString:[dic objectForKey:@"value"]];
            
            
        }
        return str;
    }
    return @"";
}
@end
