//
//  UserInfoModel.h
//  legend_business_ios
//
//  Created by heyk on 16/3/1.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {

    ChangeUserInfoType_Name = 1,
    ChangeUserInfoType_Category,
    ChangeUserInfoType_Address,
    ChangeUserInfoType_Thumb_image,
    ChangeUserInfoType_Phone,
    ChangeUserInfoType_Content,
    ChangeUserInfoType_AfterSaleAddress
    
    
}ChangeUserInfoType;

@interface AddressModel : NSObject<NSCoding>

@property (nonatomic,strong)NSString *province;//省
@property (nonatomic,strong)NSString *city;//市
@property (nonatomic,strong)NSString *area;//区
@property (nonatomic,strong)NSString *street;
@property (nonatomic,strong)NSNumber *lng;
@property (nonatomic,strong)NSNumber *lat;
@property (nonatomic, strong)NSString *address;//详细地址
@property (nonatomic, strong)NSString *consignee;//姓名
@property (nonatomic, strong)NSString *postcode;//邮编
@property (nonatomic, strong)NSString *mobile;//手机

- (NSString*)addr;
+ (AddressModel *)getAddressModel:(id)response;

@end

@interface UserInfoModel : NSObject<NSCoding>

@property (nonatomic,strong)NSString *seller_id;
@property (nonatomic,strong)NSString *seller_name;//--商家名称/店铺名称
@property (nonatomic,strong)NSString *seller_cat_id;//--商家分类id
@property (nonatomic,strong)NSString *seller_cat_name;//--商家分类名称
@property (nonatomic,strong)NSString *address;//--商家地址
@property (nonatomic,strong)NSString *after_address;//--售后地址
@property (nonatomic,strong)NSString *telephone;
@property (nonatomic,strong)NSString *thumb_img;//--店铺头像
@property (nonatomic,strong)NSString *content;//--店铺介绍
@property (nonatomic,strong)NSString *payment_pwd;//--是否设置支付密码
@property (nonatomic,strong)NSString *today_money;//--今日收入
@property (nonatomic,strong)NSString *money;//--金额
@property (nonatomic,strong)NSString *today_total_order;//--今日订单量
@property (nonatomic,strong)UIImage *storeIcon;//
@property (nonatomic)BOOL is_warning;//--是否有预警 true 有预警 false 没有预警
@property (nonatomic, strong)NSString *area_info;//--商家省市区地址信息
@property (nonatomic, strong)NSString *street_info;//--商家街道地址信息

//@property (nonatomic,strong)AddressModel *address;

- (NSData*)encodedToData;
+ (UserInfoModel*)getInstanceEncodeData:(NSData*)data;

+ (NSString*)changeTypeStr:(ChangeUserInfoType)type;


@end
