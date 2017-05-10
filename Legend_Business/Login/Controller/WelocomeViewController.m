//
//  WelocomeViewController.m
//  legend_business_ios
//
//  Created by heyk on 16/3/1.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "WelocomeViewController.h"

@interface WelocomeViewController ()

@end

@implementation WelocomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self showHudInView:self.view hint:@""];
    [self loginRequst:[SaveEngine getLoginAccount]
                  pwd:[SaveEngine getLoginPassord]
              success:^(SettleType Settle) {
                  [self hideHud];
               
                  
                  
              } failed:^(NSString *errorDes) {
                  [self hideHud];
              }];
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
