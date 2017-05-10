//
//  DefineKey.h
//  legend_business_ios
//
//  Created by msb-ios-dev on 16/2/20.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <Foundation/Foundation.h>

//方便调试，可以打印对应的调试方法和行号
#ifdef DEBUG
#   define FLLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__);
#else
#   define FLLog(...)
#endif

#ifdef DEBUG

#   define SYS_WEB_BASED_URL                   @"http://web03seller.say168.net"//商家版测试地址
#   define SYS_WEB_SMS_CODE_BASED_URL          @"http://web03debug.say168.net" //短信验证码服务器地址
#   define SYS_WEB_IMAGE_BASED_URL             @"http://debugimg.say168.net" //图片服务器地址
#   define DES_KEY                             @"qwe45678"
#else

#   define SYS_WEB_BASED_URL                   @"https://seller.say168.net"//@"http://web03seller.say168.net"
#   define SYS_WEB_SMS_CODE_BASED_URL          @"https://api.say168.net" //短信验证码服务器地址
#   define SYS_WEB_IMAGE_BASED_URL             @"http://img.say168.net" //图片服务器地址
#define DES_KEY                                @"r2qrwq3*"
#define TOKEN_DES_KEY                          @"!@0182j3"

#endif

//接口路径全拼
#define PATH(_path) [NSString stringWithFormat:@"%@/%@",SYS_WEB_BASED_URL,_path]
#define PATHMsg(_path) [NSString stringWithFormat:@"%@/%@",SYS_WEB_SMS_CODE_BASED_URL,_path]
#define PATHImg(_path) [NSString stringWithFormat:@"%@/%@",SYS_WEB_IMAGE_BASED_URL,_path]

// 屏幕长宽
#define DeviceMaxHeight ([UIScreen mainScreen].bounds.size.height)
#define DeviceMaxWidth ([UIScreen mainScreen].bounds.size.width)
#define widthRate DeviceMaxWidth/375

#define viewColor [UIColor colorFromHexRGB:@"f5f5f5"]

//系统版本
#define SYS_VERSION  [[UIDevice currentDevice].systemVersion doubleValue]

#define BADIDU_LOACTION_API_KEY @"n9CYIThfQN6o6laPKMOKk8pd"

//微信APPKey
#define WeChatKey  @"wxf5e7535a93de066e"

//版本号
#define NOW_VERSION_NUM  @"3"

//Mark - Notification Key
#define  SYS_NOTI_NEED_LOGIN @"SYS_NOTI_NEED_LOGIN"

//确认发货通知
#define  SYS_NOTI_SURE_SEND_ORDER @"SYS_NOTI_SURE_SEND_ORDER"

//拒绝买家收货通知
#define SYS_NOTI_REFUSE_BUYER_AFTER @"SYS_NOTI_REFUSE_BUYER_AFTER"

//添加评价回复通知
#define SYS_NOTI_ADD_COMMNET_REPLY @"SYS_NOTI_ADD_COMMNET_REPLY"

//个人信息获取完成/更新通知
#define SYS_NOTI_USERINFO_UPDATE @"SYS_NOTI_USERINFO_UPDATE"

//微信支付成功
#define SYS_WECHAT_PAY_SUCCESS_NOTIFY @"SYS_WECHAT_PAY_SUCCESS_NOTIFY"

//微信支付失败
#define SYS_WECHAT_PAY_FAILED_NOTIFY @"SYS_WECHAT_PAY_FAILED_NOTIFY"

//微信支付取消
#define SYS_WECHAT_PAY_CANCEL_NOTIFY @"SYS_WECHAT_PAY_CANCEL_NOTIFY"

//提现成功通知
#define SYS_CASH_SUCESS_NOTIFY      @"SYS_CASH_SUCESS_NOTIFY"

//银行通知通知
#define SYS_ADD_BANK_SUCESS_NOTIFY      @"SYS_ADD_BANK_SUCESS_NOTIFY"

//添加商品成功通知
#define SYS_ADD_GOODS_SUCESS_NOTIFY      @"SYS_ADD_GOODS_SUCESS_NOTIFY"

//添加任务成功通知
#define SYS_ADD_MASK_SUCESS_NOTIFY      @"SYS_ADD_MASK_SUCESS_NOTIFY"

//添加广告成功通知
#define SYS_ADD_ADV_SUCESS_NOTIFY      @"SYS_ADD_ADV_SUCESS_NOTIFY"

//添加提现成通知
#define SYS_CASH_SUCESS_NOTIFY      @"SYS_CASH_SUCESS_NOTIFY"

