//
//  BaseViewController.m
//  legend_business_ios
//
//  Created by msb-ios-dev on 16/2/20.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "BaseViewController.h"
#import "legend_business_ios-swift.h"

@interface BaseViewController ()<UIActionSheetDelegate, UIGestureRecognizerDelegate>

@property (nonatomic,copy) KKImagePickFinshBlock pickSelectBlock;//选中相机或者相册照片回调
@property (nonatomic) float kkPicScale;
@property (nonatomic) BOOL kkEdit;


@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Configure SYS_UI_COLOR_BG_COLOR];
    
    if ([self.navigationController.viewControllers indexOfObject:self] != 0) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClicked:)];
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)getHttpUrl:(NSString *)url{
    return PATH(url);
}

- (CGFloat)getDeviceMaxWidth{
    return [UIScreen mainScreen].bounds.size.width;
}
- (CGFloat)getDeviceMaxHeight{
    return [UIScreen mainScreen].bounds.size.height;
}
- (void)backBarButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addRightBarItem:(NSString*)icomName method:(SEL)selct{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 44);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button setImage:[UIImage imageNamed:icomName ] forState:UIControlStateNormal];
    [button addTarget:self action:selct forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)addRightBarItemWithTitle:(NSString*)title method:(SEL)selct{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 44);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:[Configure SYS_FONT_SCALE:14]];
    [button addTarget:self action:selct forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)addLeftBarItemWithTitle:(NSString*)title method:(SEL)selct{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:selct];
}

- (void)setBackButton{
    
    //UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //backButton.frame = CGRectMake(0, 0, 44, 44);
    //backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //[backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    //[backButton addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
}

- (void)clickBack:(UIButton*) button {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)takeNormalPic:(KKImagePickFinshBlock)block{
    self.kkPicScale = 1;
    self.kkEdit = NO;
    self.pickSelectBlock = block;
    [self showTakePicAcheet];
    
}
- (void)takeEditPick:(KKImagePickFinshBlock)block{
    self.kkPicScale = 1;
    self.kkEdit = YES;
    self.pickSelectBlock = block;
    [self showTakePicAcheet];
    
}
- (void)takePicWithScale:(float)scale selectBlock:(KKImagePickFinshBlock)block{
    self.kkPicScale = scale;
    self.pickSelectBlock = block;
    self.kkEdit = YES;
    [self showTakePicAcheet];
}


- (void)showTakePicAcheet{
    
    if (SYS_VERSION >= 8.0) {
        
        UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"选中照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [sheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [sheet addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (!_kkEdit) {
                [self showNormalCamera:self.pickSelectBlock];
            }
            else if(_kkEdit && _kkPicScale>=1){
                
                [self showEditCamera:self.pickSelectBlock];
            }
            else{
                [self showCameraWithScale:_kkPicScale block:self.pickSelectBlock];
            }
            
            
            
        }]];
        
        [sheet addAction:[UIAlertAction actionWithTitle:@"从手机相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (!_kkEdit) {
                [self showNormalAlbum:self.pickSelectBlock];
            }
            else if(_kkEdit && _kkPicScale>=1){
                
                [self showEditAlbum:self.pickSelectBlock];
            }
            else{
                [self showAlbumWithScale:_kkPicScale block:self.pickSelectBlock];
            }
        }]];
        [self presentViewController:sheet animated:YES completion:nil];
        
    }
    else{
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选中照片"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"拍照",@"从手机相册获取", nil];
        sheet.tag = -1;
        
        [sheet showInView:self.view];
        
    }
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(actionSheet.tag == -1){
        if (buttonIndex == 0) {//拍照
            if (!_kkEdit) {
                [self showNormalCamera:self.pickSelectBlock];
            }
            else if(_kkEdit && _kkPicScale>=1){
                
                [self showEditCamera:self.pickSelectBlock];
            }
            else{
                [self showCameraWithScale:_kkPicScale block:self.pickSelectBlock];
            }
        }
        else if(buttonIndex == 1){//相册获取
            if (!_kkEdit) {
                [self showNormalAlbum:self.pickSelectBlock];
            }
            else if(_kkEdit && _kkPicScale>=1){
                
                [self showEditAlbum:self.pickSelectBlock];
            }
            else{
                [self showAlbumWithScale:_kkPicScale block:self.pickSelectBlock];
            }
        }
    }
    
}


#pragma mark - 颜色 //34b7e8蓝色
- (UIColor *)mainColor {
    return [UIColor colorFromHexRGB:@"E3383E"];//E3383E
}

- (UIColor *)titleTextColor {
    return [UIColor colorFromHexRGB:@"191919"];
}

- (UIColor *)bodyTextColor {
    return [UIColor colorFromHexRGB:@"464646"];
}

- (UIColor *)noteTextColor {
    return [UIColor colorFromHexRGB:@"9b9b9b"];
}

- (UIColor *)seperateColor {
    return [UIColor colorFromHexRGB:@"d9d9d9"];
}

- (UIColor *)backgroundColor {
    return [UIColor colorFromHexRGB:@"f5f5f5"];
}

- (UIColor *)sectionColor {
    return [UIColor colorFromHexRGB:@"f1f2f6"];
}

-(NSString *)LongTimeToString:(NSString *)time withFormat:(NSString *)formatestr
{
    NSDate * date = nil;
    time = [NSString stringWithFormat:@"%@",time];
    if (time.length == 10) { //10位
        date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    }else //13位
    {
        date = [NSDate dateWithTimeIntervalSince1970:[time longLongValue]/1000];
    }
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:formatestr];
    return [df stringFromDate:date];
}

#pragma mark - 打电话
- (void)detailPhone:(NSString *)phone {
    [self dialPhoneNumber:phone];
}

- (void)dialPhoneNumber:(NSString *)aPhoneNumber {
    NSString *str = [NSString stringWithFormat:@"telprompt://%@",aPhoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

@end
