//
//  userInforModel.h
//  legend_business_ios
//
//  Created by Frank on 2016/11/26.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInforModel : NSObject

@property (nonatomic, strong)NSString *user_name;
@property (nonatomic, strong)NSString *photo_url;
@property (nonatomic, strong)NSString *telephone;

+ (UserInforModel *)parseResponse:(id)response;

@end

@interface SellerInfoModel : NSObject

@property (nonatomic, strong)NSString *seller_name;
@property (nonatomic, strong)NSString *telephone;
@property (nonatomic, strong)NSString *photo_url;

+ (SellerInfoModel *)parseResponse:(id)response;

@end
