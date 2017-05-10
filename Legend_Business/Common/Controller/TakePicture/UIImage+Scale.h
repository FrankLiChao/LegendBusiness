//
//  UIImage+Scale.h
//  PickImageView
//
//  Created by heyk on 16/3/10.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(Scale)

/**
 *  等比例缩放
 *
 *  @param size 目标尺寸
 */
- (UIImage*)scaleToSize:(CGSize)size;

/**
 *  按比例裁剪
 *
 *  @param scale 裁剪比例 高比宽的比例 
 */

- (UIImage*)cutWithScale:(float)scale;

/**
 *  按比例缩放
 *
 *  @param scale 缩放比例
 *
 *  @return
 */
- (UIImage*)scaleTo:(float)scale;


/**
 *  截取某块区域
 *
 *  @param rect 需要截取的区域
 *
 *  @return
 */
- (UIImage*)cutToRect:(CGRect)rect;

@end
