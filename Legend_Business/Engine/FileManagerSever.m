//
//  FileManagerSever.m
//  legend
//
//  Created by heyk on 15/12/18.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import "FileManagerSever.h"
#import <UIKit/UIKit.h>
#import "NSObject+MJKeyValue.h"
#import "SaveEngine.h"

static NSString *errorLogDicName = @"ErrorLog";


@implementation FileManagerSever

+(NSString*)getErrorLogFilePath{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *errorLogDicPath =  [docDir stringByAppendingPathComponent:errorLogDicName];
    
    BOOL isDirectory;
    if(![[NSFileManager defaultManager] fileExistsAtPath:errorLogDicPath isDirectory:&isDirectory]){
        
        [[NSFileManager defaultManager] createDirectoryAtPath:errorLogDicPath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
    }
    return errorLogDicPath;
}
+(NSString*)getErrorFileNameWithType:(ErrorLogType)type{
    if (type == ErrorLogType_SignError) {
        return @"requestErrorFileName.log";
    }
    else if(type == ErrorLogType_WeChatPayError){
        return @"WechatPayError.log";
    }
    else if(type == ErrorLogType_AliPayError){
        return @"AliPayError.log";
    }
    return @"";
}

+(BOOL)writeRequstErrorLogToFile:(ErrorLogType)type request:(NSDictionary*)dic  url:(NSString*)url{
    
    NSString *filePath = [[FileManagerSever getErrorLogFilePath] stringByAppendingPathComponent:[self getErrorFileNameWithType:type]];
    
    BOOL isDirectory;
    NSFileManager *fileManger = [NSFileManager defaultManager];
    
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content setObject:url?url:@"" forKey:@"url"];
    [content setObject:dic?dic:@"" forKey:@"params"];
    [content setObject:[UIDevice currentDevice].name forKey:@"deviceName"];
    [content setObject:[UIDevice currentDevice].model forKey:@"deviceTyoe"];
    [content setObject:[UIDevice currentDevice].systemVersion forKey:@"system"];
    [content setObject:[NSString stringWithFormat:@"%d",(int)[NSProcessInfo processInfo].physicalMemory] forKey:@"Devicememory"];
    [content setObject:[SaveEngine getDeviceUUID] forKey:@"UIDI"];
    
    
    NSString *jsonString = [NSString stringWithFormat:@"%@",content];
    
    
    if ([fileManger fileExistsAtPath:filePath isDirectory:&isDirectory]) {
        
        NSFileHandle  *outFile;
        NSData *buffer;
        
        outFile = [NSFileHandle fileHandleForWritingAtPath:filePath];
        
        if(outFile == nil)
        {
            NSLog(@"Open of file for writing failed");
            return NO;
        }
        
        //找到并定位到outFile的末尾位置(在此后追加文件)
        [outFile seekToEndOfFile];
        
        buffer = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        [outFile writeData:buffer];
        
        //关闭读写文件
        [outFile closeFile];
        
        
    }
    else{
        
        [jsonString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    
    return YES;
    
}
//
//+(void)uploadErrorLog{
//    
//    BOOL bOpenUplpadErrorLog = [[NSUserDefaults standardUserDefaults] boolForKey:kOpenUploadErrorLogTag];
//    if (bOpenUplpadErrorLog) {
//        
//        
//        
//        //上传签名错误的日志
//        NSString *filePath = [[FileManagerSever getErrorLogFilePath] stringByAppendingPathComponent:[self getErrorFileNameWithType:ErrorLogType_SignError]];
//        
//        BOOL isDirectory;
//        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory]) {
//            [[WebEngine shareInstance] uploadErrorLog:ErrorLogType_SignError compe:^(BOOL bSuccess) {
//                if (bSuccess) {
//                    NSError *error;
//                    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
//                }
//            }];
//        }
//        
//        //上传微信支付错误日志
//        NSString *filePath1 = [[FileManagerSever getErrorLogFilePath] stringByAppendingPathComponent:[self getErrorFileNameWithType:ErrorLogType_WeChatPayError]];
//        
//        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath1 isDirectory:&isDirectory]) {
//            [[WebEngine shareInstance] uploadErrorLog:ErrorLogType_WeChatPayError compe:^(BOOL bSuccess) {
//                if (bSuccess) {
//                    NSError *error;
//                    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
//                }
//            }];
//        }
//        
//        //上传支付宝支付错误日志
//        NSString *filePath2 = [[FileManagerSever getErrorLogFilePath] stringByAppendingPathComponent:[self getErrorFileNameWithType:ErrorLogType_AliPayError]];
//        
//        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath2 isDirectory:&isDirectory]) {
//            [[WebEngine shareInstance] uploadErrorLog:ErrorLogType_AliPayError compe:^(BOOL bSuccess) {
//                if (bSuccess) {
//                    NSError *error;
//                    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
//                }
//            }];
//        }
//        
//    }
//}
//
+(NSArray *)getProvince{
    @autoreleasepool {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"province" ofType:nil];
        NSString *data = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *dic = [data mj_JSONObject];
        
        NSArray *province = [[dic objectForKey:@"root"] objectForKey:@"province"];
        
        
        NSMutableArray *results = [NSMutableArray array];
        
        for (NSDictionary *dic in province) {
            
            NSString *proviceStr = [dic objectForKey:@"-name"];
            [results addObject:proviceStr];
        }
        data = nil;
        dic = nil;
        province = nil;
        
        return results;
    }
}

+(NSArray *)getCityWithProvice:(NSString*)provice{
    
    @autoreleasepool {
        
        NSString* path = [[NSBundle mainBundle] pathForResource:@"province" ofType:nil];
        NSString *data = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *dic = [data mj_JSONObject];
        
        NSArray *provinceArray = [[dic objectForKey:@"root"] objectForKey:@"province"];
        NSMutableArray *results = [NSMutableArray array];
        
        for (NSDictionary *info in provinceArray) {
            
            NSString *proviceStr = [info objectForKey:@"-name"];
            if ([proviceStr isEqualToString:provice]) {
                
                id citys = [info objectForKey:@"city"];
                if ([citys isKindOfClass:[NSDictionary class]]) {
                    NSString *city = [citys objectForKey:@"-name"];
                    [results addObject:city];
                    return results;
                }
                else if([citys isKindOfClass:[NSArray class]]){
                    
                    for(NSDictionary *cityDic in citys){
                        NSString *city = [cityDic objectForKey:@"-name"];
                        [results addObject:city];
                    }
                    
                    return results;
                }
                
                
            }
        }
    }
    return nil;
}

+(NSArray*)getDistrctWithProvice:(NSString*)provice city:(NSString*)city{
    @autoreleasepool {
        
        NSString* path = [[NSBundle mainBundle] pathForResource:@"province" ofType:nil];
        NSString *data = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *dic = [data mj_JSONObject];
        
        NSArray *provinceArray = [[dic objectForKey:@"root"] objectForKey:@"province"];
        NSMutableArray *results = [NSMutableArray array];
        
        for (NSDictionary *info in provinceArray) {
            
            NSString *proviceStr = [info objectForKey:@"-name"];
            if ([proviceStr isEqualToString:provice]) {
                
                id citys = [info objectForKey:@"city"];
                if ([citys isKindOfClass:[NSDictionary class]]) {
                    
                    NSString *city1 = [citys objectForKey:@"-name"];
                    if ([city1 isEqualToString:city]) {
                        
                        NSArray *cityArray = [citys objectForKey:@"district"];
                        for (NSDictionary *areaDic in cityArray) {
                            
                            [results addObject:[areaDic objectForKey:@"-name"]];
                        }
                        return results;
                    }
                    
                    
                }
                else if([citys isKindOfClass:[NSArray class]]){
                    
                    for(NSDictionary *cityDic in citys){
                        NSString *city1 = [cityDic objectForKey:@"-name"];
                        
                        if ([city1 isEqualToString:city]) {
                            
                            NSArray *cityArray = [cityDic objectForKey:@"district"];
                            for (NSDictionary *areaDic in cityArray) {

                                [results addObject:[areaDic objectForKey:@"-name"]];
                            }
                            return results;
                        }
                        
                    }
                }
                
                
            }
        }
        
    }
    return nil;
}

+(RecieveAddressModel*)getAddressModelWithDistrctID:(NSString*)areaId{
    
    @autoreleasepool {
        
        NSString* path = [[NSBundle mainBundle] pathForResource:@"province" ofType:nil];
        NSString *data = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *dic = [data mj_JSONObject];
        
        NSArray *provinceArray = [[dic objectForKey:@"root"] objectForKey:@"province"];
        
        for (NSDictionary *info in provinceArray) {
            
            NSString *proviceStr = [info objectForKey:@"-name"];
            
            id citys = [info objectForKey:@"city"];
            if ([citys isKindOfClass:[NSDictionary class]]) {
                
                NSString *citystr = [citys objectForKey:@"-name"];
                
                NSArray *cityArray = [citys objectForKey:@"district"];
                
                for (NSDictionary *areaDic in cityArray) {
                    
                    NSString *zipcode = [areaDic objectForKey:@"-zipcode"];
                    if ([zipcode isEqualToString:areaId]) {
                        RecieveAddressModel *model = [RecieveAddressModel new];
                        model.distrct = [areaDic objectForKey:@"-name"];
                        model.area_id = zipcode;
                        model.provice = proviceStr;
                        model.city = citystr;
                        
                        return model;
                    }
                    
                }
                
                
            }
            else if([citys isKindOfClass:[NSArray class]]){
                
                for(NSDictionary *cityDic in citys){
                    
                    NSString *citystr = [cityDic objectForKey:@"-name"];
                    
                    NSArray *cityArray = [cityDic objectForKey:@"district"];
                    for (NSDictionary *areaDic in cityArray) {
                        
                        NSString *zipcode = [areaDic objectForKey:@"-zipcode"];
                        if ([zipcode isEqualToString:areaId]) {
                            RecieveAddressModel *model = [RecieveAddressModel new];
                            model.distrct = [areaDic objectForKey:@"-name"];
                            model.area_id = zipcode;
                            model.provice = proviceStr;
                            model.city = citystr;
                            
                            return model;
                        }
                        
                    }
                    
                    
                }
            }
            
            
        }
    }
    
    return nil;
}

+(NSString*)getDistrctIDWithModel:(RecieveAddressModel*)model{

    @autoreleasepool {
        
        NSString* path = [[NSBundle mainBundle] pathForResource:@"province" ofType:nil];
        NSString *data = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *dic = [data mj_JSONObject];
        
        NSArray *provinceArray = [[dic objectForKey:@"root"] objectForKey:@"province"];
  
        for (NSDictionary *info in provinceArray) {
            
            NSString *proviceStr = [info objectForKey:@"-name"];
            if ([proviceStr isEqualToString:model.provice]) {
                
                id citys = [info objectForKey:@"city"];
                if ([citys isKindOfClass:[NSDictionary class]]) {
                    
                    NSString *city1 = [citys objectForKey:@"-name"];
                    if ([city1 isEqualToString:model.city]) {
                        
                        NSArray *cityArray = [citys objectForKey:@"district"];
                        for (NSDictionary *areaDic in cityArray) {
                            
                            NSString *areaName = [areaDic objectForKey:@"-name"];
                            if ([areaName isEqualToString:model.distrct]) {
                                return [areaDic objectForKey:@"-zipcode"];
                            }
                        }
                     
                    }
                    
                    
                }
                else if([citys isKindOfClass:[NSArray class]]){
                    
                    for(NSDictionary *cityDic in citys){
                        NSString *city1 = [cityDic objectForKey:@"-name"];
                        
                        if ([city1 isEqualToString:model.city]) {
                            
                            NSArray *cityArray = [cityDic objectForKey:@"district"];
                            for (NSDictionary *areaDic in cityArray) {
                                
                                NSString *areaName = [areaDic objectForKey:@"-name"];
                                if ([areaName isEqualToString:model.distrct]) {
                                    return [areaDic objectForKey:@"-zipcode"];
                                }
                            }
               
                        }
                        
                    }
                }
                
                
            }
        }
        
    }
    return nil;
}
@end
