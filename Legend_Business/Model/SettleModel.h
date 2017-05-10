//
//  SettleModel.h
//  legend_business_ios
//
//  Created by heyk on 16/3/1.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettleModel : NSObject

@property (nonatomic,strong)NSString *company;
@property (nonatomic,strong)NSString *contact_phone;
@property (nonatomic,strong)NSString *operate;
@property (nonatomic,strong)NSString *operate_name;
@property (nonatomic,strong)NSArray *id_img; //身份证图片
@property (nonatomic,strong)NSArray *license;//营业执照图片
@property (nonatomic,strong)NSArray *apitude;//资质证明图片
@property (nonatomic,strong)NSArray *other_apitude;//第三方资质证明图片


@end
