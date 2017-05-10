//
//  NSObject+PortError.m
//  legend_business_ios
//
//  Created by heyk on 16/2/26.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "NSObject+PortError.h"
#import "DefineKey.h"
#import "FileManagerSever.h"

@implementation NSObject(PortError)

-(NSString*)errorAnalysis:(NSDictionary*)dict request:(NSDictionary*)requestDic url:(NSString*)url{
    NSDictionary *data = [dict objectForKey:@"data"];
    if (data && [data isKindOfClass:[NSDictionary class]]) {
        NSNumber *errorcode = [data objectForKey:@"error_code"];
        if ([errorcode intValue] == 1010002){//签名错误
            
            [FileManagerSever writeRequstErrorLogToFile:ErrorLogType_SignError request:requestDic  url:url];
        }
        else if ([errorcode intValue] >= 1020001 && [errorcode intValue] <= 1020008) {
           [[NSNotificationCenter defaultCenter] postNotificationName:SYS_NOTI_NEED_LOGIN object:nil];
        }
        
        NSString *errorDes = [data objectForKey:@"error_msg"];
        return errorDes;
    }
    
    return nil;
}


@end
