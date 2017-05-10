//
//  AboutUsViewController.m
//  legend_business_ios
//
//  Created by heyk on 16/3/18.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "AboutUsViewController.h"
#import "WebViewViewController.h"
#import "SaveEngine.h"  


@interface AboutUsViewController ()

@property (nonatomic,weak) IBOutlet UIImageView *imageView;
@property (nonatomic,weak) IBOutlet UILabel *currentVersionLabel;
@property (nonatomic,weak) IBOutlet UILabel *updateVersionLabel;
@property (nonatomic,weak) IBOutlet UIButton *updateButton;

@end



@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    self.title = @"关于我们";
    
    [UitlCommon setFlatWithView:_imageView radius:20];
    [UitlCommon setFlatWithView:_updateButton radius:[Configure SYS_CORNERRADIUS]];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
   
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    self.currentVersionLabel.text = [NSString stringWithFormat:@"当前版本 ：%@",app_Version];
    self.updateVersionLabel.text = [NSString stringWithFormat:@"最新版本 ：%@",[SaveEngine getVersinNo]];
    
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

- (IBAction)clickUserAgent:(id)sender{

    WebViewViewController * vc = [[WebViewViewController alloc] initWithNibName:@"WebViewViewController" bundle:nil];
    vc.type = WebType_UserAgent;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)clcikHelpCenter:(id)sender{
    
    WebViewViewController * vc = [[WebViewViewController alloc] initWithNibName:@"WebViewViewController" bundle:nil];
    vc.type = WebType_HelpUs;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickUpdateNewVerion:(id)sender{

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[SaveEngine getVersinDownURL]]];
    
}

@end
