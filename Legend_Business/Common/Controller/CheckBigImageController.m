//
//  CheckBigImageController.m
//  legend_business_ios
//
//  Created by msb-ios-dev on 16/3/15.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "CheckBigImageController.h"

@interface CheckBigImageController ()

@property (nonatomic,weak) IBOutlet UIImageView *imageView;

@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) UIImage *image;

@end

@implementation CheckBigImageController

- (id)initWithURL:(NSString*)URL{
    
    self = [super initWithNibName:@"CheckBigImageController" bundle:nil];
    self.imageUrl = URL;
    
    return self;
}

- (id)initWithImage:(UIImage*)image{
    
    self = [super initWithNibName:@"CheckBigImageController" bundle:nil];
    self.image = image;
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setBackButton];
    self.title = @"图片详情";
    
    if (_image) {
        _imageView.image = _image;
    }
    else if(_imageUrl){
    
        [_imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:[UIImage imageNamed:@"默认"]];
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
