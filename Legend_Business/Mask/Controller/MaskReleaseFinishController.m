//
//  MaskReleaseFinishController.m
//  legend_business_ios
//
//  Created by msb-ios-dev on 16/3/6.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "MaskReleaseFinishController.h"

@interface MaskReleaseFinishController ()

@property (nonatomic,weak) IBOutlet UIImageView *statusImageView;
@property (nonatomic,weak) IBOutlet UILabel *statusLabel;
@property (nonatomic,weak) IBOutlet UILabel *tipLabel;

@end

@implementation MaskReleaseFinishController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"任务发布";
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 60, 44);
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(clickClose:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    
}
- (void)clickClose:(UIButton*)button{

            [[NSNotificationCenter defaultCenter] postNotificationName:SYS_ADD_MASK_SUCESS_NOTIFY object:nil];
    
    UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:1];
    [self.navigationController popToViewController:vc animated:YES];
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
