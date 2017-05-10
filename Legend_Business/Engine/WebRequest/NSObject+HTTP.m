//
//  NSObject+HTTP.m
//  Test
//
//  Created by msb-ios-dev on 16/2/17.
//  Copyright © 2016年 msb-ios-dev. All rights reserved.
//

#import "NSObject+HTTP.h"
#import "DefineKey.h"
#import "NSObject+PortEncry.h"
#import "NSObject+PortError.h"
#import "SaveEngine.h"
#import "legend_business_ios-swift.h"
/**
 *  安全地执行block
 *
 *  @param A 具体的block
 */


@implementation NSObject(HTTP)


//存储图片到本地
- (bool)saveImageToCacheDirWithPath:(NSString*)directoryPath
                              image:(UIImage*)image
                          imageName:(NSString*)imageName
                          imageType:(NSString*)imageType {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:directoryPath isDirectory:nil];
    bool isSaved = NO;
    if (existed == YES )
    {
        if ([[imageType lowercaseString] isEqualToString:@"png"])
        {
            isSaved = [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
        }
        else if ([[imageType lowercaseString] isEqualToString:@"jpg"] || [[imageType lowercaseString] isEqualToString:@"jpeg"])
        {
            isSaved = [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
        }
        else
        {
            NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", imageType);
        }
    }
    return isSaved;
}


- (void)deleteCacheImage:(NSString*)directoryPath{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:directoryPath isDirectory:nil];
    
    if (existed) {
        BOOL bRemoved =   [fileManager removeItemAtPath:directoryPath error:nil];
        NSLog(@"remove = %d",bRemoved);
    }
}

- (BOOL)isConnected {
    struct sockaddr zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sa_len = sizeof(zeroAddress);
    zeroAddress.sa_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability =
    SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags =
    SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        printf("Error. Count not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}


- (void )POST:(NSString *)url
       params:(id)params
      success:(void (^)(id responseObject))success
      failure:(void (^)( NSError *error))failure{
    
    if (![self isConnected]) {
        failure(nil);
        return;
    }
    
    NSSet *acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                     @"text/html",
                                     @"text/json",
                                     @"text/javascript",
                                     @"text/plain", nil];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    
    [manager POST:url
       parameters:params
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             
             NSDictionary *data = [responseObject objectForKey:@"data"];
             if (data && [data isKindOfClass:[NSDictionary class]]) {
                 NSNumber *errorcode = [data objectForKey:@"error_code"];
                 
                 if([errorcode intValue] >= 1020001 && [errorcode intValue] <= 1020008){//登录失效
                     
                     if(![SaveEngine getLoginAccount] || ![SaveEngine getLoginPassord]){
                         
                         KK_EXECUTE_BLOCK(success,responseObject);
                         return;
                     }
                     [self atuoLoginWithLastRequset:url
                                              param:params
                                            success:success failure:failure];
                     
                 }
                 else{
                     KK_EXECUTE_BLOCK(success,responseObject);
                 }
                 
             }
             else{
                 
                 KK_EXECUTE_BLOCK(success,responseObject);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             KK_EXECUTE_BLOCK(failure,error);
             
         }];
}

- (void )POST:(NSString *)url
       params:(id)params
     bodyPart:(void (^)(id <AFMultipartFormData> formData))bodyPart
      success:(void (^)(id responseObject))success
      failure:(void (^)(NSError *error))failure{
    
    if (![self isConnected]) {
        failure(nil);
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30;
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",nil];
    
    
    
    [manager POST:url
       parameters:params
constructingBodyWithBlock:bodyPart
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             KK_EXECUTE_BLOCK(success,responseObject);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             KK_EXECUTE_BLOCK(failure,error);
         }];
    
    
}

- (void )POST:(NSString *)url
       params:(id)params
     bodyPart:(void (^)(id <AFMultipartFormData> formData))bodyPart
     progress:(void (^)(NSProgress* progress))progress
      success:(void (^)(id responseObject))success
      failure:(void (^)(NSError *error))failure{
    if (![self isConnected]) {
        failure(nil);
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30;
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",nil];
    
    
    
    [manager POST:url
       parameters:params
constructingBodyWithBlock:bodyPart
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
             progress(uploadProgress);
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             KK_EXECUTE_BLOCK(success,responseObject);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             KK_EXECUTE_BLOCK(failure,error);
         }];
    
}


- (void)atuoLoginWithLastRequset:(NSString*)lastUrl
                           param:(NSDictionary*)param
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure{
    
    

    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_LOGIN];
    
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    //    [postDic setObject:[SaveEngine getDeviceUUID] forKey:@"device_id"];
    [postDic setObject:[SaveEngine getLoginAccount]?[SaveEngine getLoginAccount]:@"" forKey:@"user_name"];
    [postDic setObject:[SaveEngine getLoginPassord]?[SaveEngine getLoginPassord]:@"" forKey:@"user_pwd"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    

    NSSet *acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                     @"text/html",
                                     @"text/json",
                                     @"text/javascript",
                                     @"text/plain", nil];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    
    [manager POST:url
       parameters:loginDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             
             NSDictionary *dict = responseObject;
             BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
             
             if (isResulit) {
                
                 [SaveEngine saveTokenFromDic:dict];
               
                 
                 NSMutableDictionary *lastParaDic = [self decodeRequstData:param];
                 
                 if ([ lastParaDic objectForKey:@"token"]) {
                     [lastParaDic setObject:[SaveEngine getToken] forKey:@"token"];
                 }
                 NSDictionary *loginDic = [self createRequsetData:lastParaDic];
                 
                 
                 [manager POST:lastUrl
                    parameters:loginDic
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          
                      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject1) {
                          
                          
                          KK_EXECUTE_BLOCK(success,responseObject1);
                          
                          
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          KK_EXECUTE_BLOCK(failure,error);
                          
                      }];
                 
                 
             }
             else{
                 KK_EXECUTE_BLOCK(success,responseObject);
             }
             
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             KK_EXECUTE_BLOCK(failure,error);
             
         }];
}


@end
