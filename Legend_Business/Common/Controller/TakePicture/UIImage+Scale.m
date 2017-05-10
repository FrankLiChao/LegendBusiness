//
//  UIImage+Scale.m
//  PickImageView
//
//  Created by heyk on 16/3/10.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage(Scale)

- (UIImage*)scaleToSize:(CGSize)size{
    
   // NSLog(@"====w = %f,h = %f,size = %ld",self.size.width,self.size.height,UIImagePNGRepresentation(self).length);
    
    
        UIImage *newImage = nil;
        CGSize imageSize = self.size;
        CGFloat width = imageSize.width;
        CGFloat height = imageSize.height;
        CGFloat targetWidth = size.width;
        CGFloat targetHeight = size.height;
        CGFloat scaleFactor = 0.0;
        CGFloat scaledWidth = targetWidth;
        CGFloat scaledHeight = targetHeight;
        CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
        if(CGSizeEqualToSize(imageSize, size) == NO){
    
            CGFloat widthFactor = targetWidth / width;
            CGFloat heightFactor = targetHeight / height;
    
            if(widthFactor > heightFactor){
                scaleFactor = widthFactor;
    
            }
            else{
    
                scaleFactor = heightFactor;
            }
            scaledWidth = width * scaleFactor;
            scaledHeight = height * scaleFactor;
    
            if(widthFactor > heightFactor){
    
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            }else if(widthFactor < heightFactor){
    
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    
    
    
        UIGraphicsBeginImageContext(size);
    
        CGRect thumbnailRect = CGRectZero;
        thumbnailRect.origin = thumbnailPoint;
        thumbnailRect.size.width = scaledWidth;
        thumbnailRect.size.height = scaledHeight;
    
        [self drawInRect:thumbnailRect];
    
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        if(newImage == nil){
            NSLog(@"scale image fail");
        }
    
        UIGraphicsEndImageContext();
    
        return newImage;
    
//    UIImage *image = [self scaleTo:size.height/size.width];
//    
//    
//    UIGraphicsBeginImageContext(size);
//    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    if(newImage == nil){
//        NSLog(@"scale image fail");
//    }
//    
//    UIGraphicsEndImageContext();
//    return newImage;
    
    
}


- (UIImage*)cutWithScale:(float)scale{
    
    
    if (self.size.height / self.size.width < scale) {//图片本事比例就小于要求就不裁剪，进行一个缩放
        return  [self scaleTo:scale];
    }
    
    float targetHeight = self.size.width * scale;
    
    CGRect newRect = CGRectMake(0,( self.size.height - targetHeight)/2, self.size.width, targetHeight);
    CGImageRef cr = CGImageCreateWithImageInRect([self CGImage], newRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:cr];
    
    CGImageRelease(cr);
    
    NSLog(@"old scale = %f, new scale = %f",scale,cropped.size.height/cropped.size.width);
    
    
    return cropped;
    
}

- (UIImage*)scaleTo:(float)scale{
    
    CGSize newSize = CGSizeMake(self.size.width, self.size.width * scale);
   
    if (self.size.height / self.size.width < scale) {//图片本事比例就小于要求就不裁剪，进行一个缩放
       
        UIGraphicsBeginImageContext(newSize);
        [self drawInRect:CGRectMake(0,(newSize.height - self.size.height)/2, self.size.width,self.size.height)];
        
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSLog(@"old scale = %f, new scale = %f",scale,scaledImage.size.height/scaledImage.size.width);
        
        return scaledImage;
    }
    else{
        return self;
    }

}

- (UIImage*)cutToRect:(CGRect)rect{

    CGAffineTransform rectTransform;
    switch (self.imageOrientation)
    {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(M_PI_2), 0, -self.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(-M_PI_2), -self.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(-M_PI), -self.size.width, -self.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    
    rectTransform = CGAffineTransformScale(rectTransform, self.scale, self.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], CGRectApplyAffineTransform(rect, rectTransform));
    
     UIImage *thumbScale = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    
  //  CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
  //  UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return thumbScale;
    
    
//
//    UIGraphicsBeginImageContext(rect.size);
//    [self drawInRect:rect];
//    
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    if(newImage == nil){
//        NSLog(@"scale image fail");
//        return nil;
//    }
//    
//    UIGraphicsEndImageContext();
//    return newImage;

    
}


@end
