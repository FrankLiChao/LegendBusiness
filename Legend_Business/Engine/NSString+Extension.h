//
//  NSString+Extension.h
//  legend_business_ios
//
//  Created by heyk on 16/2/25.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString(Extension)
- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width;
- (CGSize)sizeWithFont:(UIFont *)font byHeight:(CGFloat)height;
@end
