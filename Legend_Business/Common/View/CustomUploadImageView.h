//
//  UploadImageView.h
//  legend_business_ios
//
//  Created by heyk on 16/3/1.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWProgressView.h"
#import "NSObject+Port.h"

typedef enum {

    ImageUploadStatus_Uploading = 1,
    ImageUploadStatus_Done,
    ImageUploadStatus_Failed,
    
}ImageUploadStatus;



@class CustomUploadImageView;


typedef void (^UploadImageCompleBlock)(NSString *url,UIImage *image,id tag);

@protocol UploadUpdateDelegate <NSObject>

@optional

/**
 *  上传图片完成
 *
 *  @param url 失败返回空
 *  @param tag 
 */
-(void)uploadUpdateFinish:(NSString*)url contentTag:(id)tag;

-(void)checkImageDetail:(CustomUploadImageView*)view;

- (void)deleteUploadImage:(CustomUploadImageView*)view;

@end


@interface CustomUploadImageView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) PWProgressView *progressView;
@property (nonatomic, strong) UIButton *faildButton;
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic)ImageUploadStatus status;
@property (nonatomic,strong)NSString *url;//图片url
@property (nonatomic,strong)id contentTag;

@property (nonatomic,assign)BOOL bHiddenDeleteButton;

@property (nonatomic,weak)id<UploadUpdateDelegate>delegate;

/**
 *  创建上传图片view
 *
 *  @param image 需要上传的图片
 *  @param type  上传的图片类型
 *  @param tag   用于标记图片属于某个位置等信息，可以任意传
 *  @param block 上传结束回调
 *
 *  @return CustomUploadImageView
 */
+(CustomUploadImageView*)createUploadImageView:(UIImage*)image
                                          type:(UploadImageType)type
                                           tag:(id)tag
                                    uploadDone:(UploadImageCompleBlock)block;


/**
 *  创建下载图片View
 *
 *  @param imageUrl 图片下载URL
 *
 *  @return
 */
+(CustomUploadImageView*)createDownImageView:(NSString*)imageUrl  tag:(id)tag;

@end
