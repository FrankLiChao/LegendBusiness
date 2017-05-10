//
//  AfterInforModel.h
//  legend_business_ios
//
//  Created by Frank on 2016/11/26.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AfterInforModel : NSObject

@property (nonatomic, strong)NSString *after_type;
@property (nonatomic, strong)NSString *apply_time;
@property (nonatomic, strong)NSString *refund_money;
@property (nonatomic, strong)NSString *after_reason;
@property (nonatomic, strong)NSString *refund_explain;
@property (nonatomic, strong)NSString *after_img;

+ (AfterInforModel *)parseResponse:(id)response;

@end
