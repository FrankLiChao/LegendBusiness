//
//  AdvReleaseFinshController.m
//  legend_business_ios
//
//  Created by heyk on 16/3/7.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "AdvReleaseFinshController.h"

@interface AdvReleaseFinshController ()
@property (nonatomic,weak) IBOutlet UIImageView *statusImageView;
@property (nonatomic,weak) IBOutlet UILabel *statusLabel;
@property (nonatomic,weak) IBOutlet UILabel *tipLabel;
@end

@implementation AdvReleaseFinshController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布广告";
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 60, 44);
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(clickClose:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
}

- (void)clickClose:(UIButton*)button{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SYS_ADD_ADV_SUCESS_NOTIFY object:nil];
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
