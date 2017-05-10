//
//  AppDelegate+URLHandle.m
//  legend_business_ios
//
//  Created by heyk on 16/3/8.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "AppDelegate+URLHandle.h"


@implementation AppDelegate(URLHandle)

- (BOOL)application:(UIApplication * __nonnull)app openURL:(NSURL * __nonnull)url options:(NSDictionary<NSString *, id> * __nonnull)options{
    
    
    [WXApi handleOpenURL:url delegate:self];
    
    return YES;
}


-(void) onResp:(BaseResp*)resp{
    
    if([resp isKindOfClass:[PayResp class]]){//微信支付
        NSLog(@"==========onResp===========");
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:{
                [[NSNotificationCenter defaultCenter] postNotificationName:SYS_WECHAT_PAY_SUCCESS_NOTIFY object:[NSNumber numberWithBool:YES]];
            }break;
            case WXErrCodeUserCancel:{
                [[NSNotificationCenter defaultCenter] postNotificationName:SYS_WECHAT_PAY_CANCEL_NOTIFY object:nil];
            }break;
            default:{
                //                [FileManagerSever writeRequstErrorLogToFile:ErrorLogType_WeChatPayError request:[[NSUserDefaults standardUserDefaults] objectForKey:kPayErrorLog] unRequestJson:nil url:nil];
                //                [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPayErrorLog];
                [[NSNotificationCenter defaultCenter] postNotificationName:SYS_WECHAT_PAY_FAILED_NOTIFY object:nil];
            }
                
                break;
        }
    }
    
}


-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}



@end
