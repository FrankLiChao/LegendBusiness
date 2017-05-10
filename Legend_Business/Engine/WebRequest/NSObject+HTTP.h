//
//  NSObject+HTTP.h
//  Test
//
//  Created by msb-ios-dev on 16/2/17.
//  Copyright © 2016年 msb-ios-dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define KK_EXECUTE_BLOCK(A,...)            if(A != NULL) {A(__VA_ARGS__);}




@interface   NSObject(HTTP)

////带session的请求开始
//- (void )HTTP:(NSString *)url
//                          params:(id)params
//                          cookie:(NSDictionary*)cookies
//                          method:(NSString *)method tag:(NSInteger)tag
//                         success:(void (^)( id responseObject))success
//                         failure:(void (^)( NSError *error))failure;
//
//
////开始请求
//- (void )HTTP:(NSString *)url params:(id)params method:(NSString *)method tag:(NSInteger)tag
//                         success:(void (^)(id responseObject))success
//                         failure:(void (^)( NSError *error))failure;
//
////开始请求（文件上传）
//- (void )HTTP:(NSString *)url params:(id)params method:(NSString *)method tag:(NSInteger)tag
//                        bodyPart:(void (^)(id <AFMultipartFormData> formData))bodyPart
//                         success:(void (^)( id responseObject))success
//                         failure:(void (^)(NSError *error))failure;
//
//
////GET请求
//- (void )GET:(NSString *)url params:(id)params tag:(NSInteger)tag
//                        success:(void (^)( id responseObject))success
//                        failure:(void (^)(NSError *error))failure;


- (bool)saveImageToCacheDirWithPath:(NSString*)directoryPath
                              image:(UIImage*)image
                          imageName:(NSString*)imageName
                          imageType:(NSString*)imageType;

- (void)deleteCacheImage:(NSString*)directoryPath;


//POST请求
- (void )POST:(NSString *)url
       params:(id)params
      success:(void (^)(id responseObject))success
      failure:(void (^)( NSError *error))failure;

//POST请求（文件上传）
- (void )POST:(NSString *)url
       params:(id)params
     bodyPart:(void (^)(id <AFMultipartFormData> formData))bodyPart
      success:(void (^)(id responseObject))success
      failure:(void (^)(NSError *error))failure;

- (void )POST:(NSString *)url
       params:(id)params
     bodyPart:(void (^)(id <AFMultipartFormData> formData))bodyPart
     progress:(void (^)(NSProgress* progress))progress
      success:(void (^)(id responseObject))success
      failure:(void (^)(NSError *error))failure;



@end
