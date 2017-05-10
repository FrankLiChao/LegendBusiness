//
//  RecieveAddressModel.m
//  legend
//
//  Created by heyk on 16/1/15.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "RecieveAddressModel.h"

@implementation RecieveAddressModel



- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.address_id forKey:@"address_id"];
    [encoder encodeObject:self.consignee forKey:@"consignee"];
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeObject:self.area_id forKey:@"area_id"];
    [encoder encodeObject:self.mobile forKey:@"mobile"];
    [encoder encodeObject:self.is_default forKey:@"is_default"];
    [encoder encodeObject:self.area forKey:@"area"];
    [encoder encodeObject:self.provice forKey:@"provice"];
    [encoder encodeObject:self.city forKey:@"city"];
    [encoder encodeObject:self.distrct forKey:@"distrct"];
    [encoder encodeObject:self.street forKey:@"street"];
    [encoder encodeObject:self.lng forKey:@"lng"];
    [encoder encodeObject:self.lat forKey:@"lat"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.address_id = [decoder decodeObjectForKey:@"address_id"];
        self.consignee = [decoder decodeObjectForKey:@"consignee"];
        self.address = [decoder decodeObjectForKey:@"address"];
        self.area_id = [decoder decodeObjectForKey:@"area_id"];
        self.mobile = [decoder decodeObjectForKey:@"mobile"];
        self.is_default = [decoder decodeObjectForKey:@"is_default"];
        self.area = [decoder decodeObjectForKey:@"area"];
        self.provice = [decoder decodeObjectForKey:@"provice"];
        self.city = [decoder decodeObjectForKey:@"city"];
        self.distrct = [decoder decodeObjectForKey:@"distrct"];
        self.street = [decoder decodeObjectForKey:@"street"];
        self.lng = [decoder decodeObjectForKey:@"lng"];
        self.lat = [decoder decodeObjectForKey:@"lat"];
    }
    return self;
}
- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];

    if (copy)
    {
        [copy setAddress_id:[self.address_id copyWithZone:zone]];
        [copy setConsignee:[self.consignee copyWithZone:zone]];
        [copy setAddress:[self.address copyWithZone:zone]];
        [copy setArea_id:[self.area_id copyWithZone:zone]];
        [copy setIs_default:[self.is_default copyWithZone:zone]];
        [copy setArea:[self.area copyWithZone:zone]];
        [copy setProvice:[self.provice copyWithZone:zone]];
        [copy setCity:[self.city copyWithZone:zone]];
        [copy setDistrct:[self.distrct copyWithZone:zone]];
        [copy setStreet:[self.street copyWithZone:zone]];
        [copy setLat:[self.lat copyWithZone:zone]];
        [copy setLng:[self.lng copyWithZone:zone]];
        [copy setMobile:[self.mobile copyWithZone:zone]];
    }

    return copy;
}

-(NSData*)encodedToData{

    NSMutableData *mData = [NSMutableData data];
    NSKeyedArchiver *myKeyedArchiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mData];
    [myKeyedArchiver encodeObject:self];
    [myKeyedArchiver finishEncoding];
    
     return mData;
}

-(void)initWithEncodeData:(NSData*)data{

    NSKeyedUnarchiver *myKeyedUnarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    RecieveAddressModel* vo = [myKeyedUnarchiver decodeObject];
    [myKeyedUnarchiver finishDecoding];
    
    self.address_id = vo.address_id;
    self.consignee = vo.consignee;
    self.address = vo.address;
    self.area_id = vo.area_id;
    self.mobile = vo.mobile;
    self.is_default = vo.is_default;
    self.area = vo.area;

    self.provice = vo.provice;
    self.city = vo.city;
    self.distrct = vo.distrct;
    self.street = vo.street;
    self.lng = vo.lng;
    self.lat = vo.lat;

}

-(BOOL)bDefault{
    return [_is_default boolValue];
}

-(void)setBDefault:(BOOL)bDefa{
    self.is_default = [[NSNumber numberWithBool:bDefa] stringValue];
}
/*
 
 + (id)readUnarchiveDataVO :(NSData*)data{
 
 NSKeyedUnarchiver *myKeyedUnarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
 id vo = [myKeyedUnarchiver decodeObject];
 [myKeyedUnarchiver finishDecoding];
 return vo;
 }
 
 + (NSData*)archiveVO:(id)vo {
 if (vo) {
 NSMutableData *mData = [NSMutableData data];
 NSKeyedArchiver *myKeyedArchiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mData];
 [myKeyedArchiver encodeObject:vo];
 [myKeyedArchiver finishEncoding];
 
 return mData;
 }
 return nil;
 }

 */

@end
