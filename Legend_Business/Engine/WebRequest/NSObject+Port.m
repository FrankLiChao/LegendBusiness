//
//  NSObject+Port.m
//  legend_business_ios
//
//  Created by heyk on 16/2/25.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "NSObject+Port.h"
#import "NSObject+HTTP.h"
#import "DefineKey.h"
#import "NSObject+PortEncry.h"
#import "NSObject+PortError.h"
#import "SaveEngine.h"
#import "JSONParser.h"
#import "legend_business_ios-swift.h"

@implementation NSObject(Port)
//数据接口的网络请求
- (void)requestHTTPData:(NSString *)urlString parameters:(NSDictionary *)parameter success:(void (^)(id response))success failed:(void (^)(NSDictionary *errorDic))failed
{
    FLLog(@"urlString = %@",urlString);
    
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] initWithDictionary:parameter];
    NSDictionary *dataDic = [self createRequsetData:postDic];
    FLLog(@"整体结构 = %@%@%@",postDic,dataDic,urlString);
    
    [self POST:urlString params:dataDic success:^(id responseObject) {
        FLLog(@"%@",responseObject);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
        
        BOOL isResulit = [[responseObject objectForKey:@"result"] boolValue];
        if (isResulit) {
            NSDictionary *dataDic = [responseObject objectForKey:@"data"];
            success(dataDic);
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSAssert(failed, @"请处理错误");
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                NSNumber *errorcode = [[responseObject objectForKey:@"data"] objectForKey:@"error_code"];
                NSDictionary *dic = @{@"error_code":errorcode,
                                      @"error_msg":[[responseObject objectForKey:@"data"] objectForKey:@"error_msg"]};
                failed(dic);
            });
        }
    } failure:^(NSError *error) {
        FLLog(@"%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSAssert(failed, @"请处理错误");
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            NSDictionary *dic = @{@"error_msg":[error localizedDescription],
                                  @"error_code":@""};
            failed(dic);
        });
    }];
}

- (void)sendMsg:(NSString*)phone type:(SMSType)type comple:(void (^)(BOOL bSuccess,NSString *des))compleBlock{
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_SMS_CODE_BASED_URL,SYS_WEB_API_SENDMSG];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    //
    [postDic setObject:[SaveEngine getDeviceUUID] forKey:@"device_id"];
    [postDic setObject:[NSNumber numberWithInt:1] forKey:@"use_area"];
    [postDic setObject:[NSNumber numberWithInt:type] forKey:@"msg_type"];
    [postDic setObject:phone forKey:@"mobile_no"];
    FLLog(@"%@,%@",postDic,url);
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    
    [self POST:url params:loginDic
       success:^(id responseObject) {
           FLLog(@"%@",responseObject);
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               NSDictionary *data = [dict objectForKey:@"data"];
               NSString *message = [data objectForKey:@"msg"];
               KK_EXECUTE_BLOCK(compleBlock,YES,message);
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(compleBlock,NO,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(compleBlock,YES,@"网络错误");
       }];
    
    
}

- (void)checkMsgCode:(NSString*)phone
                type:(SMSType)type
                code:(NSString*)smsCode
             success:(void(^)(NSString* smsToken))success
              failed:(void(^)(NSString* errorDes))failed{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_SMS_CODE_BASED_URL,SYS_WEB_API_CHECK_MSG];
    
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:[SaveEngine getDeviceUUID] forKey:@"device_id"];
    [postDic setObject:[NSNumber numberWithInt:1] forKey:@"use_area"];
    [postDic setObject:smsCode forKey:@"sms_code"];
    [postDic setObject:phone forKey:@"mobile_no"];
    [postDic setObject:[NSNumber numberWithInt:type] forKey:@"msg_type"];
    
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    
    [self POST:url params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               NSDictionary *data = [dict objectForKey:@"data"];
               NSString *message = [data objectForKey:@"sms_token"];
               KK_EXECUTE_BLOCK(success,message);
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
    
    
}




- (void)uploadImage:(UIImage *)image
               type:(UploadImageType)img_type
           progress:(void (^)(NSProgress* progress))progressBlock
            success:(void(^)(NSString* imageURL))success
             failed:(void(^)(NSString* errorDes))failed{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_IMAGE_BASED_URL,SYS_WEB_API_UPLOAD_IMAGE];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:[SaveEngine getDeviceUUID] forKey:@"device_id"];
    
    if (UploadImageType_Undefine != img_type) {
        [postDic setObject:[NSNumber numberWithInteger:img_type] forKey:@"img_type"];
    }
    
    
    NSMutableDictionary *loginDic = [[NSMutableDictionary alloc] init];
    
    NSString *jsonstr = [self getJSONStr:postDic];
    jsonstr = [self URLEncodedString:jsonstr];
    [loginDic setObject:jsonstr forKey:@"data"];
    
    
    NSArray *arr = [self getSignArray:postDic];
    NSString *sign = [self getSign:arr];
    [loginDic setObject:sign forKey:@"sign"];
    
    //50kb压缩
    if(UIImagePNGRepresentation(image).length > 1024*50){
        
      NSData*  imageData = UIImageJPEGRepresentation(image, 0.4);
        image = [UIImage imageWithData:imageData];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.jpg",documentsDirectory,fileName];
    
    
    [self saveImageToCacheDirWithPath:documentsDirectory image:image imageName:fileName imageType:@"jpg"];
    
  
    
    [self POST:url
        params:loginDic
      bodyPart:^(id<AFMultipartFormData> formData) {
          
          NSError *error;
          [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"legend_image" error:&error];
         // [formData appendPartWithFormData:UIImagePNGRepresentation(image) name:@"legend_image"];
          if (error) {
              NSLog(@"error = %@",error);
          }
          
      } progress:^(NSProgress *progress) {
          
          
          progressBlock(progress);
          
      } success:^(id responseObject) {
          
          [self deleteCacheImage:filePath];
          
          NSDictionary *dict = responseObject;
          BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
          if (isResulit) {
              
              NSDictionary *data = [dict objectForKey:@"data"];
              NSString *imagePath = [data objectForKey:@"img_path"];
              KK_EXECUTE_BLOCK(success,imagePath);
              
          }
          else {
              
              NSString *version = [self errorAnalysis:dict request:loginDic url:url];
              KK_EXECUTE_BLOCK(failed,version);
          }
          
          
      } failure:^(NSError *error) {
          [self deleteCacheImage:filePath];
          
          KK_EXECUTE_BLOCK(failed,@"网络错误");
      }];
}


- (void)initRequst:(void (^)(BOOL bSuccess,NSString *errorDes))compleBlock{
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_INIT];
    
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:[NSNumber numberWithInt:4] forKey:@"device_type"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    
    [self POST:url params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               NSDictionary *data = [dict objectForKey:@"data"];
               
               BOOL error_upload_switch = [[data objectForKey:@"error_upload_switch"] boolValue];
               [SaveEngine saveErrorLogUploadSwtich:error_upload_switch];
               
               
               [SaveEngine saveVersionInfo:[data objectForKey:@"version_info"]];
               
               KK_EXECUTE_BLOCK(compleBlock,YES,nil);
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(compleBlock,NO,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(compleBlock,YES,@"网络错误");
       }];
}

- (void)loginRequst:(NSString*)userName
                pwd:(NSString*)pwd
            success:(void(^)(SettleType Settle))success
             failed:(void(^)(NSString* errorDes))failed{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_LOGIN];
    
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:userName forKey:@"user_name"];
    [postDic setObject:pwd forKey:@"user_pwd"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               
               NSString *is_settle = [[dict objectForKey:@"data"] objectForKey:@"is_settle"];
               [SaveEngine saveSettleType:is_settle];
               
               int value = 0;
               if ([is_settle isKindOfClass:[NSString class]]) {
                   value = [is_settle intValue];
               }
               
               
               KK_EXECUTE_BLOCK(success,value);
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
    
}


- (void)registerRequst:(NSString*)phoneNum
               smsCode:(NSString*)code
         recommendCode:(NSString*)recommendCode
               success:(void(^)(NSString* smsToken))success
                failed:(void(^)(NSString* errorDes))failed{
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_REGISTER];
    
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    //[postDic setObject:[SaveEngine getDeviceUUID] forKey:@"device_id"];
    [postDic setObject:code forKey:@"sms_code"];
    [postDic setObject:recommendCode forKey:@"recommend_code"];
    [postDic setObject:phoneNum forKey:@"mobile_no"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               
               NSString *sms_token = [[dict objectForKey:@"data"]objectForKey:@"sms_token"];
               
               KK_EXECUTE_BLOCK(success,sms_token);
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
}

- (void)setRegisterPWD:(NSString*)smsToken
               passowd:(NSString*)pwd
                comple:(void (^)(BOOL bSuccess,NSString *errorDes))compleBlock{
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_REGISTER_Set_PWD];
    
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    //    [postDic setObject:[SaveEngine getDeviceUUID] forKey:@"device_id"];
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:smsToken forKey:@"sms_token"];
    [postDic setObject:pwd forKey:@"user_pwd"];
    
    
    //暂时
    [postDic setObject:pwd forKey:@"re_pwd"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               KK_EXECUTE_BLOCK(compleBlock,YES,nil);
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(compleBlock,NO,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(compleBlock,NO,@"网络错误");
       }];
}

- (void)findPassword:(NSString*)phone
                 pwd:(NSString*)password
             smsToke:(NSString*)smsToken
              comple:(void (^)(BOOL bSuccess,NSString *errorDes))compleBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_Find_PWD];
    
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:phone forKey:@"mobile_no"];
    [postDic setObject:password forKey:@"user_pwd"];
    [postDic setObject:smsToken forKey:@"sms_token"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               KK_EXECUTE_BLOCK(compleBlock,YES,nil);
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(compleBlock,NO,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(compleBlock,NO,@"网络错误");
       }];
}

- (void)getSettle:(void(^)(SettleModel* model))success
           failed:(void(^)(NSString* errorDes))failed{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_GET_SETTLE];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               
               NSDictionary *seller_info = [[dict objectForKey:@"data"]objectForKey:@"info"];
               
               SettleModel *model = [SettleModel mj_objectWithKeyValues:seller_info];
               
               
               NSArray *id_imgArray = [seller_info objectForKey:@"id_img"];
               NSArray *licenseArray = [seller_info objectForKey:@"license"];
               NSArray *aptitudeArray = [seller_info objectForKey:@"aptitude"];
               NSArray *other_aptiudeArray = [seller_info objectForKey:@"other_aptiude"];
               
               model.id_img = id_imgArray;
               model.license = licenseArray;
               model.apitude = aptitudeArray;
               model.other_apitude = other_aptiudeArray;
               
               KK_EXECUTE_BLOCK(success,model);
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
}


- (void)checkSettleStatus:(void(^)(SettleType Settle, NSString* errorDes ))success
                   failed:(void(^)(NSString* errorDes))failed{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_CHECK_SETTLE];
    
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               
               NSString *is_settle = [[dict objectForKey:@"data"] objectForKey:@"is_settle"];
               [SaveEngine saveSettleType:is_settle];
               
               KK_EXECUTE_BLOCK(success,[is_settle intValue],[[dict objectForKey:@"data"] objectForKey:@"msg"]);
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
    
    
}

- (void)setSettle:(NSString*)companyName
    contact_phone:(NSString*)contact_phone
          operate:(NSString*)operate
           id_img:(NSArray*)id_img
          license:(NSArray*)license
          apitude:(NSArray*)apitude
    other_apitude:(NSArray*)other_apitude
           comple:(void (^)(BOOL bSuccess,NSString *errorDes))compleBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_SET_SETTLE];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:companyName forKey:@"company"];
    [postDic setObject:contact_phone forKey:@"contact_phone"];
    [postDic setObject:operate forKey:@"operate"];
    
    
    [postDic setObject:[id_img mj_JSONString] forKey:@"id_img"];
    [postDic setObject:[license mj_JSONString] forKey:@"license"];
    [postDic setObject:[apitude mj_JSONString] forKey:@"aptitude"];
    [postDic setObject:[other_apitude mj_JSONString] forKey:@"other_aptitude"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               
               KK_EXECUTE_BLOCK(compleBlock,YES,nil);
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(compleBlock,NO,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(compleBlock,NO,@"网络错误");
       }];
}



- (void)getUserInfo:(void(^)(UserInfoModel* model))success
             failed:(void(^)(NSString* errorDes))failed{
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_GET_USERINFO];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url params:loginDic
       success:^(id responseObject) {
           FLLog(@"%@",responseObject);
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               
               NSDictionary *seller_info = [[dict objectForKey:@"data"]objectForKey:@"seller_info"];
               
               UserInfoModel *model = [UserInfoModel mj_objectWithKeyValues:seller_info];
               
               [SaveEngine saveUserInfo:model];
               
               [[NSNotificationCenter defaultCenter] postNotificationName:SYS_NOTI_USERINFO_UPDATE object:nil];
               KK_EXECUTE_BLOCK(success,model);
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
    
}

- (void)getGoodCategoryList:(void(^)(NSArray<GoodsCategoryModel*>* array))success
                     failed:(void(^)(NSString* errorDes))failed{
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_GET_GOODS_CATEGORY_LIST];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               
               NSDictionary *service_category_list = [[[dict objectForKey:@"data"]objectForKey:@"service_category_list"] firstObject];
               GoodsCategoryModel *severModel = [GoodsCategoryModel mj_objectWithKeyValues:service_category_list];
               
               
               NSDictionary *simple_category_list = [[[dict objectForKey:@"data"]objectForKey:@"simple_category_list"] firstObject];
               GoodsCategoryModel *simpleModel = [GoodsCategoryModel mj_objectWithKeyValues:simple_category_list];
               
               NSMutableArray *array = [NSMutableArray array];
               
               if (severModel) {
                   [array addObject:severModel];
               }
               if (simpleModel) {
                   [array addObject:simpleModel];
               }
               
               KK_EXECUTE_BLOCK(success,array);
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
    
}


- (void)addGoods:(NSString*)goodsName
      categoryId:(NSString*)catId
           price:(float)shopPrice
        goodsNum:(int)goodsNum
      shareMoney:(float)shareMoney
      goodsBrief:(NSString*)des
     goodsPicDes:(NSArray*)picUrlArray
    galleryImage:(NSArray*)galleryImageURLArray
      goodsImage:(NSString*)goodsImageURLs
      goodsThumb:(NSString*)goodsthumb
        attrList:(NSArray<NSDictionary *> *)attrs
       isPrepare:(BOOL)bPrepare
     prepareTime:(NSTimeInterval)dates
       sellerTip:(NSString*)tip
       isEndorse:(BOOL)isEndorse
     shippingFee:(NSString *)shippingFee
    shippingFree:(NSString *)shippingFree
         success:(void(^)(NSString* goodId))success
          failed:(void(^)(NSString* errorDes))failed{
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_ADD_GOODS];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:goodsName forKey:@"goods_name"];
    [postDic setObject:catId forKey:@"cat_id"];
    [postDic setObject:[NSNumber numberWithFloat:shopPrice] forKey:@"shop_price"];
    [postDic setObject:[NSNumber numberWithInt:goodsNum] forKey:@"goods_number"];
//    [postDic setObject:[NSNumber numberWithFloat:shareMoney] forKey:@"share_money"];
//    [postDic setObject:des?des:@"" forKey:@"goods_brief"];
    [postDic setObject:picUrlArray forKey:@"goods_desc"];
    [postDic setObject:galleryImageURLArray forKey:@"gallery_img"];
    [postDic setObject:[galleryImageURLArray firstObject] forKey:@"goods_img"];
    [postDic setObject:goodsthumb forKey:@"goods_thumb"];
    [postDic setObject:@(isEndorse) forKey:@"is_endorse"];
    [postDic setObject:shippingFee forKey:@"shipping"];
    [postDic setObject:shippingFree forKey:@"shipping_free"];
    
    if (attrs) {
        if ([attrs isKindOfClass:[NSArray class]]) {
            NSString *attrString = [JSONParser parseToStringWithArray:attrs];
            [postDic setObject:attrString forKey:@"attr_list"];
        } else {
            NSString *attrJson = [attrs mj_JSONString];
            [postDic setObject:attrJson forKey:@"attr_list"];
        }
    }
    [postDic setObject:[NSNumber numberWithBool:bPrepare] forKey:@"is_prepare"];
    [postDic setObject:[NSNumber numberWithDouble:dates] forKey:@"prepare_time"];
    [postDic setObject:tip?tip:@"" forKey:@"goods_tips"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               NSString *goodID = [[dict objectForKey:@"data"] objectForKey:@"goods_id"];
               
               KK_EXECUTE_BLOCK(success,goodID);
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
    
}
- (void)editGoods:(NSString*)goodsId
        goodsName:(NSString*)goodsName
       categoryId:(NSString*)catId
            price:(float)shopPrice
         goodsNum:(int)goodsNum
       shareMoney:(float)shareMoney
       goodsBrief:(NSString*)des
      goodsPicDes:(NSArray*)picUrlArray
     galleryImage:(NSArray*)galleryImageURLArray
       goodsImage:(NSString*)goodsImageURLs
       goodsThumb:(NSString*)goodsthumb
         attrList:(NSArray<NSDictionary *> *)attrs
        isPrepare:(BOOL)bPrepare
      prepareTime:(NSTimeInterval)dates
        sellerTip:(NSString*)tip
        isEndorse:(BOOL)isEndorse
      shippingFee:(NSString *)shippingFee
     shippingFree:(NSString *)shippingFree
          success:(void(^)(NSString* goodId))success
           failed:(void(^)(NSString* errorDes))failed {
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_EDITE_GOODS];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:goodsId forKey:@"goods_id"];
    [postDic setObject:goodsName forKey:@"goods_name"];
    [postDic setObject:catId forKey:@"cat_id"];
    [postDic setObject:[NSNumber numberWithFloat:shopPrice] forKey:@"shop_price"];
    [postDic setObject:[NSNumber numberWithInt:goodsNum] forKey:@"goods_number"];
//    [postDic setObject:[NSNumber numberWithFloat:shareMoney] forKey:@"share_money"];
//    [postDic setObject:des?des:@"" forKey:@"goods_brief"];
    [postDic setObject:picUrlArray forKey:@"goods_desc"];
    [postDic setObject:galleryImageURLArray forKey:@"gallery_img"];
    [postDic setObject:[galleryImageURLArray firstObject] forKey:@"goods_img"];
    [postDic setObject:goodsthumb forKey:@"goods_thumb"];
    [postDic setObject:@(isEndorse) forKey:@"is_endorse"];
    [postDic setObject:shippingFee forKey:@"shipping"];
    [postDic setObject:shippingFree forKey:@"shipping_free"];
    
    if (attrs) {
        if ([attrs isKindOfClass:[NSArray class]]) {
            NSString *attrString = [JSONParser parseToStringWithArray:attrs];
            [postDic setObject:attrString forKey:@"attr_list"];
        } else {
            NSString *attrJson = [attrs mj_JSONString];
            [postDic setObject:attrJson forKey:@"attr_list"];
        }
    }
    [postDic setObject:[NSNumber numberWithBool:bPrepare] forKey:@"is_prepare"];
    [postDic setObject:[NSNumber numberWithDouble:dates] forKey:@"prepare_time"];
    [postDic setObject:tip?tip:@"" forKey:@"goods_tips"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               NSString *goodID = [[dict objectForKey:@"data"] objectForKey:@"goods_id"];
               
               KK_EXECUTE_BLOCK(success,goodID);
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
    
}

- (void)getGoodsList:(NSInteger)page
           goodsType:(ProuductListType)listType
             success:(void(^)(NSArray<ProductListModel*>* array ,NSInteger totalPage, NSInteger saleCount, NSInteger downCount))success
              failed:(void(^)(NSString* errorDes))failed{
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_GET_SELLER_GOODS_LIST];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:[SaveEngine getDeviceUUID] forKey:@"device_id"];
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [postDic setObject:[NSNumber numberWithInteger:listType] forKey:@"goods_type"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    

    
    [self POST:url params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               
               NSDictionary *data = [dict objectForKey:@"data"];
               
               NSInteger totalPage = [[data objectForKey:@"total_page"] integerValue];
               NSInteger saleCount = [[data objectForKey:@"sale_count"] integerValue];
               NSInteger downCount = [[data objectForKey:@"down_count"] integerValue];
               NSArray *list = [data objectForKey:@"list"];
               
               NSMutableArray *result  = [ProductListModel mj_objectArrayWithKeyValuesArray:list];
               KK_EXECUTE_BLOCK(success,result,totalPage,saleCount,downCount);
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
    
    
}

- (void)changeGoodsStatus:(int)status
                  goodsID:(NSString*)goodId
                  success:(void(^)())success
                   failed:(void(^)(NSString* errorDes))failed{
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_CHANGE_GOODS_STATUS];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:goodId forKey:@"goods_id"];
    [postDic setObject:[NSNumber numberWithInt:status] forKey:@"goods_status"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               KK_EXECUTE_BLOCK(success,nil);
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
}

- (void)getGoodInfo:(NSString*)goodId
            success:(void(^)(ProductDetailModel *mdel))success
             failed:(void(^)(NSString* errorDes))failed{
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_GET_GOODS_INFO];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:goodId forKey:@"goods_id"];
    
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               NSDictionary *data = [dict objectForKey:@"data"];
               
               NSDictionary *info = [data objectForKey:@"info"];
               if(info && [info isKindOfClass:[NSDictionary class]]){
                   NSDictionary *goods_detail = [info objectForKey:@"goods_detail"];
                   NSArray *array = [info objectForKey:@"goods_size"];
                   
                   
                   ProductDetailModel *model = [ProductDetailModel mj_objectWithKeyValues:goods_detail];
                   
                   NSArray *attrList = [ProductAttrModel mj_objectArrayWithKeyValuesArray:array];
                   model.goods_size = attrList;
                   
                   KK_EXECUTE_BLOCK(success,model);
                   
               }
               else{
                   KK_EXECUTE_BLOCK(success,nil);
               }
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
    
}

- (void)getOrderList:(NSString*)lastOrderId
         orderStatus:(OrderStatusType)oderType
             success:(void(^)(NSArray<OrderListModel*>* array))success
              failed:(void(^)(NSString* errorDes))failed{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_GET_ORDER_LIST];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:lastOrderId?lastOrderId:@"" forKey:@"last_order_id"];
    [postDic setObject:[NSNumber numberWithInt:oderType] forKey:@"order_status"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               
               NSDictionary *data = [dict objectForKey:@"data"];
               NSArray *list = [data objectForKey:@"order_list"];
               
               NSMutableArray *result  = [OrderListModel mj_objectArrayWithKeyValuesArray:list];
               KK_EXECUTE_BLOCK(success,result);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
}

- (void)searchOrderList:(NSString*)lastOrderId
            orderStatus:(OrderStatusType)oderType
               keywords:(NSString*)keywords
                success:(void(^)(NSArray<OrderListModel*>* array))success
                 failed:(void(^)(NSString* errorDes))failed;{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_GET_ORDER_LIST];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:lastOrderId?lastOrderId:@"" forKey:@"last_order_id"];
    [postDic setObject:[NSNumber numberWithInt:oderType] forKey:@"order_status"];
    [postDic setObject:keywords forKey:@"keywords"];
    
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               
               NSDictionary *data = [dict objectForKey:@"data"];
               NSArray *list = [data objectForKey:@"order_list"];
               
               NSMutableArray *result  = [OrderListModel mj_objectArrayWithKeyValuesArray:list];
               KK_EXECUTE_BLOCK(success,result);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
}

- (void)orderVerifyExchangeCode:(NSString*)code
                        success:(void(^)(NSString *orderId))success
                         failed:(void(^)(NSString* errorDes))failed{
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_VERIFY_EXCHANGE_CODE];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:code forKey:@"exchange_code"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               NSString *orderId = [[dict objectForKey:@"data"] objectForKey:@"order_id"];
               
               KK_EXECUTE_BLOCK(success,orderId);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
}


- (void)getOrderDetail:(NSString*)orderId
               success:(void(^)(OrderModel* model))success
                failed:(void(^)(NSString* errorDes))failed{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_GET_ORDER_DETAIL];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:orderId forKey:@"order_id"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url params:loginDic
       success:^(id responseObject) {
           FLLog(@"%@",responseObject);
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               
               NSDictionary *info = [[dict objectForKey:@"data"] objectForKey:@"info"];
               OrderModel *model = [OrderModel mj_objectWithKeyValues:info];
               
               KK_EXECUTE_BLOCK(success,model);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
}

- (void)modifyOrderStatus:(NSString*)orderId
                expressId:(NSString *)expressId
                   status:(int)status
                  success:(void(^)())success
                   failed:(void(^)(NSString* errorDes))failed{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_MODIFY_ORDER_STATUS];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:orderId forKey:@"order_id"];
    [postDic setObject:[NSNumber numberWithInt:status] forKey:@"order_status"];
    [postDic setObject:expressId forKey:@"shipping_number"];
    FLLog(@"%@",postDic);
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               
               
               KK_EXECUTE_BLOCK(success);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
}


- (void)getSellerAfterList:(NSString*)lastId
                    status:(int)status
                   success:(void(^)(NSArray<SellerAfterListModel*>* array,NSString *returnAddr ,int status))success
                    failed:(void(^)(NSString* errorDes,int status))failed{
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_GET_SELLER_AFTER_LIST];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:[SaveEngine getDeviceUUID] forKey:@"device_id"];
    [postDic setObject:lastId forKey:@"last_id"];
    [postDic setObject:[NSNumber numberWithInt:status] forKey:@"do_status"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    __block int st = status;
    
    [self POST:url params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               
               NSArray *array = nil;
               NSArray *data = [[dict objectForKey:@"data"] objectForKey:@"list"];
               
               if ( data) {
                   array = [SellerAfterListModel mj_objectArrayWithKeyValuesArray:data];
               }
               
               NSString *returnAddr = [[dict objectForKey:@"data"] objectForKey:@"return_addr"];
               KK_EXECUTE_BLOCK(success,array,returnAddr,st);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version,st);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误",st);
       }];
    
}


- (void)refuseAfter:(NSString*)afterId
             reason:(NSString*)reason
             comple:(void (^)(BOOL bSuccess,NSString *message))compleBlock{
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_REFUSE_AFTER];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:[SaveEngine getDeviceUUID] forKey:@"device_id"];
    [postDic setObject:afterId forKey:@"after_id"];
    [postDic setObject:reason forKey:@"refuse_reason"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               NSString *message = [[dict objectForKey:@"data"] objectForKey:@"msg"];
               
               KK_EXECUTE_BLOCK(compleBlock,YES,message);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(compleBlock,NO,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(compleBlock,NO,@"网络错误");
       }];
}

- (void)afterSureRecive:(NSString*)afterId
                 comple:(void (^)(BOOL bSuccess,NSString *message))compleBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_VERIFY_AFTET_GOODS];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
//    [postDic setObject:[SaveEngine getDeviceUUID] forKey:@"device_id"];
    [postDic setObject:afterId forKey:@"after_id"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               NSString *message = [[dict objectForKey:@"data"] objectForKey:@"msg"];
               
               KK_EXECUTE_BLOCK(compleBlock,YES,message);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(compleBlock,NO,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(compleBlock,NO,@"网络错误");
       }];
    
}

- (void)afterSureAndSendRecive:(NSString*)afterId
                   postCompany:(NSString*)name
                       postNum:(NSString*)num
                        comple:(void (^)(BOOL bSuccess,NSString *message))compleBlock{
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_VERIFY_AFTET_GOODS];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:name forKey:@"se_expr_company"];
    [postDic setObject:num forKey:@"se_expr_num"];
    [postDic setObject:afterId forKey:@"after_id"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               NSString *message = [[dict objectForKey:@"data"] objectForKey:@"msg"];
               
               KK_EXECUTE_BLOCK(compleBlock,YES,message);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(compleBlock,NO,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(compleBlock,NO,@"网络错误");
       }];

}

- (void)sellerAgreeAfter:(NSString*)afterId
          recieveAddress:(NSString*)addr
                  comple:(void (^)(BOOL bSuccess,NSString *message))compleBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_AFTET_AGREE_AFTER];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:[SaveEngine getDeviceUUID] forKey:@"device_id"];
    [postDic setObject:afterId forKey:@"after_id"];
    [postDic setObject:addr forKey:@"return_addr"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               NSString *message = [[dict objectForKey:@"data"] objectForKey:@"msg"];
               
               KK_EXECUTE_BLOCK(compleBlock,YES,message);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(compleBlock,NO,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(compleBlock,NO,@"网络错误");
       }];
}


- (void)getCommentsList:(NSString*)lastId
                success:(void(^)(NSArray<CommentsModel*>* array))success
                 failed:(void(^)(NSString* errorDes))failed{
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_GET_COMMENT_LIST];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
//    [postDic setObject:[SaveEngine getDeviceUUID] forKey:@"device_id"];
    [postDic setObject:lastId forKey:@"last_id"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               NSArray *data = [[dict objectForKey:@"data"] objectForKey:@"list"];
               
               NSArray *result = [CommentsModel mj_objectArrayWithKeyValuesArray:data];
               
               KK_EXECUTE_BLOCK(success,result);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
    
}

- (void)addCmmentsReply:(NSString*)commentID
           replyContent:(NSString*)content
                success:(void(^)())success
                 failed:(void(^)(NSString* errorDes))failed{
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_ADD_COMMENTS_REPLAY];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:[SaveEngine getDeviceUUID] forKey:@"device_id"];
    [postDic setObject:commentID forKey:@"comment_id"];
    [postDic setObject:content forKey:@"reply_content"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               KK_EXECUTE_BLOCK(success);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
}


- (void)getDoingMaskList:(int)page
                 success:(void(^)(NSArray<MaskListModel*>* array, NSInteger totalPage))success
                  failed:(void(^)(NSString* errorDes))failed{
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_GET_MASK_LIST];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:[NSNumber numberWithInt:1] forKey:@"type"];
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               
               NSArray *mission = [[dict objectForKey:@"data"] objectForKey:@"mission"];
               NSArray *array = [MaskListModel mj_objectArrayWithKeyValuesArray:mission];
               
               
               KK_EXECUTE_BLOCK(success,array,1);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
}

- (void)getFinishMaskList:(int)page
                  success:(void(^)(NSArray<MaskListModel*>* array, NSInteger totalPage))success
                   failed:(void(^)(NSString* errorDes))failed{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_GET_MASK_LIST];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    
    [postDic setObject:[NSNumber numberWithInt:2] forKey:@"type"];
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               
               
               int  totoalPage = [[[dict objectForKey:@"data"] objectForKey:@"total_page"] intValue];
               NSArray *mission = [[dict objectForKey:@"data"] objectForKey:@"mission"];
               NSArray *array = [MaskListModel mj_objectArrayWithKeyValuesArray:mission];

               KK_EXECUTE_BLOCK(success,array,totoalPage);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
}


- (void)addMask:(NSString*)title
            des:(NSString*)des
      targetnum:(int)num
     uinitPrice:(float)price
      timeLimit:(float)timeLime
         damand:(int)damand
        goodsId:(NSString*)goodsId
        success:(void(^)(NSString *orderId,NSNumber *myMoney,NSNumber *oderPrice ))success
         failed:(void(^)(NSString* errorDes))failed{
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_RELEASE_MASK];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:title forKey:@"title"];
    [postDic setObject:des forKey:@"desc"];
    [postDic setObject:[NSNumber numberWithInt:num] forKey:@"target_number"];
    [postDic setObject:[NSNumber numberWithFloat:price] forKey:@"unit_price"];
    [postDic setObject:[NSNumber numberWithFloat:timeLime] forKey:@"time_limit"];
    [postDic setObject:goodsId forKey:@"goods_id"];
    [postDic setObject:[NSNumber numberWithInt:damand] forKey:@"demand"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               
               NSDictionary *order_info = [[dict objectForKey:@"data"]objectForKey:@"order_info"];
               NSString *oderNum = [order_info objectForKey:@"order_no"];
               NSNumber *myMoney = [order_info objectForKey:@"user_money"];
               NSNumber *orderMoney = [order_info objectForKey:@"order_money"];
               KK_EXECUTE_BLOCK(success,oderNum,myMoney,orderMoney);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
}


- (void)maskPay:(PayType)payType
       password:(NSString*)password
        orderNo:(NSString*)orderNo
        success:(void(^)(Order *order,PayType type))success
         failed:(void(^)(NSString* errorDes))failed{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_MASK_PAY];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:[NSNumber numberWithInt:payType] forKey:@"pay_type"];

    if (password) {
        
        NSString *passwordKey = [NSString stringWithFormat:@"%@%@",password,DES_KEY];
        NSString *md5Password = [[EncryptionUserDefaults standardUserDefaults] getMd5_32Bit_String:passwordKey];
        
        [postDic setObject:md5Password?md5Password:@"" forKey:@"payment_pwd"];
    }
    if (!orderNo) {
        
        failed(@"出错了，没有订单ID");
        return;
    }
    
    [postDic setObject:orderNo forKey:@"order_no"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    __block PayType type1 = payType;
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               NSDictionary *dic = [dict objectForKey:@"data"];
              
               if (type1 == PayType_Yue) {
                   
                   KK_EXECUTE_BLOCK(success,nil,PayType_Yue);
               }
               else if(type1 == PayType_Alipay){
                   
                   Order *order = [Order mj_objectWithKeyValues:dic];
                   
                   KK_EXECUTE_BLOCK(success,order,PayType_Alipay);
                   
               }
               else if(type1 == PayType_Wechat){
                   
                   Order *order = [Order mj_objectWithKeyValues:dic];
                   SignaturedataModel *signate = [SignaturedataModel mj_objectWithKeyValues:[dic objectForKey:@"signature_data"]];
                   order.sigatureData = signate;
                   
                   KK_EXECUTE_BLOCK(success,order,PayType_Wechat);
                   
               }
               
               
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];

}



- (void)getMaskInfo:(NSString*)maskId
            success:(void(^)(MaskInfoModel *model))success
             failed:(void(^)(NSString* errorDes))failed{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_GET_MASK_DETAIL];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:maskId forKey:@"mission_id"];
    
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               
               NSDictionary *mission_info = [[dict objectForKey:@"data"] objectForKey:@"mission_info"];
               
               MaskInfoModel *info = [MaskInfoModel mj_objectWithKeyValues:mission_info];
               KK_EXECUTE_BLOCK(success,info);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
}




- (void)changeUsrInfo:(ChangeUserInfoType)type
                value:(id)value
               comple:(void (^)(BOOL bSuccess,NSString *message))compleBlock{
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_CHANGE_USERINFO];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:[UserInfoModel changeTypeStr:type] forKey:@"field"];
    [postDic setObject:value forKey:@"value"];
    
    FLLog(@"%@",postDic);
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               KK_EXECUTE_BLOCK(compleBlock,YES,nil);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(compleBlock,NO,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(compleBlock,NO,@"网络错误");
       }];
}


- (void)getSellerCategoryList:(void(^)(NSArray<SellerCategoryModel *> *array))success
                       failed:(void(^)(NSString* errorDes))failed{
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_GET_SELLER_CATEGORY];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    FLLog(@"%@",postDic);
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           FLLog(@"%@",responseObject);
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               
               NSDictionary *list = [[dict objectForKey:@"data"]objectForKey:@"list"];
               NSArray *array = [SellerCategoryModel mj_objectArrayWithKeyValuesArray:list];
               
               KK_EXECUTE_BLOCK(success,array);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
    
}


- (void)modifyPassword:(NSString*)password
           oldPassword:(NSString*)oldPassword
              smsToken:(NSString*)smsToken
                  type:(int)type
                comple:(void (^)(BOOL bSuccess,NSString *message))compleBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_MODIFY_PASSWORD];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:[NSNumber numberWithInt:type] forKey:@"type"];
  
    if (smsToken) {
            [postDic setObject:smsToken forKey:@"sms_token"];
    }

    if (type == 2) {//修改交易密码
        
        NSString *passwordKey = [NSString stringWithFormat:@"%@%@",password,DES_KEY];
        NSString *md5Password = [[EncryptionUserDefaults standardUserDefaults] getMd5_32Bit_String:passwordKey];
        
        [postDic setObject:md5Password?md5Password:@"" forKey:@"new_password"];
        
    }
    else {
       [postDic setObject:password forKey:@"new_password"];
    }
 
    
    
    if (oldPassword) {
           [postDic setObject:oldPassword forKey:@"old_password"];
    }
 
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               KK_EXECUTE_BLOCK(compleBlock,YES,nil);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(compleBlock,NO,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(compleBlock,NO,@"网络错误");
       }];


}


- (void)getBankList:(void(^)(NSArray<BankListVO *> *array))success
             failed:(void(^)(NSString* errorDes))failed{

    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_BANK_LIST];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
     NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               NSArray *bank_list = [[dict objectForKey:@"data"] objectForKey:@"bank_list"];
               NSArray *result = [BankListVO mj_objectArrayWithKeyValuesArray:bank_list];
            
               [SaveEngine saveBankList:result];
               
               KK_EXECUTE_BLOCK(success,result);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];

}

- (void)getMyBankCardList:(void(^)(NSArray<MyBankListVO *> *array))success
                   failed:(void(^)(NSString* errorDes))failed{

    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_GET_MY_BANK_LIST];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               NSArray *bank_list = [[dict objectForKey:@"data"] objectForKey:@"bank_info"];
               NSArray *result = [MyBankListVO mj_objectArrayWithKeyValuesArray:bank_list];
               
               KK_EXECUTE_BLOCK(success,result);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
}



- (void)addBankCard:(NSString*)bankId
             bankNo:(NSString*)bankNo
          ownerName:(NSString*)name
            success:(void(^)(NSString *msg))success
             failed:(void(^)(NSString* errorDes))failed{

    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_ADD_BANK_CARD];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
        [postDic setObject:bankId forKey:@"bank_id"];
        [postDic setObject:bankNo forKey:@"bank_no"];
        [postDic setObject:name forKey:@"owner_name"];
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               NSString *msg = [[dict objectForKey:@"data"] objectForKey:@"msg"];

               KK_EXECUTE_BLOCK(success,msg);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
}

- (void)unLockBankCard:(NSString*)bankId
               success:(void(^)( ))success
                failed:(void(^)(NSString* errorDes))failed{

    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_UNLOCK_CARD];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:bankId forKey:@"bank_id"];
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];

               KK_EXECUTE_BLOCK(success,nil);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
}


- (void)getGoingMoney:(NSString*)lastId
              success:(void(^)(NSArray<PacketOrderModel *> *array ))success
               failed:(void(^)(NSString* errorDes))failed{

    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_GET_MODIFY_MONEY];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:lastId forKey:@"last_id"];
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               NSArray *list = [[dict objectForKey:@"data"] objectForKey:@"list"];
               
               NSArray *reuslt = [PacketOrderModel mj_objectArrayWithKeyValuesArray:list];
               KK_EXECUTE_BLOCK(success,reuslt);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
}


- (void)getMyIncome:(void(^)(PacketModel *model))success
             failed:(void(^)(NSString* errorDes))failed{

    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_GET_MY_INCOME];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               NSDictionary  *data = [dict objectForKey:@"data"];
               PacketModel *model = [PacketModel mj_objectWithKeyValues:data];
               
               KK_EXECUTE_BLOCK(success,model);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
}

- (void)getMyIncomeList:(NSString*)lastId
                success:(void(^)(NSArray <CashHistoryModel*> *model,int count))success
                 failed:(void(^)(NSString* errorDes))failed{

    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_MY_INCOME_LIST];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:lastId forKey:@"last_id"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               int count = [[[dict objectForKey:@"data"] objectForKey:@"count"] intValue];
               NSArray  *list = [[dict objectForKey:@"data"] objectForKey:@"list"];
               
               NSArray *result = [CashHistoryModel mj_objectArrayWithKeyValuesArray:list];
               KK_EXECUTE_BLOCK(success,result,count);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
    
}



- (void)takeCash:(NSString*)bankId
           money:(float)money
        password:(NSString*)password
         success:(void(^)(NSString *msg,NSString* myMoney))success
          failed:(void(^)(NSString* errorDes))failed{


    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_TAKE_CASH];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:bankId forKey:@"bank_id"];
    [postDic setObject:[NSNumber numberWithFloat:money] forKey:@"money"];
    
    
    NSString *passwordKey = [NSString stringWithFormat:@"%@%@",password,DES_KEY];
    NSString *md5Password = [[EncryptionUserDefaults standardUserDefaults] getMd5_32Bit_String:passwordKey];
    
    [postDic setObject:password?md5Password:@"" forKey:@"payment_pwd"];
    
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               NSString  *message = [[dict objectForKey:@"data"] objectForKey:@"msg"];
               NSString  *myMoney = [[dict objectForKey:@"data"] objectForKey:@"left_money"];
               
               KK_EXECUTE_BLOCK(success,message,myMoney);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
    
}

- (void)getCashHistory:(NSString*)last_id
               success:(void(^)(NSArray <CashHistoryModel*> *msg,int count))success
                failed:(void(^)(NSString* errorDes))failed{

    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_CASH_HISTORY_LIST];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:last_id forKey:@"last_id"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               int count = [[[dict objectForKey:@"data"] objectForKey:@"count"] intValue];
               NSArray  *list = [[dict objectForKey:@"data"] objectForKey:@"list"];
               
               NSArray *result = [CashHistoryModel mj_objectArrayWithKeyValuesArray:list];
               KK_EXECUTE_BLOCK(success,result,count);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
}


- (void)getDealingMoneyList:(NSString*)last_id
                    success:(void(^)(NSArray <CashHistoryModel*> *msg,int count))success
                     failed:(void(^)(NSString* errorDes))failed{

    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_GET_DEALING_LIST];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:last_id forKey:@"last_id"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               int count = [[[dict objectForKey:@"data"] objectForKey:@"count"] intValue];
               NSArray  *list = [[dict objectForKey:@"data"] objectForKey:@"list"];
               
               NSArray *result = [CashHistoryModel mj_objectArrayWithKeyValuesArray:list];
               KK_EXECUTE_BLOCK(success,result,count);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
}


- (void)getMyAdvList:(int)page
             success:(void(^)(NSArray <PromotionListModel*> *advList, int totoalPage))success
              failed:(void(^)(NSString* errorDes))failed{


    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEN_API_GET_ADV_LIST];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               int totoalPage = [[[dict objectForKey:@"data"] objectForKey:@"total_page"] intValue];
               NSArray  *list = [[dict objectForKey:@"data"] objectForKey:@"task_list"];
               
               NSArray *result = [PromotionListModel mj_objectArrayWithKeyValuesArray:list];
               KK_EXECUTE_BLOCK(success,result,totoalPage);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
}


- (void)relaseAdver:(NSString*)title
               desc:(NSString*)desc
            goodsId:(NSString*)goodsId
          unitPrice:(float)unit_price
          targetNum:(int)target_number
        targetMoney:(float)target_money
          startTime:(NSString*)start_time
            endTime:(NSString*)end_time
            tplType:(int)tpl_type
          shareDesc:(NSString*)share_desc
              extra:(NSArray*)extra
            success:(void(^)(NSString *orderId,NSNumber *myMoney,NSNumber *oderPrice ))success
             failed:(void(^)(NSString* errorDes))failed{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEN_API_REALEASE_ADV];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:title forKey:@"title"];
    [postDic setObject:desc?desc:@"" forKey:@"desc"];
    [postDic setObject:goodsId forKey:@"goods_id"];
    [postDic setObject:[NSNumber numberWithFloat:unit_price] forKey:@"unit_price"];
    [postDic setObject:start_time forKey:@"start_time"];
    [postDic setObject:[NSNumber numberWithInt:target_number] forKey:@"target_number"];
    [postDic setObject:[NSNumber numberWithInt:target_money] forKey:@"target_money"];
    [postDic setObject:end_time forKey:@"end_time"];
    [postDic setObject:[NSNumber numberWithInt:tpl_type] forKey:@"tpl_type"];
    [postDic setObject:extra?[extra mj_JSONString]:@"" forKey:@"extra"];
    [postDic setObject:share_desc?share_desc:@"" forKey:@"share_desc"];

    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
      
               NSDictionary  *order_info = [[dict objectForKey:@"data"] objectForKey:@"order_info"];
               NSString *orderId = [order_info objectForKey:@"order_no"];
               NSNumber *myMoney = [order_info objectForKey:@"user_money"];
               NSNumber *oderPrice = [order_info objectForKey:@"order_money"];
               
               KK_EXECUTE_BLOCK(success,orderId,myMoney,oderPrice);
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];

}

- (void)advPay:(PayType)type
      password:(NSString*)password
       orderID:(NSString*)orderId
       success:(void(^)(Order *order,int type))success
        failed:(void(^)(NSString* errorDes))failed{

    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEN_API_ADV_PAY];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    [postDic setObject:[NSNumber numberWithInt:type] forKey:@"pay_type"];
    
   // [postDic setObject:password?password:@"" forKey:@"payment_password"];
    
    NSString *passwordKey = [NSString stringWithFormat:@"%@%@",password,DES_KEY];
    NSString *md5Password = [[EncryptionUserDefaults standardUserDefaults] getMd5_32Bit_String:passwordKey];
    
    [postDic setObject:password?md5Password:@"" forKey:@"payment_pwd"];
    
    
    if (!orderId) {
        
        failed(@"出错了，没有订单ID");
        return;
    }
    __block int type1 = type;
    
    
    [postDic setObject:orderId forKey:@"order_no"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               
               NSDictionary *dic = [dict objectForKey:@"data"];
               
               if (type1 == PayType_Yue) {
                   
                   KK_EXECUTE_BLOCK(success,nil,PayType_Yue);
               }
               else if(type1 == PayType_Alipay){
               
                   Order *order = [Order mj_objectWithKeyValues:dic];
                   
                   KK_EXECUTE_BLOCK(success,order,PayType_Alipay);

               }
               else if(type1 == PayType_Wechat){
                   
                   Order *order = [Order mj_objectWithKeyValues:dic];
                   SignaturedataModel *signate = [SignaturedataModel mj_objectWithKeyValues:[dic objectForKey:@"signature_data"]];
                   order.sigatureData = signate;
                   
                   KK_EXECUTE_BLOCK(success,order,PayType_Wechat);
                   
               }
               
               
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
    

}

- (void)inviteSeller:(void(^)(NSString* imageUrl, NSString *code,NSString *link,NSString *recommend))success
              failed:(void(^)(NSString* errorDes))failed{

    
    NSString *url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_API_INVITE_SELLER];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:[SaveEngine getToken] forKey:@"token"];
    
    NSDictionary *loginDic = [self createRequsetData:postDic];
    
    [self POST:url
        params:loginDic
       success:^(id responseObject) {
           
           NSDictionary *dict = responseObject;
           BOOL isResulit = [[dict objectForKey:@"result"] boolValue];
           if (isResulit) {
               
               [SaveEngine saveTokenFromDic:dict];
               
               NSString *recommended_encode = [[dict objectForKey:@"data"] objectForKey:@"recommended_encode"];
               NSString *code_thumb = [[[dict objectForKey:@"data"] objectForKey:@"share_info"] objectForKey:@"code_thumb"];
               NSString *link_url = [[[dict objectForKey:@"data"] objectForKey:@"share_info"] objectForKey:@"link_url"];
               NSString *recommend = [[[dict objectForKey:@"data"] objectForKey:@"share_info"] objectForKey:@"recommend"];
               
               KK_EXECUTE_BLOCK(success,code_thumb,recommended_encode,link_url,recommend);
           }
           else{
               
               NSString *version = [self errorAnalysis:dict request:loginDic url:url];
               KK_EXECUTE_BLOCK(failed,version);
           }
           
       } failure:^(NSError *error) {
           
           KK_EXECUTE_BLOCK(failed,@"网络错误");
       }];
}

@end
