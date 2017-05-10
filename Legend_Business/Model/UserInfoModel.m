//
//  UserInfoModel.m
//  legend_business_ios
//
//  Created by heyk on 16/3/1.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "UserInfoModel.h"

@implementation AddressModel


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.province forKey:@"province"];
    [encoder encodeObject:self.city forKey:@"city"];
    [encoder encodeObject:self.area forKey:@"area"];
    [encoder encodeObject:self.street forKey:@"street"];

}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.province = [decoder decodeObjectForKey:@"province"];
        self.city = [decoder decodeObjectForKey:@"city"];
        self.area = [decoder decodeObjectForKey:@"area"];
        self.street = [decoder decodeObjectForKey:@"street"];
        
    }
    return self;
}

- (NSString*)addr{


    return [NSString stringWithFormat:@"%@%@%@%@",_province?_province:@"",_city?_city:@"",_area?_area:@"",_street?_street:@""];
}

+ (AddressModel *)getAddressModel:(id)response{
    if ([response isKindOfClass:[NSDictionary class]]) {
        return [AddressModel mj_objectWithKeyValues:response];
    }
    return [[AddressModel alloc] init];
}

@end

@implementation UserInfoModel


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.seller_id forKey:@"seller_id"];
    [encoder encodeObject:self.seller_name forKey:@"seller_name"];
    [encoder encodeObject:self.seller_cat_id forKey:@"seller_cat_id"];
    [encoder encodeObject:self.seller_cat_name forKey:@"seller_cat_name"];
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeObject:self.after_address forKey:@"after_address"];
    [encoder encodeObject:self.telephone forKey:@"telephone"];
    [encoder encodeObject:self.thumb_img forKey:@"thumb_img"];
    [encoder encodeObject:self.content forKey:@"content"];
    [encoder encodeObject:self.payment_pwd forKey:@"payment_pwd"];
    [encoder encodeObject:self.today_money forKey:@"today_money"];
    [encoder encodeObject:self.today_total_order forKey:@"today_total_order"];
    [encoder encodeObject:self.money forKey:@"money"];
    [encoder encodeObject:self.area_info forKey:@"area_info"];
    [encoder encodeObject:self.street_info forKey:@"street_info"];
    [encoder encodeObject:@(self.is_warning) forKey:@"is_warning"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.seller_id = [decoder decodeObjectForKey:@"seller_id"];
        self.seller_name = [decoder decodeObjectForKey:@"seller_name"];
        self.seller_cat_id = [decoder decodeObjectForKey:@"seller_cat_id"];
        self.seller_cat_name = [decoder decodeObjectForKey:@"seller_cat_name"];
        self.address = [decoder decodeObjectForKey:@"address"];
        self.after_address = [decoder decodeObjectForKey:@"after_address"];
        self.telephone = [decoder decodeObjectForKey:@"telephone"];
        self.thumb_img = [decoder decodeObjectForKey:@"thumb_img"];
        self.content = [decoder decodeObjectForKey:@"content"];
        self.payment_pwd = [decoder decodeObjectForKey:@"payment_pwd"];
        self.today_money = [decoder decodeObjectForKey:@"today_money"];
        self.today_total_order = [decoder decodeObjectForKey:@"today_total_order"];
        self.money =  [decoder decodeObjectForKey:@"money"];
        self.area_info = [decoder decodeObjectForKey:@"area_info"];
        self.street_info = [decoder decodeObjectForKey:@"street_info"];
        self.is_warning = [[decoder decodeObjectForKey:@"is_warning"] boolValue];
    }
    return self;
}
//- (id)copyWithZone:(NSZone *)zone
//{
//    id copy = [[[self class] alloc] init];
//    
//    if (copy)
//    {
//        [copy setSeller_id:[self.seller_id copyWithZone:zone]];
//        [copy setSeller_name:[self.seller_name copyWithZone:zone]];
//        [copy setSeller_cat_id:[self.seller_cat_id copyWithZone:zone]];
//        [copy setSeller_cat_name:[self.seller_cat_name copyWithZone:zone]];
//        [copy setAddress:[self.address copyWithZone:zone]];
//        [copy setTelephone:[self.telephone copyWithZone:zone]];
//        [copy setThumb_img:[self.thumb_img copyWithZone:zone]];
//        [copy setContent:[self.content copyWithZone:zone]];
//        [copy setPayment_pwd:[self.payment_pwd copyWithZone:zone]];
//        [copy setToday_money:[self.today_money copyWithZone:zone]];
//        [copy setTotay_total_order:[self.totay_total_order copyWithZone:zone]];
//        [copy setMoney:[self.money copyWithZone:zone]];
//    }
//    
//    return copy;
//}

- (NSData*)encodedToData{
    
    NSMutableData *mData = [NSMutableData data];
    NSKeyedArchiver *myKeyedArchiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mData];
    [myKeyedArchiver encodeObject:self];
    [myKeyedArchiver finishEncoding];
    
    return mData;
}

+ (UserInfoModel*)getInstanceEncodeData:(NSData*)data{
    
    NSKeyedUnarchiver *myKeyedUnarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    UserInfoModel* vo = [myKeyedUnarchiver decodeObject];
    [myKeyedUnarchiver finishDecoding];
    return vo ;
}


+ (NSString*)changeTypeStr:(ChangeUserInfoType)type{

    switch (type) {
        case ChangeUserInfoType_Name:
            return @"seller_name";
            break;
        case ChangeUserInfoType_Category:
            return @"seller_cat_id";
            break;
        case ChangeUserInfoType_Address:
            return @"address";
            break;
        case ChangeUserInfoType_Thumb_image:
            return @"thumb_img";
            break;
        case ChangeUserInfoType_Phone:
            return @"telephone";
            break;
        case ChangeUserInfoType_Content:
            return @"content";
            break;
        case ChangeUserInfoType_AfterSaleAddress:
            return @"after_address";
            break;
        default:
            break;
    }
    return @"";
}

@end
