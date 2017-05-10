//
//  QRCodeReaderView.m
//  legend_business_ios
//
//  Created by Frank on 2016/12/9.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "QRCodeReaderView.h"
#import <AVFoundation/AVFoundation.h>

@interface QRCodeReaderView ()<AVCaptureMetadataOutputObjectsDelegate>

@property(strong,nonatomic)AVCaptureSession * session;
@property(strong,nonatomic)NSTimer * countTime;
@property (nonatomic, strong) CAShapeLayer *overlay;

@end

@implementation QRCodeReaderView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        
        [self instanceDevice];
    }
    
    return self;
}

- (void)instanceDevice
{
    //扫描区域
    UIImage *hbImage=[UIImage imageNamed:@"scanscanBg"];
    UIImageView * scanZomeBack=[[UIImageView alloc] init];
    scanZomeBack.backgroundColor = [UIColor clearColor];
    scanZomeBack.layer.borderColor = [UIColor whiteColor].CGColor;
    scanZomeBack.layer.borderWidth = 2.5;
    scanZomeBack.image = hbImage;
    //添加一个背景图片
    CGRect mImagerect = CGRectMake((DeviceMaxWidth-250)/2, (DeviceMaxHeight-200)/2-64+100, 250, 100);
    [scanZomeBack setFrame:mImagerect];
    CGRect scanCrop = [self getScanCrop:mImagerect readerViewBounds:self.frame];
//    scanCrop = CGRectMake(0, 0, 1, 1);
    [self addSubview:scanZomeBack];
    //如果应用在使用相机时被用户拒绝，可以获得当前的状态，并提示用户
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!device) {
        return;
    }
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    output.rectOfInterest = scanCrop;
    
    //初始化链接对象
    self.session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if (input) {
        [self.session addInput:input];
    }
    if (output) {
        [self.session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSMutableArray *array = [[NSMutableArray alloc] init];
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [array addObject:AVMetadataObjectTypeQRCode];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
            [array addObject:AVMetadataObjectTypeEAN13Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            [array addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            [array addObject:AVMetadataObjectTypeCode128Code];
        }
        output.metadataObjectTypes = array;
    }
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.layer.bounds;
    layer.backgroundColor = [[UIColor redColor] CGColor];
    [self.layer insertSublayer:layer atIndex:0];
    
    [self setOverlayPickerView:self];
    
    //开始捕获
    [self.session startRunning];
    
}

-(void)loopDrawLine
{
    _is_AnmotionFinished = NO;
    CGRect rect = CGRectMake((DeviceMaxWidth-250)/2, (DeviceMaxHeight-200)/2-64+100, 250, 2);
    if (_readLineView) {
        _readLineView.alpha = 1;
        _readLineView.frame = rect;
    }
    else{
        _readLineView = [[UIImageView alloc] initWithFrame:rect];
        [_readLineView setImage:[UIImage imageNamed:@"scanLine"]];
        [self addSubview:_readLineView];
    }
    
    [UIView animateWithDuration:1.5 animations:^{
        //修改fream的代码写在这里
        _readLineView.frame =CGRectMake((DeviceMaxWidth-250)/2, (DeviceMaxHeight-200)/2+100-5-64+100, 250, 2);
    } completion:^(BOOL finished) {
        if (!_is_Anmotion) {
            [self loopDrawLine];
        }
        _is_AnmotionFinished = YES;
    }];
}

- (void)setOverlayPickerView:(QRCodeReaderView *)reader
{
    
    CGFloat wid = (DeviceMaxWidth-250)/2;
    CGFloat heih = (DeviceMaxHeight-200)/2-64+100;
    
    UIColor * bgColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    //最上部view
    //    CGFloat alpha = 0.6;
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, heih)];
    //    upView.alpha = alpha;
    //    upView.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    upView.backgroundColor = bgColor;
    [reader addSubview:upView];
    
    //用于说明的label
    UILabel * labIntroudction= [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame=CGRectMake(0, 64+(heih-64-50)/2, DeviceMaxWidth, 50);
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"请扫描传说物流单号条形码";
    [upView addSubview:labIntroudction];
    
    //左侧的view
    UIView * cLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, heih, wid, 100)];
    //    cLeftView.alpha = alpha;
    //    cLeftView.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    cLeftView.backgroundColor = bgColor;
    [reader addSubview:cLeftView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(DeviceMaxWidth-wid, heih, wid, 100)];
    //    rightView.alpha = alpha;
    //    rightView.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    rightView.backgroundColor = bgColor;
    [reader addSubview:rightView];
    
    //底部view
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, heih+100, DeviceMaxWidth, DeviceMaxHeight - heih-100)];
    //    downView.alpha = alpha;
    //    downView.backgroundColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    downView.backgroundColor = bgColor;
    [reader addSubview:downView];
    
    //开关灯button
    UIButton * turnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    turnBtn.backgroundColor = [UIColor clearColor];
    [turnBtn setBackgroundImage:[UIImage imageNamed:@"lightSelect"] forState:UIControlStateNormal];
    [turnBtn setBackgroundImage:[UIImage imageNamed:@"lightNormal"] forState:UIControlStateSelected];
    turnBtn.frame=CGRectMake((DeviceMaxWidth-50)/2, (CGRectGetHeight(downView.frame)-50)/2-64, 50, 50);
    [turnBtn addTarget:self action:@selector(turnBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:turnBtn];
}

- (void)turnBtnEvent:(UIButton *)button_
{
    button_.selected = !button_.selected;
    if (button_.selected) {
        [self turnTorchOn:YES];
    }
    else{
        [self turnTorchOn:NO];
    }
    
}

- (void)turnTorchOn:(bool)on
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}

-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    x = (CGRectGetHeight(readerViewBounds)-CGRectGetHeight(rect))/2/CGRectGetHeight(readerViewBounds);
    y = (CGRectGetWidth(readerViewBounds)-CGRectGetWidth(rect))/2/CGRectGetWidth(readerViewBounds);
    width = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
    
    return CGRectMake(x, y, width, height);
    
}

- (void)start
{
    [self.session startRunning];
}

- (void)stop
{
    [self.session stopRunning];
}

#pragma mark - 扫描结果
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects && metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        if (_delegate && [_delegate respondsToSelector:@selector(readerScanResult:)]) {
            [_delegate readerScanResult:metadataObject.stringValue];
        }
    }
}

@end
