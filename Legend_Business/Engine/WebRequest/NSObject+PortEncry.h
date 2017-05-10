//
//  NSObjec+PortEncry.h
//  legend_business_ios
//
//  Created by heyk on 16/2/26.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(PortEncry)

- (NSMutableDictionary*)createRequsetData:(NSDictionary*)postDic;

- (NSArray*)getSignArray:(NSDictionary*)postDic;

- (NSString*)getSign:(NSArray*)array;
- (NSString *)URLEncodedString: (NSString *)param;
- (NSString*)getJSONStr:(NSDictionary*)dict;


- (NSMutableDictionary *)decodeRequstData:(NSDictionary*)dic;

@end
