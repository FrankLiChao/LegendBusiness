//
//  NSObject+PortError.h
//  legend_business_ios
//
//  Created by heyk on 16/2/26.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(PortError)

-(NSString*)errorAnalysis:(NSDictionary*)dict request:(NSDictionary*)requestDic url:(NSString*)url;

@end
