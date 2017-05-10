//
//  BankListVO.m
//  legend_business_ios
//
//  Created by heyk on 16/3/8.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "BankListVO.h"

@implementation BankListVO

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.bank_id forKey:@"bank_id"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.logo forKey:@"logo"];
    [encoder encodeObject:self.config forKey:@"config"];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.bank_id = [decoder decodeObjectForKey:@"bank_id"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.logo = [decoder decodeObjectForKey:@"logo"];
        self.config = [decoder decodeObjectForKey:@"config"];
        
    }
    return self;
}


@end

@implementation MyBankListVO



@end