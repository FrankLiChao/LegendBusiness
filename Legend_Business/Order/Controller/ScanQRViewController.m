//
//  ScanQRViewController.m
//  legend_business_ios
//
//  Created by Frank on 2016/12/9.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "ScanQRViewController.h"
#import "QRCodeReaderView.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ScanQRViewController ()<QRCodeReaderViewDelegate,AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)QRCodeReaderView * readview;//二维码扫描对象
@property(nonatomic)BOOL isFirst;//第一次进入该页面
@property(nonatomic)BOOL isPush;//跳转到下一级页面
@property (strong, nonatomic) CIDetector *detector;
@end

@implementation ScanQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫描物流单号";
    self.isFirst = YES;
    self.isPush = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(alumbBtnEvent)];
    
    [self InitScan];
}

#pragma mark 初始化扫描
- (void)InitScan
{
    if (self.readview) {
        [self.readview removeFromSuperview];
        self.readview = nil;
    }
    
    //扫描界面
    self.readview = [[QRCodeReaderView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight)];
    self.readview.is_AnmotionFinished = YES;
    self.readview.backgroundColor = [UIColor clearColor];
    self.readview.delegate = self;
    self.readview.alpha = 0;
    
    [self.view addSubview:self.readview];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.readview.alpha = 1;
    }completion:^(BOOL finished) {
        [self hideHud];
    }];
}

//对扫描结果进行处理
- (void)accordingQcode:(NSString *)str
{
    FLLog(@"对扫描结果进行处理%@",str);
    [self hideHud];
    [self.delegate refreshUI:str];
    [self.navigationController popViewControllerAnimated:YES];
    /*
    //    isCameraAndDone = NO;
    NSString * twoDimString = [NSString stringWithFormat:@"%@",str];
    NSLog(@"twoDimString = %@",twoDimString);
    if (twoDimString.length == 18) {
        if (![twoDimString isEqualToString:[[lhColor shareColor].userInfo objectForKey:@"idCard" ]]) {
            [lhColor disAppearActivitiView:self.view];
            [lhColor showAlertWithMessage:@"请扫描自己的条形码" withSuperView:self.view withHeih:DeviceMaxHeight/2];
            readview.is_Anmotion = NO;
            [readview start];
            return;
        }
        //        NSRange range = [twoDimString rangeOfString:@"="];
        //        if (range.length == 0) {
        //            [lhColor disAppearActivitiView:self.view];
        //            [lhColor showAlertWithMessage:@"请扫描优品学车进度条形码~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        //            readview.is_Anmotion = NO;
        //            [readview start];
        //
        //            return;
        //        }
        
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestGasInfoEvent:) name:@"requestSaoMa" object:nil];
        
        NSDictionary * dic = @{@"id":[[lhColor shareColor].userInfo objectForKey:@"id"],
                               @"idCard":twoDimString};
        [[lhWeb alloc]HTTPPOSTNormalRequestForURL:@"scan/barcode" parameters:[NSMutableDictionary dictionaryWithDictionary:dic] method:@"POST" name:@"requestSaoMa" type:OUR_REQUEST];
        
        //        NSString * mapStr = [NSString stringWithFormat:@"%@",[twoDimString substringFromIndex:range.location+1]];
        //        //NSLog(@"mapId = %@",mapStr);
        //        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestGasInfoEvent:) name:@"requestJiaYouInfo" object:nil];
        //
        //        NSString * userIdS = [NSString stringWithFormat:@"%@",[[lhColor shareColor].userInfo objectForKey:@"id"]];
        //        NSDictionary * dic = @{@"mapId":mapStr,
        //                               @"userId":userIdS};
        //        [[lhWeb alloc]HTTPPOSTNormalRequestForURL:@"action/appConsume_scanToRefuel" parameters:[NSMutableDictionary dictionaryWithDictionary:dic] method:@"POST" name:@"requestJiaYouInfo" type:OUR_REQUEST];
        
    }
    else{
        
        [lhColor disAppearActivitiView:self.view];
        [lhColor showAlertWithMessage:@"请扫描优品学车进度条形码~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        readview.is_Anmotion = NO;
        [readview start];
    }*/
}

#pragma mark - 相册
- (void)alumbBtnEvent
{
    
    //    [lhColor addActivityView123:self.view];
    //    NSString * twoDimString = @"http://www.pay.up-oil.comfdare/yy564g=B001C8P5G3";
    //    [self accordingQcode:twoDimString];
    //
    //    return;
    
    self.detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    //    isAlumb = YES;
    [self showHudInView:self.view hint:nil];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) { //判断设备是否支持相册
        
        if (iOS8) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未开启访问相册权限，现在去开启！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 4;
            [alert show];
        }
        else{
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不支持访问相册，请在设置->隐私->照片中进行设置！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        [self hideHud];
        return;
    }
    
    self.isPush = YES;
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    mediaUI.mediaTypes = [UIImagePickerController         availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    mediaUI.allowsEditing = YES;
    mediaUI.delegate = self;
    [self presentViewController:mediaUI animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        [self hideHud];
    }];
}

//获取相册图片扫描
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    self.readview.is_Anmotion = YES;
    
    NSArray *features = [self.detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >=1) {
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            [self showHudInView:self.view hint:nil];
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            //播放扫描二维码的声音
            SystemSoundID soundID;
            NSString *strSoundFile = [[NSBundle mainBundle] pathForResource:@"noticeMusic" ofType:@"wav"];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
            AudioServicesPlaySystemSound(soundID);
            
            [self accordingQcode:scannedResult];
        }];
        
    }
    else{
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该图片没有包含一个二维码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            
            self.readview.is_Anmotion = NO;
            [self.readview start];
        }];
    }
}

//相册选图片，取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }];
    
}

#pragma mark - 相机扫描，获取扫描结果
- (void)readerScanResult:(NSString *)result
{
    //    isAlumb = NO;
    [self showHudInView:self.view hint:nil];
    self.readview.is_Anmotion = YES;
    [self.readview stop];
    
    //播放扫描二维码的声音
    SystemSoundID soundID;
    NSString *strSoundFile = [[NSBundle mainBundle] pathForResource:@"noticeMusic" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
    AudioServicesPlaySystemSound(soundID);
    
    [self accordingQcode:result];
    
}

//根据二维码获取的mapId请求加油站信息结果
- (void)requestGasInfoEvent:(NSNotification *)noti
{
    //    NSLog(@"%@",noti.userInfo);
    [[NSNotificationCenter defaultCenter]removeObserver:self name:noti.name object:nil];
    if (!noti.userInfo || [noti.userInfo class] == [NSNull class]) {
        [self hideHud];
        [self showHint:@"请检查你的网络"];
        
        self.readview.is_Anmotion = NO;
        [self.readview start];
        //        [self performSelector:@selector(reStartScan) withObject:nil afterDelay:1.5];
    }
    else if([[noti.userInfo objectForKey:@"status"]integerValue] == 1){
        
        self.isPush = YES;
        
        //        lhSelectAllViewController * saVC = [[lhSelectAllViewController alloc]init];
        //        saVC.oilDic = [NSDictionary dictionaryWithDictionary:noti.userInfo];
        //        [self.navigationController pushViewController:saVC animated:YES];
        //        [lhColor showAlertWithMessage:@"成功" withSuperView:self.view withHeih:DeviceMaxHeight/2];
//        NSLog(@"结果= %@",noti.userInfo);
//        NSString *progress = [[noti.userInfo objectForKey:@"data"] objectForKey:@"currentProgress"];
//        
//        [[NSUserDefaults standardUserDefaults]setObject:progress forKey:saveStudyProgress];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//        
//        NSString *str = [NSString stringWithFormat:@"学习进度更新成功！当前进度%@",progress];
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
//        
//        [lhColor disAppearActivitiView:self.view];
    }
    else{
        [self hideHud];
        
        self.readview.is_Anmotion = NO;
        [self.readview start];
        //        [self performSelector:@selector(reStartScan) withObject:nil afterDelay:1.5];
    }
    
}

//重新开启扫描
- (void)reStartScan
{
    self.readview.is_Anmotion = NO;
    
    if (self.readview.is_AnmotionFinished) {
        [self.readview loopDrawLine];
    }
    
    [self.readview start];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if(alertView.tag == 4 && buttonIndex == 1){
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//    }
    
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isFirst || self.isPush) {
        if (self.readview) {
            [self reStartScan];
        }
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.readview) {
        [self.readview stop];
        self.readview.is_Anmotion = YES;
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.isFirst) {
        self.isFirst = NO;
    }
    if (self.isPush) {
        self.isPush = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
