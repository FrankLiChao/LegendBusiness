//
//  KKImagePickViewController.h
//  PickImageView
//
//  Created by heyk on 16/3/10.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CropImageViewController.h"


@interface KKImagePickViewController : UIViewController

/**
 *  打开相机，图片不可编辑，原图
 */
- (void)showNormalCamera:(KKImagePickFinshBlock)block;

/**
 *  打开相机,图片可编辑，正方形
 */
- (void)showEditCamera:(KKImagePickFinshBlock)block;

/**
 *  打开相机带有截图功能
 *
 *  @param scale 高比宽 的截图比例
 */
- (void)showCameraWithScale:(float)scale block:(KKImagePickFinshBlock)block;//高宽比例 h/m



/**
 *  获取相册图片，照片无裁剪
 */
- (void)showNormalAlbum:(KKImagePickFinshBlock)block;

/**
 *  获取相册，照片将被裁减成正方形
 */
- (void)showEditAlbum:(KKImagePickFinshBlock)block;


/**
 *  获取相册有截图功能
 *
 *  @param scale 高比宽 的截图比例
 */
- (void)showAlbumWithScale:(float)scale block:(KKImagePickFinshBlock)block;

@end
