//
//  CashPasswordFirstSetingViewController.m
//  legend
//
//  Created by heyk on 15/12/1.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import "CashPasswordFirstSetingViewController.h"
#import "CashPasswordSetingSecondViewController.h"
#import "UIViewController+HUD.h"
#import "legend_business_ios-swift.h"


static int kTimeOut = 180;

@interface CashPasswordFirstSetingViewController (){
    
    NSTimer *timer;
    int count;
}

@end

@implementation CashPasswordFirstSetingViewController

- (void)dealloc{

    if (timer && [timer isValid]) {
        [timer invalidate];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    self.title = @"设置交易密码";
   
    UserInfoModel *model = [SaveEngine getUserInfo];
    NSString *noticeStr = [NSString stringWithFormat:@"请输入手机号%@收到的验证码",model.telephone];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:noticeStr];
    [str addAttribute:NSForegroundColorAttributeName  value:[Configure SYS_UI_COLOR_TEXT_GRAY]  range:NSMakeRange(0, str.length)];
    [str addAttribute:NSForegroundColorAttributeName  value:[Configure SYS_UI_COLOR_BG_RED]  range:NSMakeRange(6, model.telephone.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[Configure SYS_FONT_SCALE:12]] range:NSMakeRange(0, str.length)];
    _phoneNumLabel.attributedText = str;
    
    _verifyCodeField.textColor = [Configure SYS_UI_COLOR_TEXT_BLACK];
    
    [UitlCommon setFlatWithView:_verifyCodeBackView
                         radius:[Configure SYS_CORNERRADIUS]
                    borderColor:[Configure SYS_UI_COLOR_LINE_COLOR]
                    borderWidth:1];

    [UitlCommon setFlatWithView:_verifyCodeSendButton
                         radius:[Configure SYS_CORNERRADIUS]
                          borderColor:[Configure SYS_UI_COLOR_BG_RED]
                     borderWidth:1];
    
    
    [UitlCommon setFlatWithView:_verifyButton
                         radius:[Configure SYS_CORNERRADIUS]];

    [self.verifyCodeSendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.verifyCodeSendButton setTitleColor:[Configure SYS_UI_COLOR_BG_RED] forState:UIControlStateNormal];
    
    self.verifyCodeSendButton.titleLabel.font = [UIFont systemFontOfSize: [Configure SYS_FONT_SCALE:15]];
    
    self.verifyButton.titleLabel.font = [Configure SYS_UI_BUTTON_FONT];
    self.verifyCodeField.font = [UIFont systemFontOfSize:[Configure SYS_FONT_SCALE:15]];
    
    self.verifyBackHeight.constant = [Configure SYS_UI_SCALE:44];
    self.getVerifyCodeButtonHeight.constant = [Configure SYS_UI_SCALE:44];
    self.verifyButtonHeight.constant = [Configure SYS_UI_BUTTON_HEIGHT];
    
    //self.verifyButton.alpha = 0.5;
    //self.verifyButton.enabled = NO;
    
    [_verifyCodeField becomeFirstResponder];
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
-(void)timerAction{
    
    count--;
    if (count>0) {
        [self.verifyCodeSendButton setTitle:[NSString stringWithFormat:@"(%d)重新获取",count] forState:UIControlStateNormal];
    }
    else{
        if ([timer isValid]) {
            [timer invalidate];
        }
        
        [UitlCommon setFlatWithView:_verifyCodeSendButton
                             radius:[Configure SYS_CORNERRADIUS]
                        borderColor:[Configure SYS_UI_COLOR_BG_RED]
                        borderWidth:1];
        
        [self.verifyCodeSendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.verifyCodeSendButton setTitleColor:[Configure SYS_UI_COLOR_BG_RED] forState:UIControlStateNormal];
        
        count = 0;
    }
}

-(IBAction)clickGetVerifyCodeButton:(id)sender{
    
    if (count==0) {
        
        __weak typeof(self) weakSelf = self;
        
        UserInfoModel *model = [SaveEngine getUserInfo];
        [self showHudInView:self.view hint:@"发送中"];
        [self sendMsg:model.telephone
                 type:_type
               comple:^(BOOL bSuccess, NSString *des) {
                   [weakSelf hideHud];
                   
                   if (bSuccess) {
                    
                       [weakSelf showHint:@"短信发送成功"];
                       count = kTimeOut;
                       
                       [weakSelf.verifyCodeSendButton setTitleColor:[UIColor colorWithRed:229.0/255 green:218.0/255 blue:217.0/255 alpha:1] forState:UIControlStateNormal];
                       [UitlCommon setFlatWithView:weakSelf.verifyCodeSendButton radius:4 borderColor:[UIColor colorWithRed:229.0/255 green:218.0/255 blue:217.0/255 alpha:1] borderWidth:0.5];
  
                       [weakSelf.verifyCodeSendButton setTitle:[NSString stringWithFormat:@"(%d)重新获取",count] forState:UIControlStateNormal];
                       
                       if (timer.valid) {
                           [timer invalidate];
                       }
                       timer =  [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(timerAction) userInfo:nil repeats:count];

                   }
                   else{
                       [weakSelf showHint:des];
                   }
               }];
      
    }
}

-(IBAction)clickVerifyButton:(id)sender{
    

        if (![UitlCommon isNull:self.verifyCodeField.text]) {
            
            __weak typeof(self) weakSelf = self;
        
            
            [self showHudInView:self.view hint:nil];
                 UserInfoModel *model = [SaveEngine getUserInfo];
            [self checkMsgCode:model.telephone
                          type:_type
                          code:self.verifyCodeField.text
                       success:^(NSString *smsToken) {
                           [weakSelf hideHud];
                           
                           if (weakSelf.type == SMSType_SetPayPWD) {
                               CashPasswordSetingSecondViewController *vc = [[CashPasswordSetingSecondViewController alloc] initWithNibName:@"CashPasswordSetingSecondViewController" bundle:nil];
                               vc.smsToken = smsToken;
                               [weakSelf.navigationController pushViewController:vc animated:YES];
                           }

          
                           
                           
                       } failed:^(NSString *errorDes) {
                           [weakSelf hideHud];
                           [weakSelf showHint:errorDes];
                       }];
            
            
        }
    

}

#pragma mark textField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    

//    if ([UitlCommon judageTextIsVaild:textField.text newText:string]) {
//        self.verifyButton.alpha = 1;
//        self.verifyButton.enabled = YES;
//    }
//    else{
//        self.verifyButton.alpha = 0.5;
//        self.verifyButton.enabled = NO;
//    }
    return YES;
}

@end
