//
//  SaveEngine.h
//  legend_business_ios
//
//  Created by heyk on 16/2/26.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
#import "NSObject+Port.h"


typedef enum {
    
    SettleType_None = 0,//未认证
    SettleType_Reviewing = 1 ,//审核中
    SettleType_Passed= 2,//审核通过
    SettleType_Failed = 3,//认证失败
}SettleType;


@interface SaveEngine : NSObject
/**
 *  是否已经登录
 *
 *  @return YES or NO
 */
+ (BOOL)isLogin;


/**
 *  用户信息相关
 *
 *  @param model 用户信息
 */
+ (void)saveUserInfo:(UserInfoModel*)model;
+ (UserInfoModel*)getUserInfo;
+ (void)clearUserInfo;


/**
 *  保存认证状态
 *
 *  @param str
 */
+ (void)saveSettleType:(NSString*)str;

/**
 *  获取认证状态
 *
 *  @return 认证状态
 */
+ (SettleType)getSettleType;


/**
 *  获取登录账号
 *
 *  @return
 */
+ (NSString*)getLoginAccount;

/**
 *  保存登陆账号
 *
 *  @param account
 */
+ (void)saveMyLoginAccount:(NSString*)account;


/**
 *  获取登陆密码
 *
 *  @return
 */
+ (NSString*)getLoginPassord;

/**
 * 保存登陆密码
 *
 *  @param pwd 
 */
+ (void)saveLoginPassword:(NSString*)pwd;


/**
 *  是否有绑定银行卡
 *
 *  @return  YES or NO
 */
+ (BOOL)haveBindingBankCard;

/**
 *  获取device ID
 *
 *  @return deivece ID
 */
+ (NSString*)getDeviceUUID;


/**
 *  保存网络请求得到的token
 *
 *  @param dic 网络请求结果
 */
+ (void)saveTokenFromDic:(NSDictionary*)dic;

/**
 *  获取token
 *
 *  @return 成功token,失败 nil
 */
+ (NSString*)getToken;




/**
 *  保存错误日志上传开关
 *
 *  @param bOpen Yes开，No关
 */
+ (void)saveErrorLogUploadSwtich:(BOOL)bOpen;

/**
 *  获取错误日志上传标记
 *
 *  @return yes需要上传错误日志，no不需要上传错误日志
 */
+ (BOOL)getErrorLogUploadSwitch;


/**
 *  保存版本信息
 *
 *  @param versionDic 版本信息
 */
+ (void)saveVersionInfo:(NSDictionary*)versionDic;

/**
 *  版本num,用于标记版本是不是该更新了
 *
 *  @return version_num
 */
+ (NSString*)getVersinNum;

/**
 *  版本no,用于展示要更新的版本信息
 *
 *  @return version_no
 */
+ (NSString*)getVersinNo;

/**
 *  获取新版更新提示语
 *
 *  @return 提示语
 */
+ (NSString*)getVersinDesc;

/**
 *  新版本更新链接
 *
 *  @return down_url
 */
+ (NSString*)getVersinDownURL;
/**
 *  版本是否需要强制更新
 *
 *  @return yes需要，no不需要
 */
+ (BOOL)versionForceUpdate;

/**
 * 获取本地银行列表
 *
 *  @return BankListVO list
 */
+ (NSArray*)getLocalBankList;
/**
 *  保存银行列表
 *
 *  @param list
 */
+ (void)saveBankList:(NSArray*)list;

@end
