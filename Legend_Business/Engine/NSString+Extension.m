//
//  NSString+Extension.m
//  legend_business_ios
//
//  Created by heyk on 16/2/25.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString(Extension)

- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width{
    
    
    NSStringDrawingOptions optional = NSStringDrawingUsesLineFragmentOrigin;
    
    CGSize size = CGSizeMake(width,CGFLOAT_MAX);
    
    NSDictionary *dic=@{NSFontAttributeName: font};
    
    CGRect labelsize =  [self boundingRectWithSize:size
                                           options:optional
                                        attributes:dic
                                           context:nil];
    
    return labelsize.size;
    //    if (IOS7_OR_LATER) {
    //        NSDictionary *dic=@{NSFontAttributeName: font};
    //
    //        CGRect labelsize =  [self boundingRectWithSize:size
    //                                               options:optional
    //                                            attributes:dic
    //                                               context:nil];
    //
    //        return labelsize.size;
    //    }
    //
    //    else{
    //        CGSize labelsize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    //        return labelsize;
    //    }
    //
    return CGSizeZero;
    
    
}

- (CGSize)sizeWithFont:(UIFont *)font byHeight:(CGFloat)height{
    
    
    NSStringDrawingOptions optional = NSStringDrawingUsesLineFragmentOrigin;
    
    CGSize size = CGSizeMake(CGFLOAT_MAX,height);
    NSDictionary *dic=@{NSFontAttributeName:font};
    
    CGRect labelsize =  [self boundingRectWithSize:size
                                           options:optional
                                        attributes:dic
                                           context:nil];
    
    return labelsize.size;
    
    //    if (IOS7_OR_LATER) {
    //        NSDictionary *dic=@{NSFontAttributeName:font};
    //
    //        CGRect labelsize =  [self boundingRectWithSize:size
    //                                               options:optional
    //                                            attributes:dic
    //                                               context:nil];
    //
    //        return labelsize.size;
    //    }
    //
    //    else{
    //        CGSize labelsize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    //        return labelsize;
    //    }
    //    
    //    return CGSizeZero;
    
    
}

@end
