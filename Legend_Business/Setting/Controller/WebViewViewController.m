//
//  WebViewViewController.m
//  legend_business_ios
//
//  Created by heyk on 16/3/8.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "WebViewViewController.h"

@interface WebViewViewController ()



@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    
    if (_type == WebType_GoodesDetail) {
        self.title = @"商品详情";
     
    }
    else{
        if ( _type == WebType_HelpUs) {
            self.title = @"关于我们";
            self.url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_ABOUT_US];
        }
        else if (_type == WebType_UserAgent){
            
            self.title = @"用户协议";
            self.url = [NSString stringWithFormat:@"%@%@",SYS_WEB_BASED_URL,SYS_WEB_USER_ARGREEMENT];
        }
    }
    
    NSURL *urls = [[NSURL alloc]initWithString:_url];
    [_webView loadRequest:[NSURLRequest requestWithURL:urls]];
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
