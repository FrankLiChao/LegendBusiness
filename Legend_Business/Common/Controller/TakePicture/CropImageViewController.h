//
//  CropImageViewController.h
//  PickImageView
//
//  Created by msb-ios-dev on 16/3/10.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  kSelectCropImageSuccessNotify @"kSelectCropImageSuccessNotify"

typedef void (^KKImagePickFinshBlock)(UIImage *image);

@interface CropImageViewController : UIViewController


@property (nonatomic,strong) UIImage *image;

- (id)initWithImage:(UIImage*)image scale:(float)scale selectBlock:(KKImagePickFinshBlock)block;
@end
