//
//  BaseViewController.h
//  legend_business_ios
//
//  Created by msb-ios-dev on 16/2/20.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKImagePickViewController.h"

@interface BaseViewController : KKImagePickViewController

- (NSString *)getHttpUrl:(NSString *)url;
- (void)setBackButton;

- (void)addRightBarItem:(NSString*)icomName method:(SEL)selct;

- (void)addRightBarItemWithTitle:(NSString*)title method:(SEL)selct;

- (void)addLeftBarItemWithTitle:(NSString*)title method:(SEL)selct;

//获取屏幕尺寸
- (CGFloat)getDeviceMaxWidth;
- (CGFloat)getDeviceMaxHeight;

- (void)takeNormalPic:(KKImagePickFinshBlock)block;
- (void)takeEditPick:(KKImagePickFinshBlock)block;
- (void)takePicWithScale:(float)scale selectBlock:(KKImagePickFinshBlock)block;

- (UIColor *)mainColor;
- (UIColor *)titleTextColor;
- (UIColor *)bodyTextColor;
- (UIColor *)noteTextColor;
- (UIColor *)backgroundColor;
- (UIColor *)seperateColor;

//"YYYY-MM-dd HH:mm:ss"
-(NSString *)LongTimeToString:(NSString *)time withFormat:(NSString *)formatestr;

//打电话
- (void)detailPhone:(NSString *)phone;

@end
