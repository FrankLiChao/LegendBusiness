//
//  BankListVO.h
//  legend_business_ios
//
//  Created by heyk on 16/3/8.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankListVO : NSObject<NSCoding>

@property (nonatomic,strong) NSString *bank_id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *logo;
@property (nonatomic,strong) NSString *config;


@end


@interface MyBankListVO : NSObject

@property (nonatomic,strong) NSString *bank_id;
@property (nonatomic,strong) NSString *bank_name;
@property (nonatomic,strong) NSString *card_type;
@property (nonatomic,strong) NSString *card_num;
@property (nonatomic,strong) NSString *bank_logo;
@property (nonatomic,strong) NSString *config;
@property (nonatomic,strong) NSString *owner_name;
@end