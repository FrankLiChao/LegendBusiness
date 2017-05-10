//
//  SaveEngine.m
//  legend_business_ios
//
//  Created by heyk on 16/2/26.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "SaveEngine.h"
#import <UIKit/UIKit.h>
#import "EncryptionUserDefaults.h"
#import "legend_business_ios-swift.h"

@implementation SaveEngine

+ (BOOL)isLogin{
    
   // NSDictionary *user_info = [SaveEngine getUserInfo];
     NSString *user_info = [SaveEngine getLoginAccount];
    
    if (user_info && ![UitlCommon isNull:user_info]) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (void)saveUserInfo:(UserInfoModel*)model{
    
    if (model) {
        NSData *data = [model encodedToData];
        if ( data) {
            
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"user_info"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}


+ (UserInfoModel*)getUserInfo {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"];
    
    if (data) {
        UserInfoModel *model = [UserInfoModel getInstanceEncodeData:data ];
        return model;
    }
    return [[UserInfoModel alloc] init];
}

+ (void)clearUserInfo{

    [[EncryptionUserDefaults standardUserDefaults] removeObjectForKey:@"myLoginPassword"];
    [[EncryptionUserDefaults standardUserDefaults] removeObjectForKey:@"myLoginAccount"];
    
    [[EncryptionUserDefaults standardUserDefaults] removeObjectForKey:@"user_info"];
    [[EncryptionUserDefaults standardUserDefaults] synchronize];

}

+ (void)saveSettleType:(NSString*)str{
    
    [[EncryptionUserDefaults standardUserDefaults] setObject:str?[NSString stringWithFormat:@"%@",str]:@"" forKey:@"is_settle"];
    [[EncryptionUserDefaults standardUserDefaults] synchronize];

}

+ (SettleType)getSettleType{

    SettleType type = [[[EncryptionUserDefaults standardUserDefaults] objectForKey:@"is_settle"] intValue];
    
    return type;
}


+ (NSString*)getLoginAccount{

    return  [[EncryptionUserDefaults standardUserDefaults] objectForKey:@"myLoginAccount"];
}


+ (void)saveMyLoginAccount:(NSString*)account{

    [[EncryptionUserDefaults standardUserDefaults] setObject:account forKey:@"myLoginAccount"];
    [[EncryptionUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)getLoginPassord{

      return  [[EncryptionUserDefaults standardUserDefaults] objectForKey:@"myLoginPassword"];
}

+ (void)saveLoginPassword:(NSString*)pwd{
    
    [[EncryptionUserDefaults standardUserDefaults] setObject:pwd forKey:@"myLoginPassword"];
    [[EncryptionUserDefaults standardUserDefaults] synchronize];
}


+ (BOOL)haveBindingBankCard{
    return NO;
}

+ (NSString*)getDeviceUUID{
    
    NSString* uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return uuid;
}


+ (void)saveTokenFromDic:(NSDictionary*)dic{
    
    NSDictionary *data = [dic objectForKey:@"data"];
    if (data && [data isKindOfClass:[NSDictionary class]]) {
        NSString *token = [NSString stringWithFormat:@"%@",[data objectForKey:@"access_token"]?[data objectForKey:@"access_token"]:@""];
        if (token && token.length > 0) {
            [SaveEngine saveUserAccessToken:token];
        }
    }
}
+ (NSString*)getToken{
    
    NSString *token = [[EncryptionUserDefaults standardUserDefaults] objectForKey:@"user_access_token"];
    return token;
}

+ (void)saveUserAccessToken:(NSString*)token {
    token = [NSString stringWithFormat:@"%@",token?token:@""];
    [[EncryptionUserDefaults standardUserDefaults] setObject:token forKey:@"user_access_token"];
    [[EncryptionUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveErrorLogUploadSwtich:(BOOL)bOpen{
    
    [[EncryptionUserDefaults standardUserDefaults] setBool:bOpen forKey:@"error_upload_switch"];
    [[EncryptionUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getErrorLogUploadSwitch{

    return [[EncryptionUserDefaults standardUserDefaults] boolForKey:@"error_upload_switch"];
}


+ (void)saveVersionInfo:(NSDictionary*)versionDic{

    if(versionDic){
        [[EncryptionUserDefaults standardUserDefaults] setObject:versionDic forKey:@"version_info"];
        [[EncryptionUserDefaults standardUserDefaults] synchronize];
    }
}


+ (NSString*)getVersinNum{

    NSDictionary *dic = [[EncryptionUserDefaults standardUserDefaults] objectForKey:@"version_info"];
    if ( dic) {
        NSString *verionNun = [dic objectForKey:@"version_num"];
        
        verionNun = [NSString stringWithFormat:@"%@",verionNun?verionNun:@""];
        return verionNun;
    }
    return @"";
}

+ (NSString*)getVersinNo{

    NSDictionary *dic = [[EncryptionUserDefaults standardUserDefaults] objectForKey:@"version_info"];
    if ( dic) {
        NSString *verionNun = [dic objectForKey:@"version_no"];
        return verionNun;
    }
    return @"";
}


+ (NSString*)getVersinDesc{

    NSDictionary *dic = [[EncryptionUserDefaults standardUserDefaults] objectForKey:@"version_info"];
    if ( dic) {
        NSString *verionNun = [dic objectForKey:@"desc"];
        return verionNun;
    }
    return @"";
}


+ (NSString*)getVersinDownURL{


    NSDictionary *dic = [[EncryptionUserDefaults standardUserDefaults] objectForKey:@"version_info"];
    if ( dic) {
        NSString *verionNun = [dic objectForKey:@"down_url"];
        return verionNun;
    }
    return @"";
}

+ (BOOL)versionForceUpdate{

    NSDictionary *dic = [[EncryptionUserDefaults standardUserDefaults] objectForKey:@"version_info"];
    if ( dic) {
        BOOL bNeedForceUpdate = [[dic objectForKey:@"force"] boolValue];
        return bNeedForceUpdate;
    }
    return NO;
    
}

+ (NSArray*)getLocalBankList{

   NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"kBankList"];
    
    NSArray *array = [BankListVO mj_objectArrayWithKeyValuesArray:data];
    return array;
}


+ (void)saveBankList:(NSArray*)list{

    NSArray *data = [BankListVO mj_keyValuesArrayWithObjectArray:list];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"kBankList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
