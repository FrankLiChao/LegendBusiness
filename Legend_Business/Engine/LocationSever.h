//
//  LocationSever.h
//  legend
//
//  Created by msb-ios-dev on 15/10/30.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  位置信息获取回调
 *
 *  @param model           当前位置信息
 *  @param locationSuccess 定位是否成功
 */
//typedef void (^GetCurrentLocation)(RecieveAddressModel*model,BOOL locationSuccess);

typedef void (^LocationInitBlock)(BOOL success);


@interface LocationSever : NSObject

+ (LocationSever *)sharedInstance;

- (void)initLocation:(LocationInitBlock)block;


@end
