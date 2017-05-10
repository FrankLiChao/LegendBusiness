//
//  PaySever.m
//  legend
//
//  Created by heyk on 16/1/8.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "PaySever.h"
#import "WXApi.h"
#import "SaveEngine.h"
#import <AlipaySDK/AlipaySDK.h>


@implementation PaySever


+ (NSString *)createOrderInfo:(NSString*)partner
                       seller:(NSString*)seller
                      tradeNO:(NSString*)tradeNO
                  productName:(NSString*)productName
           productDescription:(NSString*)productDescription
                       amount:(NSString*)amount
                    notifyURL:(NSString*)notifyURL
                      service:(NSString*)service
                  paymentType:(NSString*)paymentType
                 inputCharset:(NSString*)inputCharset
                       itBPay:(NSString*)itBPay
                      showUrl:(NSString*)showUrl
                      rsaDate:(NSString*)rsaDate
                        appID:(NSString*)appID
                  extraParams:(NSDictionary*)extraParams
{
    NSMutableString * discription = [NSMutableString string];
    if (partner) {
        [discription appendFormat:@"partner=\"%@\"", partner];
    }
    
    if (seller) {
        [discription appendFormat:@"&seller_id=\"%@\"", seller];
    }
    if (tradeNO) {
        [discription appendFormat:@"&out_trade_no=\"%@\"", tradeNO];
    }
    if (productName) {
        [discription appendFormat:@"&subject=\"%@\"", productName];
    }
    
    if (productDescription) {
        [discription appendFormat:@"&body=\"%@\"", productDescription];
    }
    if (amount) {
        [discription appendFormat:@"&total_fee=\"%@\"", amount];
    }
    if (notifyURL) {
        [discription appendFormat:@"&notify_url=\"%@\"", notifyURL];
    }
    
    if (service) {
        [discription appendFormat:@"&service=\"%@\"",service];//mobile.securitypay.pay
    }
    if (paymentType) {
        [discription appendFormat:@"&payment_type=\"%@\"",paymentType];//1
    }
    
    if (inputCharset) {
        [discription appendFormat:@"&_input_charset=\"%@\"",inputCharset];//utf-8
    }
    if (itBPay) {
        [discription appendFormat:@"&it_b_pay=\"%@\"",itBPay];//30m
    }
    if (showUrl) {
        [discription appendFormat:@"&show_url=\"%@\"",showUrl];//m.alipay.com
    }
    if (rsaDate) {
        [discription appendFormat:@"&sign_date=\"%@\"",rsaDate];
    }
    if (appID) {
        [discription appendFormat:@"&app_id=\"%@\"",appID];
    }
    for (NSString * key in [extraParams allKeys]) {
        [discription appendFormat:@"&%@=\"%@\"", key, [extraParams objectForKey:key]];
    }
    return discription;
}


+(void)weChatPay:(Order*)model comple:(void(^)(BOOL bsuccess))comple{

    
    [WXApi registerApp:WeChatKey];
    
    
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    //============================================================

    PayReq* wxreq             = [[PayReq alloc] init];
    wxreq.openID              = model.sigatureData.appid;
    wxreq.partnerId           = model.sigatureData.partnerid;
    wxreq.prepayId            = [NSString stringWithFormat:@"%@",model.sigatureData.prepayid];
    wxreq.nonceStr            = [NSString stringWithFormat:@"%@",model.sigatureData.noncestr];
    wxreq.timeStamp           = [model.sigatureData.timestamp intValue];
    wxreq.package             = [NSString stringWithFormat:@"%@",model.sigatureData.weixin_package];
    wxreq.sign                = [NSString stringWithFormat:@"%@",model.sigatureData.sign];;
    
    
    BOOL bOk = [WXApi sendReq:wxreq];
    comple(bOk);
}

+(void)aliPay:(Order*)model comple:(void(^)(BOOL bsuccess,NSString *message))comple{
    
    NSString *appScheme = @"legend_business_ios";
         // NSString *appScheme = @"legend";
    [[AlipaySDK defaultService] payOrder:model.signature_data fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        
        NSInteger code = [[resultDic objectForKey:@"resultStatus"] integerValue];
        NSString *message = [resultDic objectForKey:@"memo"] ;
        
        switch (code) {//用户中途取消
            case 9000:
            {
                comple(YES,nil);
            }
                break;
            default:{
                comple(NO,message);
            }
                break;
        }
    }];

}
@end
