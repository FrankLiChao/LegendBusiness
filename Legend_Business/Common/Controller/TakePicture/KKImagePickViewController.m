//
//  KKImagePickViewController.m
//  PickImageView
//
//  Created by heyk on 16/3/10.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "KKImagePickViewController.h"
#include <objc/runtime.h>
#import "UIImage+Scale.h"
#import "CropImageViewController.h"

@interface KKImagePickViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{


    UIImagePickerController *pickVC;
    UIImage *selectImage;
}

@property (nonatomic,copy) KKImagePickFinshBlock imagePickBlock;
@property (nonatomic)float scale;

@end



@implementation KKImagePickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView*)firstCameraOverlayView{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 100, [UIScreen mainScreen].bounds.size.width, 100)];
    view.backgroundColor = [UIColor blackColor];
    
    UIButton *takePick = [UIButton buttonWithType:UIButtonTypeCustom];
    [takePick setImage:[UIImage imageNamed:@"take_picture"] forState:UIControlStateNormal];
    [takePick addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:takePick];
    takePick.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 67)/2, 3, 67, 67);
    
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancel];
    cancel.frame = CGRectMake(0, (view.frame.size.height - 50)/2, 90, 50);
    
    
    return view;
}



- (void)showNormalCamera:(KKImagePickFinshBlock)block{
    self.imagePickBlock = block;
    
    self.scale = 1;
    
    pickVC = [[UIImagePickerController alloc] init];
    pickVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickVC.delegate = self;
    [self presentViewController:pickVC animated:YES completion:nil];
    
}

- (void)showEditCamera:(KKImagePickFinshBlock)block{
    self.imagePickBlock = block;
    self.scale = 1;
    
    pickVC = [[UIImagePickerController alloc] init];
    pickVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickVC.allowsEditing = YES;
    pickVC.delegate = self;
    [self presentViewController:pickVC animated:YES completion:nil];
}


- (void)showCameraWithScale:(float)scale block:(KKImagePickFinshBlock)block{
    self.imagePickBlock = block;
    self.scale = scale;
    
    pickVC = [[UIImagePickerController alloc] init];
    pickVC.sourceType = UIImagePickerControllerSourceTypeCamera;
   // pickVC.allowsEditing = YES;
    pickVC.showsCameraControls = NO;
    pickVC.cameraOverlayView = [self firstCameraOverlayView];
    pickVC.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveSelectImageNotify) name:kSelectCropImageSuccessNotify object:nil];
    [self presentViewController:pickVC animated:YES completion:^{

    }];
  
}


- (void)showNormalAlbum:(KKImagePickFinshBlock)block{
    self.imagePickBlock = block;
    self.scale = 1;
    
    pickVC = [[UIImagePickerController alloc] init];
    pickVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickVC.delegate = self;
    [self presentViewController:pickVC animated:YES completion:nil];
    
}


- (void)showEditAlbum:(KKImagePickFinshBlock)block{
    self.imagePickBlock = block;
    self.scale = 1;
    
    pickVC = [[UIImagePickerController alloc] init];
    pickVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    pickVC.allowsEditing = YES;
    pickVC.delegate = self;
    [self presentViewController:pickVC animated:YES completion:^{
        
    }];
}


- (void)showAlbumWithScale:(float)scale block:(KKImagePickFinshBlock)block{
    self.imagePickBlock = block;
    self.scale = scale;
    
    pickVC = [[UIImagePickerController alloc] init];
    pickVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    pickVC.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveSelectImageNotify) name:kSelectCropImageSuccessNotify object:nil];
    
    [self presentViewController:pickVC animated:YES completion:nil];
    
}



#pragma mark UIImagePickerController delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (self.scale < 1 && pickVC.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {//相册
        
        UIImage *editeImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
                [picker dismissViewControllerAnimated:NO completion:nil];
        
        CropImageViewController *vc = [[CropImageViewController alloc] initWithImage:editeImage scale:self.scale selectBlock:self.imagePickBlock];
        
        [self presentViewController:vc animated:YES completion:nil];
    }
    else if(self.scale < 1 && pickVC.sourceType == UIImagePickerControllerSourceTypeCamera ){
    
        selectImage  = [info objectForKey:UIImagePickerControllerOriginalImage];
        
             [picker dismissViewControllerAnimated:NO completion:nil];
        
        CropImageViewController *vc = [[CropImageViewController alloc] initWithImage:selectImage scale:self.scale selectBlock:self.imagePickBlock];
        
        [self presentViewController:vc animated:YES completion:nil];
    
    }
    else if(picker.allowsEditing){
    
        UIImage *editeImage = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImage *resultImage = [editeImage scaleTo:1];
        
        self.imagePickBlock(resultImage);
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
    else{
        UIImage *editeImage = [info objectForKey:UIImagePickerControllerOriginalImage];

        self.imagePickBlock(editeImage);
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    selectImage = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)takePhoto{

    [pickVC takePicture];

}
- (void)clickCancel{
    [pickVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickSelect{

     [pickVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark notify
- (void)recieveSelectImageNotify{

//    [pickVC dismissViewControllerAnimated:NO completion:^{
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:kSelectCropImageSuccessNotify object:nil];
//    }];
}
@end
