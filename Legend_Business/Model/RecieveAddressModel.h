//
//  RecieveAddressModel.h
//  legend
//
//  Created by heyk on 16/1/15.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecieveAddressModel : NSObject<NSCopying>

@property (nonatomic,strong)NSString *address_id;
@property (nonatomic,strong)NSString *consignee;
@property (nonatomic,strong)NSString *address;
@property (nonatomic,strong)NSString *street;
@property (nonatomic,strong)NSString *area_id;
@property (nonatomic,strong)NSString *area;
@property (nonatomic,strong)NSString *mobile;
@property (nonatomic,assign)NSString *is_default;


@property (nonatomic,strong)NSString *provice;
@property (nonatomic,strong)NSString *city;
@property (nonatomic,strong)NSString *distrct;


@property (nonatomic,strong)NSNumber *lng;
@property (nonatomic,strong)NSNumber *lat;

@property (nonatomic,assign)NSString *postcode;


-(NSData*)encodedToData;
-(void)initWithEncodeData:(NSData*)data;

-(BOOL)bDefault;
-(void)setBDefault:(BOOL)bDefa;

@end
