//
//  CropImageViewController.m
//  PickImageView
//
//  Created by msb-ios-dev on 16/3/10.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "CropImageViewController.h"
#import "UIImage+Scale.h"

static float toolBarHeight = 50;

@interface CropImageViewController ()<UIScrollViewDelegate>

@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic,copy) KKImagePickFinshBlock selectBlock;
@property (nonatomic) float scale;
@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation CropImageViewController

- (id)initWithImage:(UIImage*)image scale:(float)scale selectBlock:(KKImagePickFinshBlock)block{
    
    self = [super initWithNibName:@"CropImageViewController" bundle:nil];
    if (self) {
        
        self.scale = scale;
        self.image = image;
        self.selectBlock = block;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height - toolBarHeight);
    self.imageView = [[UIImageView alloc] initWithImage:self.image];
    [_scrollView addSubview:_imageView];
    
    _scrollView.contentSize = self.image.size;
    
    float wScale = [UIScreen mainScreen].bounds.size.width/_image.size.width;
    float hScale = ([UIScreen mainScreen].bounds.size.height - toolBarHeight)/_image.size.height;
    
    float minScale = wScale;
    if (wScale>hScale) {
        minScale = hScale;
    }
    
    
    
    //设置实现缩放
    //设置代理scrollview的代理对象
    _scrollView.delegate=self;
    //设置最大伸缩比例
    _scrollView.maximumZoomScale=1.0;
    //设置最小伸缩比例
    _scrollView.minimumZoomScale=minScale;
    [_scrollView setZoomScale:minScale];
    
    
    
    [self addScaleView];
}

- (void)addBottomLine:(UIView*)view{
    
    UIView  *line = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 1, view.frame.size.width, 1)];
    line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    [view addSubview:line];
    
}

- (void)addTopLine:(UIView*)view{
    
    
    UIView  *line = [[UIView alloc] initWithFrame:CGRectMake(0,0, view.frame.size.width, 1)];
    line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    [view addSubview:line];
    
}

- (void)addScaleView{
    
    
    
    float contentHeight = [[UIScreen mainScreen] bounds].size.width * self.scale;
    
    float topHeight = ([[UIScreen mainScreen] bounds].size.height - toolBarHeight - contentHeight)/2;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, topHeight)];
    
    topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:topView];
    [self addBottomLine:topView];
    topView.userInteractionEnabled = NO;
    
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, topHeight +  contentHeight, [UIScreen mainScreen].bounds.size.width, topHeight )];
    
    bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:bottomView];
    [self addTopLine:bottomView];
        bottomView.userInteractionEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickCancel:(id)sender{
    

    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)clickSelect:(id)sender{
    
      NSLog(@"scale = %f",_scrollView.zoomScale);
    
    
    CGSize targetSize =  CGSizeMake([UIScreen mainScreen].bounds.size.width/_scrollView.zoomScale, [UIScreen mainScreen].bounds.size.width* self.scale /_scrollView.zoomScale);
    
    CGSize contentSize = _scrollView.contentSize;
    CGPoint targetPoint = _scrollView.contentOffset;
    
  
    
    CGRect rect = CGRectMake(targetPoint.x/_scrollView.zoomScale, targetPoint.y/_scrollView.zoomScale + (contentSize.height/_scrollView.zoomScale - targetSize.height)/2 , targetSize.width,targetSize.height);
    
    UIImage *image = [self.image cutToRect:rect];
    
//    NSLog(@"imagesize w = %f,h = %f",image.size.width,image.size.height);
//    
//    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
//    imageV.tag = 1;
//    imageV.contentMode = UIViewContentModeScaleAspectFit;
//    imageV.image = image;
//    imageV.backgroundColor = [UIColor redColor];
//    [self.view addSubview:imageV];
    
    
    self.selectBlock (image);
  
    [self dismissViewControllerAnimated:YES completion:^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kSelectCropImageSuccessNotify object:nil];

    }];
    
 
//
    
}



#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}
#pragma mark 当缩放完毕的时候调用
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    //    NSLog(@"结束缩放 - %f", scale);
}
#pragma mark 当正在缩放的时候调用
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    _imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                    scrollView.contentSize.height * 0.5 + offsetY);
}

@end
