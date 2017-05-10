//
//  CashPasswordSetingSecondViewController.m
//  legend
//
//  Created by heyk on 15/12/1.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import "CashPasswordSetingSecondViewController.h"
#import "UIViewController+HUD.h"
#import "legend_business_ios-swift.h"


static  int cashPassowrdCount = 6;

@interface CashPasswordSetingSecondViewController ()<UITextFieldDelegate>{
    
    UITextField *responsTextField;
    BOOL bOnFisrtPage;
    NSString *firstPassword;
    
}

@end

@implementation CashPasswordSetingSecondViewController


-(void)dealloc{
    
    [responsTextField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    self.title = @"设置交易密码";
    self.inPutHeight.constant = [Configure  SYS_UI_SCALE:45];
    self.tipLabel.font = [UIFont systemFontOfSize:[Configure SYS_FONT_SCALE:14]];
    self.messageLabel.font = [UIFont systemFontOfSize:[Configure SYS_FONT_SCALE:14]];
    self.messageLabel.textColor = [Configure SYS_UI_COLOR_BG_RED];
    
    
    [UitlCommon setFlatWithView:_inputView
                         radius:[Configure SYS_CORNERRADIUS]
                    borderColor:[Configure SYS_UI_COLOR_LINE_COLOR]
                    borderWidth:1];
    
    responsTextField = [[UITextField alloc] init];
    responsTextField.delegate = self;
    
    [self.view addSubview:responsTextField];
    responsTextField.keyboardType = UIKeyboardTypeNumberPad;
    [responsTextField becomeFirstResponder];
    
    bOnFisrtPage = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self setBord];
}
-(void)setBord{
    
    for (int i=0; i<cashPassowrdCount-1; i++) {
        
        UIView *view = [_inputView viewWithTag:i+1];
        if (view) {
            float w = ([UIScreen mainScreen].bounds.size.width- 20)/6;
            
            CALayer *TopBorder = [CALayer layer];
            TopBorder.frame = CGRectMake(w, 0.0f,1, self.inPutHeight.constant);
            TopBorder.backgroundColor = [Configure SYS_UI_COLOR_LINE_COLOR].CGColor;
            [view.layer addSublayer:TopBorder];
        }
        
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
-(void)startSeting{
    
    [responsTextField resignFirstResponder];
    [self showHudInView:self.view hint:@"设置中"];
    
    __weak typeof(self) weakSelf = self;
    
    
    [self modifyPassword:responsTextField.text
             oldPassword:nil
                smsToken:_smsToken
                    type:2
                  comple:^(BOOL bSuccess, NSString *message) {
                      [weakSelf hideHud];
                      if ( bSuccess) {
                          [weakSelf showHint:@"设置成功"];
                          
                          UserInfoModel *model = [SaveEngine getUserInfo];
                          model.payment_pwd = [[NSNumber numberWithBool:YES] stringValue];
                          [SaveEngine saveUserInfo:model];
                          
                          if (weakSelf.navigationController.viewControllers.count>=3) {
                              [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:weakSelf.navigationController.viewControllers.count-3] animated:YES];
                          }
                          else   [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                          
                      }
                      else{
                          
                          [weakSelf showHint:message];
                      }
                  }];
    
}


#pragma mark  UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSMutableString *str = [NSMutableString stringWithString:textField.text];
    if ([string isEqualToString:@""]) {
        [str replaceCharactersInRange:NSMakeRange(str.length - 1, 1) withString:@""];
    }
    else   [str appendString:string];
    
    if (str.length>cashPassowrdCount) {
        return NO;
    }
    
    return YES;
    
}

-(void)toFistPage{
    
    self.tipLabel.text = @"请设置交易密码用于支付，提现等现金交易";
    firstPassword = nil;
    responsTextField.text = nil;
    [self textChanged];
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         CGRect frame = _inputView.frame;
                         frame.origin.x = [Configure SYS_UI_WINSIZE_WIDTH];
                         
                         _inputView.frame = frame;
                         
                     } completion:^(BOOL finished) {
                         
                         CGRect frame = _inputView.frame;
                         frame.origin.x = 10;
                         _inputView.frame = frame;
                         
                         bOnFisrtPage = YES;
                         
                     }];
    
}

-(void)toSecondPage{
    self.tipLabel.text = @"请再次输入密码";
    firstPassword = responsTextField.text;
    responsTextField.text = nil;
    [self textChanged];
    self.messageLabel.text = nil;
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         CGRect frame = _inputView.frame;
                         frame.origin.x = -[Configure SYS_UI_WINSIZE_WIDTH];
                         
                         _inputView.frame = frame;
                         
                     } completion:^(BOOL finished) {
                         
                         CGRect frame = _inputView.frame;
                         frame.origin.x = 10;
                         _inputView.frame = frame;
                         
                         bOnFisrtPage = NO;
                         
                     }];
}


-(void)judageContent{
    
    if (![responsTextField.text isEqualToString:firstPassword]) {
        
        self.messageLabel.text = @"两次输入密码不一致";
        [self toFistPage];
    }
    else{
        [self startSeting];
    }
}


-(void)textChanged{
    
    for (int i=0; i<cashPassowrdCount; i++) {
        
        int tag = i+1;
        UIImageView *imageV = [_inputView viewWithTag:tag];
        if (imageV) {
            
            if (responsTextField.text.length >=tag) imageV.image = [UIImage imageNamed:@"yuan"];
            else{
                imageV.image = nil;
                NSLog(@"---");
            }
            
        }
        
    }
    
    if (responsTextField.text.length == cashPassowrdCount) {
        if (bOnFisrtPage) {
            [self toSecondPage];
        }
        else{
            [self judageContent];
        }
        
    }
    
}

@end
