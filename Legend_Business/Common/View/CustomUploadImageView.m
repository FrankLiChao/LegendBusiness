//
//  UploadImageView.m
//  legend_business_ios
//
//  Created by heyk on 16/3/1.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "CustomUploadImageView.h"
#import "PureLayout.h"
#import "UIImageView+WebCache.h"

@interface CustomUploadImageView()

@property (nonatomic,copy)UploadImageCompleBlock finishBlock;
@property (nonatomic)UploadImageType type;


@end

@implementation CustomUploadImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)init{

    self = [super init];
    
    if (self) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
       
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
    }
    return self;
}

//创建圆形进度条--这个是需要上传的
+(CustomUploadImageView*)createUploadImageView:(UIImage*)image
                                          type:(UploadImageType)type
                                           tag:(id)tag
                                    uploadDone:(UploadImageCompleBlock)block
{
    CustomUploadImageView *view = [[CustomUploadImageView alloc] init];
    view.image = image;
    view.finishBlock = block;
    view.type = type;
    view.contentTag = tag;
    
    [view initUploadUI];
    return view;
}

-(void)initUploadUI{
    
    self.clipsToBounds = YES;
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = self.image;
    self.imageView.clipsToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];
    
    [self.imageView autoPinEdgesToSuperviewEdges];
    
    self.progressView = [[PWProgressView alloc] init];

    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width,self.frame.size.height);
    [self.progressView setProgress:0.01];
    self.progressView.frame = CGRectMake(0, 0, self.frame.size.width,self.frame.size.height);
    
    [self addSubview:self.progressView];
    
    [self.progressView autoPinEdgesToSuperviewEdges];
   
    self.faildButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.faildButton setImage:[UIImage imageNamed:@"image_upload_failed"] forState:UIControlStateNormal];
    [self addSubview:self.faildButton];
    
    
    [self.faildButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
    [self.faildButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
    [self.faildButton autoSetDimension:ALDimensionHeight toSize:25];
    [self.faildButton autoSetDimension:ALDimensionWidth toSize:25];
    
    self.faildButton.hidden  = YES;
    
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setImage:[UIImage imageNamed:@"delete_black"] forState:UIControlStateNormal];
    [self addSubview:self.deleteButton];
    [self.deleteButton addTarget:self action:@selector(clickDelete:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.deleteButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
    [self.deleteButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
    [self.deleteButton autoSetDimension:ALDimensionHeight toSize:25];
    [self.deleteButton autoSetDimension:ALDimensionWidth toSize:25];
    
    self.deleteButton.hidden  = YES;
    
    
    [self uploadImage:_image
                 type:_type
             progress:^(NSProgress *progress) {
                 
                 NSLog(@"pro = %f",progress.fractionCompleted);
                 
                 [self.progressView setProgress:progress.fractionCompleted];
                self.status = ImageUploadStatus_Uploading;
                 
                 
                 
             } success:^(NSString *imageURL) {
                 
                 self.status = ImageUploadStatus_Done;
                 self.url = imageURL;
                 
             
                 self.deleteButton.hidden = self.bHiddenDeleteButton;
                 
                 if (self.finishBlock) {
                     self.finishBlock(imageURL, self.image,self.contentTag);
                 }
                 
                 if (self.delegate && [self.delegate respondsToSelector:@selector(uploadUpdateFinish:contentTag:)]) {
                     [self.delegate uploadUpdateFinish:self.url contentTag:self.contentTag];
                 }
                 
             } failed:^(NSString *errorDes) {
                 
                self.faildButton.hidden  = NO;
                 self.deleteButton.hidden = YES;
                 
                 self.status = ImageUploadStatus_Failed;
                 
                 if (self.finishBlock) {
                     self.finishBlock(nil, self.image,self.contentTag);
                 }
                 
                 if (self.delegate && [self.delegate respondsToSelector:@selector(uploadUpdateFinish:contentTag:)]) {
                     [self.delegate uploadUpdateFinish:nil contentTag:self.contentTag];
                 }
                 
             }];
}



+(CustomUploadImageView*)createDownImageView:(NSString*)imageUrl  tag:(id)tag{
    
    CustomUploadImageView *view = [[CustomUploadImageView alloc] init];
    view.url = imageUrl;
    view.contentTag = tag;
    [view initDownUI];
    
    return view;
}

- (void)initDownUI{
    self.clipsToBounds = YES;
    self.status = ImageUploadStatus_Done;
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = self.image;
    self.imageView.clipsToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];
    

    [self.imageView autoPinEdgesToSuperviewEdges];
   
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setImage:[UIImage imageNamed:@"delete_black"] forState:UIControlStateNormal];
    [self addSubview:self.deleteButton];
    [self.deleteButton addTarget:self action:@selector(clickDelete:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.deleteButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
    [self.deleteButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
    [self.deleteButton autoSetDimension:ALDimensionHeight toSize:25];
    [self.deleteButton autoSetDimension:ALDimensionWidth toSize:25];
    
    self.deleteButton.hidden  = YES;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.url] placeholderImage:[UIImage imageNamed:@"默认"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.deleteButton.hidden = self.bHiddenDeleteButton;
        
    }];
    
}

-(void)tap{

    if (self.delegate && [self.delegate respondsToSelector:@selector(checkImageDetail:)]) {
        [self.delegate checkImageDetail:self];
    }
}

- (void)clickDelete:(UIButton*)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteUploadImage:)]) {
        [self.delegate deleteUploadImage:self];
    }
}


@end
