//
//  NSAttributedString+Extension.m
//  legend_business_ios
//
//  Created by heyk on 16/2/25.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "NSAttributedString+Extension.h"

@implementation NSAttributedString(Extension)

- (CGSize)sizeWithWidth:(CGFloat)width{
    
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return rect.size;
}
- (CGSize)sizeWithHeight:(CGFloat)height{
    CGRect rect = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return rect.size;
}
@end
