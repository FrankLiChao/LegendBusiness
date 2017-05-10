//
//  FileManagerSever.h
//  legend
//
//  Created by heyk on 15/12/18.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecieveAddressModel.h"


typedef  NS_ENUM(NSInteger, ErrorLogType) {
    
    ErrorLogType_Crash=1,
    ErrorLogType_SignError,
    ErrorLogType_WeChatPayError,
    ErrorLogType_AliPayError,
    
};

@interface FileManagerSever : NSObject

+(NSString*)getErrorLogFilePath;
+(NSString*)getErrorFileNameWithType:(ErrorLogType)type;

+(BOOL)writeRequstErrorLogToFile:(ErrorLogType)type request:(NSDictionary*)dic url:(NSString*)url;

//+(void)uploadErrorLog;

+(NSArray *)getProvince;
+(NSArray *)getCityWithProvice:(NSString*)provice;
+(NSArray*)getDistrctWithProvice:(NSString*)provice city:(NSString*)city;
+(RecieveAddressModel*)getAddressModelWithDistrctID:(NSString*)district;
+(NSString*)getDistrctIDWithModel:(RecieveAddressModel*)model;

@end
